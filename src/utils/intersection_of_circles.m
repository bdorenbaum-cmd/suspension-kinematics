function points = intersection_of_circles(c1, c2, desired_z)
arguments (Input)
    c1,
    c2,
    desired_z
end

arguments (Output)
    points
end

syms x y;

S = solve( (x-c1.x)^2+(y-c1.y)^2+(desired_z-c1.z)^2==c1.r^2, ...
           (x-c2.x)^2+(y-c2.y)^2+(desired_z-c2.z)^2==c2.r^2, ...
           [x y], 'Real', true);

points = double([S.x, S.y, repmat(desired_z, size(S.x))]);
end