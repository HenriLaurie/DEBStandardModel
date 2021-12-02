module DEBStandardModel

using DifferentialEquations

struct ShortParams end #for getlbDEBstd

struct LongParams end #for getlbDEBstd

#TODO
# getE0() [solve eb = f ]
# runDEBstd(f, p::LongParams, timespan)
  ## first runs getE0, then runs model for some multiple of time at birth, plots l(t)

function scaledDEBstd(du, u, p::ShortParams, t)  # eqns 2.26 to 2.28, DEB book 3rd ed
    # version for getlbDEBstd
    g, kap, k  = p
    uE, l, uH = u
    du[1] = -uE*l^2 * (g+l)/(uE+l^3)
    du[2] = (1.0/3.0)*(g*uE - l^4)/(uE + l^3)
    du[3] = (1-kap) * uE*l^2 * (g+l)/(uE+l^3) - k*uH
  end

function scaledDEBstd(du, u, p::LongParams, t)  # eqns 2.26 to 2.28, DEB book 3rd ed
    # version for getlbDEBstd
    g, kap, k, lT, f, uHb, uHp  = p
    uE, l, uH = u
    juvreached = uH >= uHb
    adultreached = uH >= uHp 
    du[1] = adultreached*f*l^2 - uE*l^2 * (g+l)/(uE+l^3)
    du[2] = (1.0/3.0)*(g*uE - l^4 - lT)/(uE + l^3)
    du[3] = (1-adultreached)*((1-kap) * uE*l^2 * (g+l)/(uE+l^3) - k*uH )
end


end # module