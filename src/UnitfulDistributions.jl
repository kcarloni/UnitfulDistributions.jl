module UnitfulDistributions

using Unitful: Quantity, oneunit
using Distributions: UnivariateDistribution
import Distributions: pdf 

    struct UnitfulDistribution{T<:UnivariateDistribution, Q<:Quantity}
        D::T
    end

    function UnitfulDistribution{UD}(args...) where UD
        args = promote( args... )
        T = typeof(args[1])
        UnitfulDistribution{UD, T}(
            UD( (args ./ oneunit(T))... )
        )
    end

    function Base.getproperty( 
        UD::UnitfulDistribution{D, Q}, sym::Symbol ) where {D, Q}
        if sym == :D; return getfield( UD, :D )
        elseif sym in fieldnames( D )
            return getproperty( UD.D, sym ) * oneunit(Q)
        end
    end

    function pdf( UD::UnitfulDistribution{D, Q}, x::Q ) where {D, Q}
        return pdf( UD.D, x/oneunit(Q) ) / oneunit(Q)
    end

    function (D::Type{T})( args::Vararg{Q,N} ) where {T<:UnivariateDistribution, Q<:Quantity, N}
        UnitfulDistribution{D}(args...)
    end

    export UnitfulDistribution

end # module UnitfulDistributions
