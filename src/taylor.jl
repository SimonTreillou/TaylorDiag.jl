"""
    taylordiagram(S::AbstractArray,C::AbstractArray,names::Vector{String};figsize=600,dpi=600,pointcolor=:black,pointfontsize=8,correlationcolor=:black,freRMS=5)
    taylordiagram(S::AbstractArray,C::AbstractArray;figsize=600,dpi=600,pointcolor=:black,pointfontsize=8,correlationcolor=:black,freRMS=5)
    taylordiagram(Cs::Union{Vector{Vector{Float64}}, Vector{Vector{Float32}}, Vector{Vector{Float16}}, Vector{Vector{Int64}}}, names::Vector{String};figsize=600,dpi=600,pointcolor=:black,pointfontsize=8,correlationcolor=:black,freRMS=5)
    taylordiagram(Cs::Union{Vector{Vector{Float64}}, Vector{Vector{Float32}}, Vector{Vector{Float16}}, Vector{Vector{Int64}}};figsize=600,dpi=600,pointcolor=:black,pointfontsize=8,correlationcolor=:black,freRMS=5)


Compute and plot the Taylor diagram. 4 different versions of the function are available :
- taylordiagram(S,C,N) plots the standard deviations `S` and correlation coefficients `C` with associated names `N`
- taylordiagram(S,C) plots the standard deviations `S` and correlation coefficients `C` with names "Obs" and "Mod1..i"
- taylordiagram(Cs) plots the Taylor diagram for the collections Cs=[Cr, C1, C2, ...] with names "Obs" and "Mod1..i" and compute standard deviations and correlation coefficients
- taylordiagram(Cs,N) plots the Taylor diagram for the collections Cs=[Cr, C1, C2, ...] with associated names `N` and compute standard deviations and correlation coefficients

# Options

- `figsize=600` : size of the figure
- `dpi=600` : dpi of the figure (Dots Per Inch)
- `pointcolor=:black` : color of the scattered points
- `pointfontsize=8` : font size of the names of the points
- `correlationcolor=:black` : color associated with correlation coefficients (dashed lines, 1/4-circle, etc.)
- `freRMS=5` : frequency of RMSD lines (grey circles)
- `normalize=false` :  STD normalization
- `RMSDcolor=:grey` :  RMSD lines and labels colors
- `ang=pi/2` : angle of the plot (e.g. ang=π/2 then we have 1/4-disc)
"""
function taylordiagram(S::AbstractArray,C::AbstractArray,names;figsize=600,dpi=600,pointcolor=:black,pointfontsize=8,correlationcolor=:black,freRMS=5,normalize=false,RMSDcolor=:grey,ang=pi/2)

    # Normalize if needed
    if normalize; S = normalize_std(S); end;
    
    # Defining polar coordinates
    rho   = S
    theta = to_polar(C)

    # Defining constants: upper bound of STD-axis
    limSTD   = findmax(S)[1]*2

    # Defining constants: Correlation ticks
    Cticks  = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 0.99]
    CticksP = to_polar(Cticks)
    filter!(x->x<ang,CticksP)
    filter!(x->to_polar(x)<ang,Cticks)

    # Plotting the figure
    ticks = (range(0,limSTD,5),round.(range(0,limSTD,5),digits=1))
    fig = Plots.plot(size=(figsize,figsize),dpi=dpi,grid=false,leg=false,xticks=ticks)
    ylims!((0., limSTD*1.01))
    xlims!((0., limSTD*1.02))
    xlabel!("Standard deviation",fontsize=11)
    ylabel!("Standard deviation",fontsize=11)
    if ang!=pi/2
        plot!(yaxis=false,yticks=false)
        ylabel!("")
        make_yaxis(fig,ang,limSTD,"Standard deviation",ticks)
    end

    # Plotting reference and model points
    for i in eachindex(theta)
        scatter!([cos.(theta[i]).*rho[i]], [sin.(theta[i]).*rho[i]],color=pointcolor)
        annotate!(cos.(theta[i]).*rho[i]+0.02*limSTD,sin.(theta[i]).*rho[i]+0.02*limSTD,name[i],pointfontsize)
    end

    # Correlation circle and lines
    t = range(0,ang,100)
    Plots.plot!(limSTD.*cos.(t), limSTD.*sin.(t), linecolor=correlationcolor)
    for i in eachindex(CticksP)
        x = 0:0.01:cos(CticksP[i])*limSTD
        Plots.plot!(x,x.*tan(CticksP[i]),linecolor=correlationcolor,linestyle=:dashdot,alpha=0.3)
        if Cticks[i]== 0.
            annotate!(cos(CticksP[i])*limSTD*1.01+0.02*limSTD, sin(CticksP[i])*limSTD*1.01, text(string(Cticks[i]), correlationcolor, :left, 7))
        else
            annotate!(cos(CticksP[i])*limSTD*1.01, cos(CticksP[i])*limSTD*1.01*tan(CticksP[i]),text(string(Cticks[i]), correlationcolor, :left, 7))
        end
    end
    annotate!(cos(ang/2)*limSTD*1.07,sin(ang/2)*limSTD*1.07, Plots.text("Correlation", 13, correlationcolor, rotation = (-90+ang/2*180/pi)))

    # RMSD circles
    maxRMS = sqrt((limSTD * sin(ang))^2 + (limSTD * cos(ang) - S[1])^2)
    angRMS = atan( (limSTD * sin(ang)) / (limSTD * cos(ang) - S[1]))
    #atan(S[1]/limSTD)+pi/2
    t = range(0,pi,200)
    rx = cos.(theta[1]).*rho[1]
    ry = sin.(theta[1]).*rho[1]
    for i in (0.2*maxRMS):maxRMS/freRMS:(maxRMS*0.9)
        X = i.*cos.(t).+rx
        Y = i.*sin.(t).+ry
        show = isless.(X.^2 + Y.^2,limSTD.^2) .&& isless.(Y,X.*tan(ang))
        ix = findall(x->x==1,show)
        Plots.plot!(X[ix],Y[ix],linecolor=RMSDcolor,linestyle=:dash)
        annotate!((i+0.01).*cos.(angRMS).+rx,(i+0.01).*sin.(angRMS).+ry,Plots.text(string(round(i,digits=3)), 6, RMSDcolor, rotation = angRMS* 180/pi - 90))
    end

    fig
