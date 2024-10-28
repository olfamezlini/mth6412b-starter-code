import Base.length, Base.push!, Base.popfirst!, Base.show
import Base.maximum

"""Type abstrait dont d'autres types de files dériveront."""
abstract type AbstractQueue{T} end

"""Type représentant une file avec des éléments de type T."""
mutable struct Queue{T} <: AbstractQueue{T}
    items::Vector{T}
end

Queue{T}() where T = Queue(T[])

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.items, item)
    q
end

"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.items)

"""Indique si la file est vide."""
is_empty(q::AbstractQueue) = length(q.items) == 0

"""Donne le nombre d'éléments sur la file."""
length(q::AbstractQueue) = length(q.items)

"""Affiche une file."""
show(q::AbstractQueue) = show(q.items)

"""Type abstrait pour les éléments de priorité."""
abstract type AbstractPriorityItem end

"""Type représentant un élément de priorité (mutable)."""
mutable struct PriorityItem <: AbstractPriorityItem
    weight::Float64
    node::Int64
end

"""File de priorité."""
mutable struct PriorityQueue{T <: AbstractPriorityItem} <: AbstractQueue{T}
    items::Vector{T}
end

PriorityQueue{T}() where T = PriorityQueue(T[])

"""Retire et renvoie l'élément ayant la plus basse priorité (poids minimum)."""
function popfirst!(q::PriorityQueue)
    # Assurer qu'il y a des éléments dans la file
    if is_empty(q)
        throw(ArgumentError("La file de priorité est vide"))
    end
    
    lowest = q.items[1]
    for item in q.items[2:end]
        if item < lowest
            lowest = item
        end
    end
    idx = findfirst(x -> x == lowest, q.items)
    deleteat!(q.items, idx)
    return lowest
end


"""Définition de la méthode de comparaison pour PriorityItem."""
function Base.isless(a::PriorityItem, b::PriorityItem)
    return a.weight < b.weight
end

