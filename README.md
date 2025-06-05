Wrapper around Distributions.UnivariateDistribution to add support for units, see discussions in e.g. https://github.com/JuliaStats/Distributions.jl/issues/1413.

Currently, you can do things like:
```julia
julia> using Unitful

julia> using Distributions

julia> using UnitfulDistributions

julia> const s = u"s"

julia> gau = Normal(55s, 10s)
UnitfulDistribution{Normal, Quantity{Int64, 𝐓, FreeUnits{(s,), 𝐓, nothing}}}(Normal{Float64}(μ=55.0, σ=10.0))

julia> pdf( gau, 30s )
0.001752830049356854 s⁻¹
```