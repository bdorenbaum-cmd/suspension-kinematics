function points = intersection_of_spheres(c1, c2, c3)
arguments (Input)
    c1
    c2
    c3
end

arguments (Output)
    points
end

% Extract centers and radii
P1 = [c1.x, c1.y, c1.z];
P2 = [c2.x, c2.y, c2.z];
P3 = [c3.x, c3.y, c3.z];

r1 = c1.r; 
r2 = c2.r; 
r3 = c3.r;

% Vector from P1 to P2
ex = P2 - P1;
d = norm(ex);
if d == 0
    points = [];
    return;
end
ex = ex / d;

% Vector from P1 to P3
P3P1 = P3 - P1;
i = dot(ex, P3P1);

% Compute ey
temp = P3P1 - i * ex;
temp_norm = norm(temp);
if temp_norm == 0
    % Points are collinear → infinite or no intersection
    points = [];
    return;
end
ey = temp / temp_norm;

% Compute ez
ez = cross(ex, ey);

% Coordinates of P3 in the basis (ex, ey, ez)
j = dot(ey, P3P1);

% Solve for x, y
x = (r1^2 - r2^2 + d^2) / (2*d);
y = (r1^2 - r3^2 + i^2 + j^2 - 2*i*x) / (2*j);

% Check if z is real
z_sq = r1^2 - x^2 - y^2;
if z_sq < 0
    points = [];  % No real intersection
    return;
end
z = sqrt(z_sq);

% Two solutions: +z and -z
sol1 = P1 + x*ex + y*ey + z*ez;
sol2 = P1 + x*ex + y*ey - z*ez;

points = [sol1; sol2];
end
