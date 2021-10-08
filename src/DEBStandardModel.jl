module DEBStandardModel

#TODO
# getlbDEBstd() which uses
# scaledDEBstd() ... 3 parameter version

function scaledDEBstd(du, u, p, t)  # eqns 2.26 to 2.28, DEB book
    length(p) == 3 ? println("$p") : "OOPS, wrong number of params"

end


end # module