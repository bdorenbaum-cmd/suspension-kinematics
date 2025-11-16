function points = intersection_of_spheres(c1, c2, c3)
arguments (Input)
    c1,
    c2,
    c3
end

arguments (Output)
    points
end

syms x y z;

S = solve( (x-c1.x)^2+(y-c1.y)^2+(z-c1.z)^2==c1.r^2, ...
           (x-c2.x)^2+(y-c2.y)^2+(z-c2.z)^2==c2.r^2, ...
           (x-c3.x)^2+(y-c3.y)^2+(z-c3.z)^2==c3.r^2, ...
           [x y z], 'Real', true);

points = double([S.x, S.y, S.z]);

end