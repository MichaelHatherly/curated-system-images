import JuliaSyntax
import JuliaSyntaxCore

Base.include(@__MODULE__(), joinpath(pkgdir(JuliaSyntax), "sysimage", "precompile_exec.jl"))
