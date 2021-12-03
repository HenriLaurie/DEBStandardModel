module DEBStandardModel

using DifferentialEquations

struct ShortParams end #for getlbDEBstd

struct LongParams end #for getlbDEBstd

#TODO
# getE0() [solve eb = f ]
# runDEBstd(f, p::LongParams, timespan)
  ## first runs getE0, then runs model for some multiple of time at birth, plots l(t)

function scaledDEBstd(du, u, p::ShortParams, t)  # eqns 2.26 to 2.28, DEB book 3rd ed
    # this version only works for embryo phase; it is used to determine tau_b 
    g, kap, k  = p
    uE, l, uH = u
    du[1] = -uE*l^2 * (g+l)/(uE+l^3)
    du[2] = (1.0/3.0)*(g*uE - l^4)/(uE + l^3)
    du[3] = (1-kap) * uE*l^2 * (g+l)/(uE+l^3) - k*uH
  end

function scaledDEBstd(du, u, p::LongParams, t)  # eqns 2.26 to 2.28, DEB book 3rd ed
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
  #check that all names are there
  #compute 

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