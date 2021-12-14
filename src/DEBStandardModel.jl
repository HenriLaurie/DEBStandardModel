"""
This is where module will be documented

#TODO
# plot l(tau) given AmP parameters as LongParams
# convert to plot of L(t) 
# getE0() [solves eb = f, given  uHb]
# runDEBstd(f, p::LongParams, timespan)
  ## runs getE0(), then then plots l(t), sets its own timespan 
# add reporting tau_b, l_b, maybe uHb also


"""
module DEBStandardModel

  using DifferentialEquations, Plots, DelimitedFiles
  gr()             #specify GR backend

  struct DEBstd  # specifies std model
    ## matching of function to u0 and parameters rests on user
    fname::Function
    growthparams::Vector{Float64}
    maturityparams::Vector{Float64}
    u0::Vector{Float64} 
  end

  function stdDEBscaled(du, u, p, t)  # eqns 2.26 to 2.28, DEB book 3rd ed
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

function makeparsdict(csvfilename)
  lines = readdlm(csvfilename,',') 
  parsdict = Dict(lines[i,1] => lines[i,2] for i = 1:size(lines)[1])
  return parsdict
  end

  function packDEBscaled_std(parsdict, fname = stdDEBscaled)
    # IN: 
    ## parsdict     Dict, keys are AmP symbols (as strings)
    ## 
    #
    # OUT:
    ## p::DEBstd

    #unpack parsdict to parameter names
    T_ref = parsdict["T_ref"]
    E_Hb = parsdict[ "E_Hb"]
    s_G = parsdict[ "s_G"]
    p_Am = parsdict["p_Am"]
    T_body = parsdict["T_body"]
    E_Hp = parsdict["E_Hp"]
    p_M = parsdict["p_M"]
    T_A = parsdict["T_A"]
    z = parsdict["z"]
    kap_P = parsdict["kap_P"]
    h_a = parsdict["h_a"]
    v = parsdict["v"]
    E_G = parsdict["E_G"]
    kap_R = parsdict["kap_R"]
    kap_X = parsdict["kap_X"]
    k_J = parsdict["k_J"]
    F_m = parsdict["F_m"]
    p_T = parsdict["p_T"]
    kap = parsdict["kap"]  
    f   = parsdict["f"]
    E0  = parsdict["E0"]

    # compute derived parameters
    k_M = p_M/E_G 
    E_m = p_Am/v    
    g   = E_G/(kap*E_m)  
    L_m = v/(g*k_M)
    L_T = p_T/p_M
    k   = k_J/k_M  
    lT  = L_T/L_m
    feedingyes, adultno = 0.0, 0.0
    uHb = E_Hb/(g*E_m*L_m^3) 
    uHp = E_Hp/(g*E_m*L_m^3) 
    uE0 = E0/(g*E_m*L_m^3)

    #pack the relevant vectors
    growthpars   = [f, g, kap, k, lT, feedingyes, adultno]
    maturitypars = [uHb, uHp]
    u0           = [uE0, 0.0, 0.0]  
  
    return DEBstd(fname, growthpars, maturitypars, u0) 
    
  end
  ## Hons course version: stdAmPparams = [f, g, kap, k, lT, feedingyes, adultno] 
  ## while uE0 is used to set initial condition 
  ## and uHb, uHb are used to set callbacks for solve
  ## 11 params in all 
  ## maybe make LongParams named tuple (stdAmParams, maturitylevels, uE0)
  ## and have a dummy/output function that sets up problem, solves it, plots l(t)

function output(p::DEBstd, tspan)
  f, growthpars, maturitypars, u0 = p.fname, p.growthparams, p.maturityparams, p.u0  
  prob = ODEProblem(f, u0, tspan, growthpars)

  #create stdDEBcallback
  uhb, uhp = maturitypars
  function reached_uHb(u, t, integrator)     u[3] - uhb         end
  function startfeeding!(integrator)      
    integrator.p[6] = 1.0 
    @show integrator.t    #uncomment this to see age at birth
    end
  function reached_uHp(u, t, integrator) u[3] - uhp end
  function nowadult!(integrator) integrator.p[7] = 0.0 end
  cbonuHb = ContinuousCallback(reached_uHb, startfeeding!)
  cbonuHp = ContinuousCallback(reached_uHp, nowadult!)
  stdDEBcallback = CallbackSet(cbonuHb, cbonuHp)

  #solve and plot
  sol = solve(prob, cb=stdDEBcallback)     
  plot(sol, vars=2 )
  # plot(title = "labelslater" ) #maybe add timestamp?

  end

function rundemo(datafile, tspan) # and another method for f as function? 
  parsdict = makeparsdict(datafile)
  runparams = packDEBscaled_std(parsdict)
  output(runparams, tspan)
  end

# test: rundemo("Msplendens_AmPfittedparams.csv", [0.0, 20.0]) should produce a specific figure

end # module

#=
NOTES

First target: plot entire l(t) given the AmP parameter values, also
return age at birth and length at birth.
Ten LongParams values: seven for growth model, two for maturity switches, one for initial state.
Environment via f is constant.

Second target: determine E0, given E_H^b and assuming e0 = f (or, if f is variable, then
equal to average of f)

Long term target: fit all parameters, 

=#