"""
    taylor_verification(Cr::AbstractArray,C::AbstractArray)

Compute the equation E'² = σᵣ² + σf² - 2 σf σᵣ R to verify data and functions.
"""
function taylor_verification(Cr,C)
    RMSD(Cr,C).^2 .- STD(Cr).^2 .- STD(C).^2 .+ 2*STD(Cr)*STD(C)*COR(Cr,C)
end

"""
    to_polar(C::AbstractArray)

Function made to project a C cartesian collection (correlation coefficients) to a 1/4-circle polar projection.
"""
function to_polar(C::AbstractArray)
    real.(acos.(C))
end

"""
    normalize_std(S::AbstractArray)

Normalize the standard deviation collection with first STD (by default, the observations STD).
"""
function normalize_std(S::AbstractArray)
    [S[i]/S[1] for i in eachindex(S)] # by default, S[1] is the standard deviation of observations
end