"""
    mean(C::AbstractArray)

Compute the mean of the collection C.
"""
function mean(C::AbstractArray)
    sum(C)/length(C)
end

"""
    STD(C::AbstractArray)

Compute the standard deviation of the collection C.
"""
function STD(C::AbstractArray)
    sqrt.( sum( (C.-TaylorDiag.mean(C)).^2 ) ./ length(C) )
end

"""
    RMSD(Cr::AbstractArray,C::AbstractArray)

Compute the root mean-squared deviation between reference collection Cr and C.
"""
function RMSD(Cr::AbstractArray,C::AbstractArray)
    sqrt.( sum( ( C.- TaylorDiag.mean(C) .- Cr .+ TaylorDiag.mean(Cr)).^2 ) ./ length(C))
end

"""
    COR(Cr::AbstractArray,C::AbstractArray)

Compute the correlation coefficient between reference collection Cr and C.
Note: the function exactly returns the minimum between 1.0 and the formula because of numerical errors.
```julia
Cr = [1.0, 2.0, 3.0]
C  = [1.0, 2.0, 3.0]
Correlation = sum( (C.-mean(C)) .* (Cr.-mean(Cr)) ) ./ (length(C) .* STD(C) .* STD(Cr))
```
In this case, `correlation=1.0000000000000002`, or `correlation=1+2e-16`, being the computational error because of (1/3) (and multiples) rounding.

"""
function COR(Cr,C)
    round(sum( (C.- TaylorDiag.mean(C)) .* (Cr.- TaylorDiag.mean(Cr)) ) ./ (length(C) .* STD(C) .* STD(Cr)),digits=15)
end