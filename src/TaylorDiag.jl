module TaylorDiag

using Plots
import Plots: plot, ylabel!, ylims!, xlims!, scatter!, annotate!

export taylordiagram
include("taylor.jl")

export STD
export COR
export RMSD
include("stats.jl")

export to_polar
export taylor_verification
include("utils.jl")

end
