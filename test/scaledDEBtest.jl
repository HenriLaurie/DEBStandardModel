using Test
using DEBStandardModel, Plots  #NB: for test to pass, GR backend required
gr()                        

#DEBStandardModel.rundemo("../src/Msplendens_AmPfittedparams.csv", (0.0, 3.0))

@test typeof(DEBStandardModel.makeparsdict("src/Msplendens_AmPfittedparams.csv")) == Dict{SubString{String}, Real}
#@test typeof(DEBStandardModel.makeparsdict("../src/Msplendens_AmPfittedparams.csv")) == Dict
@test  typeof(DEBStandardModel.rundemo("src/Msplendens_AmPfittedparams.csv", (0.0, 3.0)))  == Plots.Plot{Plots.GRBackend}