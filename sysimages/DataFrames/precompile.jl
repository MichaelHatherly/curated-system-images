using DataFrames, DataFramesMeta

# Examples below from the dataframesmeta tutorial:

df = DataFrame(a=[1, 2], b=[3, 4]);
@transform(df, :c = :a .* :b .+ first(:a) .- sum(:b))

df = DataFrame(x=[1, 1, 2, 2], y=[1, 2, 101, 102]);
gd = groupby(df, :x);
@select(df, :x, :y)
@select(df, :x2 = 2 * :x, :y)
@select(gd, :x2 = 2 .* :y .* first(:y))
@select!(df, :x, :y)
@select!(df, :x = 2 * :x, :y)
@select!(gd, :y = 2 .* :y .* first(:y))

df = DataFrame(x=[1, 1, 2, 2], y=[1, 2, 101, 102]);
gd = groupby(df, :x);
@transform(df, :x2 = 2 * :x, :y)
@transform(gd, :x2 = 2 .* :y .* first(:y))
@transform!(df, :x, :y)
@transform!(df, :x = 2 * :x, :y)
@transform!(gd, :y = 2 .* :y .* first(:y))

using Statistics
df = DataFrame(x=[1, 1, 2, 2], y=[1, 2, 101, 102]);
gd = groupby(df, :x);
outside_var = 1;
@subset(df, :x .> 1)
@subset(df, :x .> outside_var)
@subset(df, :x .> outside_var, :y .< 102)  # the two expressions are "and-ed"
@subset(gd, :x .> mean(:x))

df = DataFrame(x=[1, 1, 2, 2], y=[1, 2, 101, 102]);
gd = groupby(df, :x);
@combine(gd, :x2 = sum(:y))
@combine(gd, :x2 = :y .- sum(:y))
@combine(gd, $AsTable = (n1=sum(:y), n2=first(:y)))

df = DataFrame(x=[1, 1, 2, 2], y=[1, 2, 101, 102]);
gd = groupby(df, :x);
@combine(gd, $AsTable = (a=sum(:x), b=sum(:y)))

df = DataFrame(x=[1, 1, 2, 2], y=[1, 2, 101, 102]);
@orderby(df, -1 .* :x)
@orderby(df, :x, :y .- mean(:y))

df = DataFrame(x=1:3, y=[2, 1, 2])
x = [2, 1, 0]

@with(df, :y .+ 1)
@with(df, :x + x)  # the two x's are different

x = @with df begin
    res = 0.0
    for i in 1:length(:x)
        res += :x[i] * :y[i]
    end
    res
end

@with(df, df[:x.>1, ^(:y)])
