function distance = distance_between(vectorA, vectorB)
arguments (Input)
    vectorA
    vectorB
end

arguments (Output)
    distance
end

distance = norm(vectorA - vectorB);
end