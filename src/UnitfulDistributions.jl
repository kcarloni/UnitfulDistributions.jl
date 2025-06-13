module UnitfulDistributions

using Unitful: Quantity, oneunit
using Distributions
using Distributions: UnivariateDistribution
import Distributions: pdf 

    struct UnitfulDistribution{T<:UnivariateDistribution, Q<:Quantity}
        D::T
    end

    function UnitfulDistribution{UD}(args...) where UD
        args = promote( args... )
        T = typeof(args[1])
        UnitfulDistribution{UD, T}(
            UD( (args .÷ oneunit(T))... )
        )
    end

    function Base.getproperty( 
        UD::UnitfulDistribution{D, Q}, sym::Symbol ) where {D, Q}
        if sym == :D; return getfield( UD, :D )
        elseif sym in fieldnames( D )
            return getproperty( UD.D, sym ) * oneunit(Q)
        end
    end

    Distributions.StatsAPI.params( UD::UnitfulDistribution ) = params( UD.D )

    # ----------------------

    function pdf( UD::UnitfulDistribution{D, Q}, x::AbstractArray{Q,M} ) where {D, Q, M}
        return pdf( UD.D, x/oneunit(Q) ) / oneunit(Q)
    end

    # ----------------------

    # convenience constructor: allows you to write `Normal( 1s, 10s )`
    function (D::Type{T})( args::Vararg{Q,N} ) where {T<:UnivariateDistribution, Q<:Quantity, N}
        UnitfulDistribution{D}(args...)
    end

    # convenience constructor: allows you to write `Normal() * 1s`
    Base.:*( d::D, x::Quantity ) where {D <: Distribution} = UnitfulDistribution{D}( (params(d) .* x)... )

    export UnitfulDistribution

end # module UnitfulDistributions
