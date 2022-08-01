# `curated-system-images`

This repository builds a set of curated Julia system images for various use
cases. Monthly builds are created based on the latest release version of Julia
along with the latest versions of all packages built into each particular
system image `Manifest.toml`. If any serious bugs are found in the versions
used by the current month's system image then patch releases will be made so
long as the upstream packages fix the issues.

The generated system images are use by the
[`CuratedSystemImages.jl`](https://github.com/MichaelHatherly/CuratedSystemImages.jl)
repository. If you want to run one of the system images provided here please
make use of that Julia package rather than directly linking to the artifacts
generated from this repository.

## Adding new images

Add a folder to `sysimages` named after the image you would like to add.
`Pkg.add` all the required packages to an environment in that folder. Add a
`precompile.jl` script to that folder to exercise the code. Include the new
image name in the BuildImages CI config in the `image` field of the build
`matrix`.
