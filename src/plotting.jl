"""
    make_yaxis(fig,ang::Number,max::Number,label::String,ticks::Tuple)

Plot an axis from scratch when you want the y-axis to have an <90° angle with respect to the x-axis.

# Inputs

- `fig` : actual figure
- `ang` : angle between y and x-axis (in radians)
- `max` : maximum value of the axis
- `label` : label of the axis
- `ticks` : ticks of the axis (of the form Tuple : (ticks, tickslabels))
"""
function make_yaxis(fig,ang::Number,max::Number,label::String,ticks::Tuple)
    Y=range(0,max*1.02,10)
    plot!(fig,Y.*cos(ang),Y.*sin(ang),color=:black,width=:1)

    # Plotting ticks
    annotate!(cos(ang+pi/2)*max/12+(max/2)*cos(ang),sin(ang+pi/2)*max/12+(max/2)*sin(ang), Plots.text(label, 11, correlationcolor, rotation = ang * 180/pi))
    Y=range(0,max/100,10)
    for i in 1:length(ticks[1])
        plot!(Y.*cos(ang+pi/2).+ticks[1][i]*cos(ang),Y.*sin(ang+pi/2).+ticks[1][i]*sin(ang),color=:black,width=:1)
        annotate!(ticks[1][i]*cos(ang)+max/30*cos(ang+pi/2),ticks[1][i]*sin(ang)+max/30*sin(ang+pi/2),string(ticks[2][i]),8)
    end
end