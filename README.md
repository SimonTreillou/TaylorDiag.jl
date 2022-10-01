# TaylorDiag

[![Build Status](https://github.com/SimonTreillou/TaylorDiag.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/SimonTreillou/TaylorDiag.jl/actions/workflows/CI.yml?query=branch%3Amain)

## What is a Taylor diagram

## How to use

You first need to add the package to your library.

```julia
using Pkd
Pkg.add("https://github.com/SimonTreillou/TaylorDiagram.jl.git")
using TaylorDiagram
``` 

## Example

```julia
using Random
using TaylorDiagram

# We first build observations (e.g. reference) using random distribution
obs = 10*rand(10)

# Then we build "modeled" datasets (here the observations with random noise)
mod = obs + rand(10)*4
mod2 = obs + rand(10)*2

# We compute standard deviations (S), root mean squared deviations (R)
# and correlations (C)
# Note that .... equation
S = [STD(obs),STD(mod), STD(mod2)]
R = [RMSD(obs,obs),RMSD(obs,mod), RMSD(obs,mod2)]
C = [COR(obs,obs),COR(obs,mod),COR(obs,mod2)]

# We then plot the Taylor diagram, here without special names added
taylordiagram(S,R,C)

# Here with special names added
names = ["Data1", "Data2", "Data3"]
taylordiagram(S,R,C,names)
```

![plot](./tutorial-taylor-diagram.png)

## Roadmap

- [x] Statistics tests
- [ ] Write functions descriptions
- [x] Add reference
- [ ] Write quick-quick documentation on the README
- [ ] Clean-up
- [ ] List what next
- [ ] Add options

## Contributing

Contributions are welcome. Please make a pull request so the community can enjoy it!

See contributor's guide badge for more informations: ColPrac: Contributor's Guide on Collaborative Practices for Community Packages.


## References

Taylor, Karl E. « Summarizing Multiple Aspects of Model Performance in a Single Diagram ». Journal of Geophysical Research: Atmospheres 106, nᵒ D7 (2001): 7183‑92. https://doi.org/10.1029/2000JD900719.
