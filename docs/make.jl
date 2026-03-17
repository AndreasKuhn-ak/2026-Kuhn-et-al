using TrypColonies
using Documenter

DocMeta.setdocmeta!(TrypColonies, :DocTestSetup, :(using TrypColonies); recursive=true)

makedocs(;
    modules=[TrypColonies],
    authors="AndreasKuhn-ak <andreaskuhn92@gmx.net> and contributors",
    sitename="TrypColonies.jl",
    warnonly = true,
    format=Documenter.HTML(;
        canonical="https://AndreasKuhn-ak.github.io/2026-Kuhn-et-al",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => "manual.md",
        "Structure of the Model" => "structure.md",
        "API" => "reference.md",
    ],
)

deploydocs(;
    repo="github.com/AndreasKuhn-ak/2026-Kuhn-et-al",
    devbranch="master",
)
