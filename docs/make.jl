using Documenter, DEBStandardModel

makedocs(
    modules = [DEBStandardModel],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "HenriLaurie",
    sitename = "DEBStandardModel.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/HenriLaurie/DEBStandardModel.jl.git",
    push_preview = true
)
