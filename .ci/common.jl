import JSON3

function set_json_output(name, value)
    @info "debug" value
    println(stdout, "::set-output name=$name::$(JSON3.write(value))")
end

