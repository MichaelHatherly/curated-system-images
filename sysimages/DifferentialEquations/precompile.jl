using DifferentialEquations

# TODO: windows CI builds seem to fail with this in system image creation.
if !Sys.iswindows()
    f(u,p,t) = 1.01*u
    u0 = 1/2
    tspan = (0.0,1.0)
    prob = ODEProblem(f,u0,tspan)
    solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)


    l = 1.0                             # length [m]
    m = 1.0                             # mass [kg]
    g = 9.81                            # gravitational acceleration [m/s²]

    function pendulum!(du,u,p,t)
        du[1] = u[2]                    # θ'(t) = ω(t)
        du[2] = -3g/(2l)*sin(u[1]) + 3/(m*l^2)*p(t) # ω'(t) = -3g/(2l) sin θ(t) + 3/(ml^2)M(t)
    end

    θ₀ = 0.01                           # initial angular deflection [rad]
    ω₀ = 0.0                            # initial angular velocity [rad/s]
    u₀ = [θ₀, ω₀]                       # initial state vector
    tspan = (0.0,10.0)                  # time interval

    M = t->0.1sin(t)                    # external torque [Nm]

    prob = ODEProblem(pendulum!,u₀,tspan,M)
    solve(prob)


    A  = [1. 0  0 -5
          4 -2  4 -3
         -4  0  0  1
          5 -2  2  3]
    u0 = rand(4,2)
    tspan = (0.0,1.0)
    f(u,p,t) = A*u
    prob = ODEProblem(f,u0,tspan)
    solve(prob)
end

