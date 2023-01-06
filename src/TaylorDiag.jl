module TaylorDiag

using Plots
import Plots: plot, ylabel!, ylims!, xlims!, scatter!, annotate!
using Measures
import Measures: mm

export taylordiagram
include("taylor.jl")

export STD
export COR
export RMSD
include("stats.jl")

export to_polar
export taylor_verification
export normalize_std
include("utils.jl")

export make_yaxis
include("plotting.jl")

end
