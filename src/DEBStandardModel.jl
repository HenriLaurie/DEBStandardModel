module DEBStandardModel

using DifferentialEquations, Plots, DelimitedFiles

struct ShortParams # reduced form suitable for solving for E0.
  end

struct stdParams  # growth only (no reproduction or mortality or respiration etc) 
  f; g; kap; k; lT; feedingyes; adultno
  end 

struct LongParams # contains the full problem
  growthparams::stdParams
  maturityparams::Vector{Float64}
  uE0::Float64
  end



#TODO
# plot l(tau) given AmP parameters as LongParams
# convert to plot of L(t) 
# getE0() [solves eb = f, given  uHb]
# runDEBstd(f, p::LongParams, timespan)
  ## runs getE0(), then then plots l(t), sets its own timespan 
# add reporting tau_b, l_b, maybe uHb also

function scaledDEBstd(du, u, p::ShortParams, t)  # eqns 2.26 to 2.28, DEB book 3rd ed
    # this version only works for embryo phase; it is used to determine tau_b 
    g, kap, k  = p
    uE, l, uH = u
    du[1] = -uE*l^2 * (g+l)/(uE+l^3)
    du[2] = (1.0/3.0)*(g*uE - l^4)/(uE + l^3)
    du[3] = (1-kap) * uE*l^2 * (g+l)/(uE+l^3) - k*uH
  end

function scaledDEBstd(du, u, p::stdParams, t)  # eqns 2.26 to 2.28, DEB book 3rd ed
    # requires the parameter uE0 for initial condition
    # and juvreached better reset via callback at tau_b
    # and adultreached via callback on uH 
    # and perhaps u[4] for reproductive output?
    g, kap, k, lT, f, juvreached, adultreached  = p
    uE, l, uH = u
    du[1] = juvreached*f*l^2 - uE*l^2 * (g+l)/(uE+l^3)
    du[2] = (1.0/3.0)*(g*uE - l^4 - lT)/(uE + l^3)
    du[3] = (1-adultreached)*((1-kap) * uE*l^2 * (g+l)/(uE+l^3) - k*uH )
  end

function getscaledparams(fileAmPparsCSV)
  # IN: 
  ## fileAmPparsCSV       name, value  pairs
  #
  # OUT:
  ## p::LongParams

  #read file to dictionary
  #= 
     I decided to standardise on Add-my-Pet symbols for parameter names.
     Hence the long list below, I don't know how to make a name from a string.
  =#
  lines = readdlm("Msplendens_AmPfittedparams.csv",',') 
  parsdict = Dict(lines[i,1] => lines[i,2] for i = 1:size(lines)[1])
  T_ref = parsdict("T_ref")
  E_Hb = parsdict( "E_Hb")
  s_G = parsdict( "s_G")
  p_Am = parsdict("p_Am")
  T_body = parsdict("T_body")
  E_Hp = parsdict("E_Hp")
  p_M = parsdict("p_M")
  T_A = parsdict("T_A")
  z = parsdict("z")
  kap_P = parsdict("kap_P")
  h_a = parsdict("h_a")
  v = parsdict("v")
  E_G = parsdict("E_G")
  kap_R = parsdict("kap_R")
  kap_X = parsdict("kap_X")
  k_J = parsdict("k_J")
  F_m = parsdict("F_m")
  p_T = parsdict("p_T")
  kap = parsdict("kap")

  #compute and pack scaled parmeters into LongParams object


    
  end
  ## Hons course version: stdAmPparams = [f, g, kap, k, lT, feedingyes, adultno] 
  ## while uE0 is used to set initial condition 
  ## and uHb, uHb are used to set callbacks for solve
  ## 11 params in all 
  ## maybe make LongParams named tuple (stdAmParams, maturitylevels, uE0)
  ## and have a dummy/output function that sets up problem, solves it, plots l(t)
  end 

function output(params::LongParams, tspan)
  stdAmPparams, maturitylevels, uE0 = params  
  u0 = [uE0, 0.0, 0.0]
  prob = ODEProblem(scaledDEBstd, u0, stdAmPparams, t)

  #create stdDEBcallback
  uhb, uhp = maturitylevels
  function reached_uHb(u, t, integrator)     u[3] - uhb         end
  function startfeeding!(integrator)      
    integrator.p[6] = 1.0 
    @show integrator.t    #uncomment this to see age at birth
  end
  cbonuHb = ContinuousCallback(reached_uHb, startfeeding!)

  function reached_uHp(u, t, integrator) u[3] - uhp end
  function nowadult!(integrator) integrator.p[7] = 0.0 end
  cbonuHp = ContinuousCallback(reached_uHp, nowadult!)
  stdDEBcallback = CallbackSet(cbonuHb, cbonuHp)

  #solve and plot
  sol = solve(prob, stdDEBcallback)     
  plot(sol, vars=2 )
  # plot(title = "labelslater" ) #maybe add timestamp?

end


end # module

#=
NOTES

First target: plot entire l(t) given the AmP parameter values, also
return age at birth and length at birth.
The seven LongParams parameters here need additionally the initial value.
f is assumed constant.

Second target: determine E0, given E_H^b and assuming e0 = f (or, if f is variable, then
equal to average of f)

Long term target: fit all parameters, 

=#