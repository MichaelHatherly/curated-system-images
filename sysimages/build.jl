import Pkg
Pkg.instantiate()

import Dates
import TOML

import PackageCompiler

@info "clearing up outdated content from the depot."

Pkg.gc(; collect_delay=Dates.Day(0))

image = ARGS[1]
project = joinpath(@__DIR__, image)
precompile_execution_file = joinpath(project, "precompile.jl")

ext = Sys.iswindows() ? "dll" : Sys.isapple() ? "dylib" : "so"
sysimage_path = joinpath(project, "$image.$ext")

@info "building a system image for '$image'."

PackageCompiler.create_sysimage(;
    cpu_target="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)",
    include_transitive_dependencies=false,
    incremental=true,
    precompile_execution_file,
    project,
    sysimage_path
)

if !isfile(sysimage_path)
    @error "failed to generate system image file: $(sysimage_path)"
    exit(1)
end

if haskey(ENV, "CI")
    @info "removing `PackageCompiler` from the depot after use."
    Pkg.rm("PackageCompiler")
    Pkg.gc(; collect_delay=Dates.Day(0))

    @info "clearing the depot of unrequired data."
    folders = ("artifacts", "packages", "scratchspaces")
    for each in readdir(first(Base.DEPOT_PATH); join=true)
        basename(each) in folders || rm(each; recursive=true)
    end

    # Remove anything in the source directories that isn't either a Julia file
    # or a TOML file. Package authors should be using artifacts or
    # RelocatableFolders for assets that they would like to access at runtime
    # from their packages, otherwise they won't be relocatable.
    packages = joinpath(first(Base.DEPOT_PATH), "packages")
    for (root, dirs, files) in walkdir(packages)
        for file in files
            if endswith(file, ".jl") || endswith(file, ".toml")
                # Keep these files.
            else
                path = joinpath(root, file)
                try
                    rm(path)
                catch exception
                    @error "failed to remove file." path exception
                end
            end
        end
    end

    # Provide configuration in a `Config.toml` that can be used to control
    # behaviour of the post-processing of package sources, such as stripping
    # source files from the final bundle. TODO: test this.
    config_toml = joinpath(project, "Config.toml")
    if isfile(config_toml)
        config = TOML.parsefile(config_toml)
        packages = get(config, "packages", [])
        for each in packages
            name = each["name"]
            source = get(each, "source", true)
            if !source
                @info "removing source files from package" name
                for (root, dirs, files) in walkdir(joinpath(packages, each))
                    for file in files
                        path = joinpath(root, file)
                        if file == "$each.jl"
                            try
                                open(path, "w") do io
                                    println(
                                        io,
                                        """
                                        module $each
                                        end
                                        """
                                    )
                                end
                                @info "written dummy root file for package" name path
                            catch exception
                                @error "failed to overwrite file." exception
                            end
                        elseif endswith(file, ".jl")
                            try
                                rm(path)
                                @info "removed source file for package" name path
                            catch exception
                                @error "failed to remove file." path exception
                            end
                        end
                    end
                end
            end
        end
    end
end

@info "copying system image project and manifest to named environment in depot."

dst = joinpath(first(Base.DEPOT_PATH), "environments", image)
mkpath(dirname(dst))
cp(project, dst)
