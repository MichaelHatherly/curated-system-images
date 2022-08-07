import Pkg

ENV["DATADEPS_ALWAYS_ACCEPT"] = true

using PalmerPenguins, DataFrames
using AlgebraOfGraphics, CairoMakie

penguins = dropmissing(DataFrame(PalmerPenguins.load()))

axis = (width=225, height=225)
penguin_frequency = data(penguins) * frequency() * mapping(:species)

fg = draw(penguin_frequency; axis)
save("figure.png", fg, px_per_unit=3)

plt = penguin_frequency * mapping(color=:island)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

plt = penguin_frequency * mapping(color=:island, dodge=:island)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

plt = penguin_frequency * mapping(color=:island, stack=:island)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

penguin_bill = data(penguins) * mapping(:bill_length_mm, :bill_depth_mm)
fg = draw(penguin_bill; axis)
save("figure.png", fg, px_per_unit=3)

penguin_bill = data(penguins) * mapping(
    :bill_length_mm => (t -> t / 10) => "bill length (cm)",
    :bill_depth_mm => (t -> t / 10) => "bill depth (cm)",
)
fg = draw(penguin_bill; axis)
save("figure.png", fg, px_per_unit=3)

plt = penguin_bill * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

plt = penguin_bill * linear() * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

plt = penguin_bill * linear() * mapping(color=:species) + penguin_bill * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

plt = penguin_bill * (linear() + mapping()) * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

layers = linear() + mapping()
plt = penguin_bill * layers * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

layers = linear() + mapping(marker=:sex)
plt = penguin_bill * layers * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

layers = linear() + mapping(col=:sex)
plt = penguin_bill * layers * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

layers = linear() + mapping()
plt = penguin_bill * layers * mapping(color=:species, col=:sex)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

using AlgebraOfGraphics: density
plt = penguin_bill * density(npoints=50) * mapping(col=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

plt *= visual(colormap=:grayC, colorrange=(0, 6))
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

axis = (type=Axis3, width=300, height=300)
layer = density() * visual(Wireframe, linewidth=0.05)
plt = penguin_bill * layer * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

axis = (width=225, height=225)
layer = density() * visual(Contour)
plt = penguin_bill * layer * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

layers = density() * visual(Contour) + linear() + mapping()
plt = penguin_bill * layers * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

layers = density() * visual(Contour) + linear() + visual(alpha=0.5)
plt = penguin_bill * layers * mapping(color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

body_mass = :body_mass_g => (t -> t / 1000) => "body mass (kg)"
layers = linear() * mapping(group=:species) + mapping(color=body_mass, marker=:species)
plt = penguin_bill * layers
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

axis = (type=Axis3, width=300, height=300)
plt = penguin_bill * mapping(body_mass, color=:species)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

plt = penguin_bill * mapping(body_mass, color=:species, layout=:sex)
fg = draw(plt; axis)
save("figure.png", fg, px_per_unit=3)

