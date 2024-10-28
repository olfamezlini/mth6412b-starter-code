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

"""Retourne le maximum d'une queue abstraite."""
maximum(q::AbstractQueue) = maximum(q.items)

"""Définition de la méthode de comparaison pour PriorityItem."""
function Base.isless(a::PriorityItem, b::PriorityItem)
    return a.weight < b.weight
end

"""Diminue le poids d'un élément spécifié dans la file de priorité."""
function decrease_key!(q::PriorityQueue, node::Int64, new_weight::Float64)
    for i in 1:length(q.items)
        if q.items[i].node == node
            if new_weight < q.items[i].weight
                q.items[i].weight = new_weight
                return true
            else
                throw(ArgumentError("La nouvelle clé doit être inférieure à l'ancienne clé."))
            end
        end
    end
    throw(ArgumentError("No such node found in the priority queue."))
end


# Exemple de test de la structure PriorityQueue TEMPORAIRE SERA EFFACÉE APRES
function test_priority_queue()
    # Création d'une file de priorité
    pq = PriorityQueue{PriorityItem}()

    # Ajout d'éléments à la file de priorité
    push!(pq, PriorityItem(5.0, 1))
    push!(pq, PriorityItem(3.0, 2))
    push!(pq, PriorityItem(8.0, 3))
    push!(pq, PriorityItem(1.0, 4))

    # Affichage des éléments de la file de priorité
    println("Éléments dans la file de priorité : ", pq.items)
    println("Élément 1 dans la file de priorité : ", pq.items[1].node)
    println("poids Élément 1 dans la file de priorité : ", pq.items[1].weight)
    
    # Retirer et afficher l'élément avec la plus basse priorité
    lowest_priority_item = popfirst!(pq)
    println("Élément retiré avec la plus basse priorité : ", lowest_priority_item)
    println("node de element retiré dans la file de priorité : ", lowest_priority_item.node)
    println("poids de element retiré dans la file de priorité : ", lowest_priority_item.weight)

    # Afficher les éléments restants dans la file de priorité
    println("Éléments restants dans la file de priorité : ", pq.items)

    # Tester decrease_key!
    println("Diminuer le poids de l'élément avec node 3 à 2.0.")
    decrease_key!(pq, 3, 2.0)

    # Afficher les éléments après la diminution de clé
    println("Éléments après diminution de clé : ", pq.items)

    
end

# Appeler la fonction de test
test_priority_queue()
