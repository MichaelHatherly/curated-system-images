include("common.jl")

let images = String[]
    for (root, dirs, files) in walkdir(joinpath(@__DIR__, ".."))
        for file in files
            if !contains(root, ".julia") && file == "precompile.jl"
                push!(images, last(splitpath(root)))
            end
        end
    end
    set_json_output("images", images)
end

