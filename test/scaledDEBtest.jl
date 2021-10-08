using DifferentialEquations, Plots
using DEBStandardModel

p = [0.0, 0.0] #3 parameters

println("$(p)")


DEBStandardModel.scaledDEBstd(0, 0, p, 0)