module DEBStandardModel

using DifferentialEquations

struct ShortParams 
  p 
end #for getlbDEBstd

struct LongParams end #for getlbDEBstd

#TODO
# getlbDEBstd() which uses
# scaledDEBstd() ... 3 parameter version

function scaledDEBstd(du, u, p::ShortParams, t)  # eqns 2.26 to 2.28, DEB book
    # version for getlbDEBstd
    g, kap, k  = p
    uE, l, uH = u
    du[1] = -uE*l^2 * (g+l)/(uE+l^3)
    du[2] = (1.0/3.0)*(g*uE - l^4)/(uE + l^3)
    du[3] = (1-kap) * uE*l^2 * (g+l)/(uE+l^3) - k*uHend
end # module

function scaledDEBstd(du, u, p::LongParams, t)  # eqns 2.26 to 2.28, DEB book
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