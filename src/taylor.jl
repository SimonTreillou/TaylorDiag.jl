function taylor_verification(Cr,C)
    RMSD(Cr,C).^2 .- STD(Cr).^2 .- STD(C).^2 .+ 2*STD(Cr)*STD(C)*COR(Cr,C)
end

function taylordiagram(S,R,C,names)

    rho   = S
    theta = real.(acos.(C))

    # Defining constants: upper bound of STD-axis
    limSTD   = findmax(S)[1]*2

    # Defining constants: Correlation ticks
    Cticks  = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 0.99]
    CticksP = real.(acos.(Cticks))


    #
    # PLOTTING
    #
    fig = plot(size=(600,600),dpi=600)
    plot!(grid=false,leg=false)
    ylims!((0., limSTD*1.01))
    xlims!((0., limSTD*1.01))
    ylabel!("Standard deviation")

    # Plotting points
    t     = -200:(pi/200):(pi/2)
    for i in 1:length(theta)
        scatter!([cos.(theta[i]).*rho[i]], [sin.(theta[i]).*rho[i]],color=:black)
        annotate!(cos.(theta[i]).*rho[i]+0.02*limSTD,sin.(theta[i]).*rho[i]+0.02*limSTD,names[i],8)
    end

    # Correlation circle and lines
    plot!(limSTD.*cos.(t),limSTD.*sin.(t),linecolor=:black)
    for i in 1:length()
        x = 0:0.01:cos(CticksP[i])*limSTD
        plot!(x,x.*tan(Cis[i]),linecolor="black",linestyle=:dashdot,alpha=0.3)
        if Ctiks[i]== 0.
            annotate!(cos(Cis[i])*limSTD*1.01+0.02*limSTD, sin(Cis[i])*limSTD*1.01, string(Cticks[i]),7)
        else
            annotate!(cos(Cis[i])*limSTD*1.01, cos(Cis[i])*limSTD*1.01*tan(Cis[i]),text(string(Cticks[i]), :black, :left, 7))
        end
    end
    annotate!(cos(pi/4)*limSTD*1.07,sin(pi/4)*limSTD*1.07, Plots.text("Correlation", 13, :dark, rotation = -45 ))

    # RMSD circles
    maxRMS = sqrt(S[1]^2 + limSTD^2)
    freRMS = 5
    angRMS = atan(S[1]/limSTD)+pi/2
    t     = 0:(pi/200):(2*pi)
    rx = cos.(theta[1]).*rho[1]
    ry = sin.(theta[1]).*rho[1]
    for i in (0.2*maxRMS):maxRMS/freRMS:(maxRMS*0.9)
        X = i.*cos.(t).+rx
        Y = i.*sin.(t).+ry
        show = isless.((i.*cos.(t).+rx).^2 + (i.*sin.(t).+ry).^2,limSTD^2)
        ix = findall(x->x==1,show)
        plot!(X[ix],Y[ix],linecolor=:grey,linestyle=:dash)
        annotate!((i+0.01).*cos.(angRMS).+rx,(i+0.01).*sin.(angRMS).+ry,Plots.text(string(round(i,digits=3)), 6, :dark, rotation = angRMS* 180/pi - 90))
    end

    fig

end


function taylordiagram(S,R,C)
    N = ["Obs"]
    for i in 2:length(S); push!(N,"Mod"*string(i)); end
    taylordiagram(S,R,C,N)
end