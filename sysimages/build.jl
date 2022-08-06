import Pkg
Pkg.instantiate()

import Dates
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

if haskey(ENV, "CI")
    @info "clearing the depot of unrequired data."
    folders = ("artifacts", "packages", "scratchspaces")
    for each in readdir(first(Base.DEPOT_PATH); join=true)
        basename(each) in folders || rm(each; recursive=true)
    end
end

@info "copying system image project and manifest to named environment in depot."

dst = joinpath(first(Base.DEPOT_PATH), "environments", image)
mkpath(dirname(dst))
cp(project, dst)