end


function taylordiagram(S::AbstractArray,C::AbstractArray;figsize=600,dpi=600,pointcolor=:black,pointfontsize=8,correlationcolor=:black,freRMS=5,normalize=false,RMSDcolor=:grey)
    N = ["Obs"]
    for i in 2:length(S); push!(N,"Mod"*string(i-1)); end
    taylordiagram(S,C,N,figsize=figsize,dpi=dpi,pointcolor=pointcolor,pointfontsize=pointfontsize,correlationcolor=correlationcolor,freRMS=freRMS,normalize=normalize,RMSDcolor=RMSDcolor)
end


function taylordiagram(Cs::Union{Vector{Vector{Float64}}, Vector{Vector{Float32}}, Vector{Vector{Float16}}, Vector{Vector{Int64}}}, names::Vector{String};figsize=600,dpi=600,pointcolor=:black,pointfontsize=8,correlationcolor=:black,freRMS=5,normalize=false,RMSDcolor=:grey)
    S = STD.(Cs)
    C = [COR(Cs[1],Cs[i]) for i in eachindex(Cs)]

    taylordiagram(S,C,names,figsize=figsize,dpi=dpi,pointcolor=pointcolor,pointfontsize=pointfontsize,correlationcolor=correlationcolor,freRMS=freRMS,normalize=normalize,RMSDcolor=RMSDcolor)
end


function taylordiagram(Cs::Union{Vector{Vector{Float64}}, Vector{Vector{Float32}}, Vector{Vector{Float16}}, Vector{Vector{Int64}}};figsize=600,dpi=600,pointcolor=:black,pointfontsize=8,correlationcolor=:black,freRMS=5,normalize=false,RMSDcolor=:grey)
    S = STD.(Cs)
    C = [COR(Cs[1],Cs[i]) for i in eachindex(Cs)]

    taylordiagram(S,C,figsize=figsize,dpi=dpi,pointcolor=pointcolor,pointfontsize=pointfontsize,correlationcolor=correlationcolor,freRMS=freRMS,normalize=normalize,RMSDcolor=RMSDcolor)
end
    
    