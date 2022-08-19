include("common.jl")

let manifests = String[]
    root_dir = joinpath(@__DIR__, "..")
    for (root, dirs, files) in walkdir(root_dir)
        for file in files
            if !contains(root, ".julia") && file == "Manifest.toml"
                dir = relpath(root, root_dir)
                dir == "." || push!(manifests, dir)
            end
        end
    end
    set_json_output("manifests", manifests)
end

