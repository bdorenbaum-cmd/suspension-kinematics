function points = intersection_of_circles(c1, c2, desired_z)
arguments (Input)
    c1
    c2
    desired_z
end

arguments (Output)
    points
end

% Shift radii to account for fixed Z-plane
R1 = sqrt( c1.r^2 - (desired_z - c1.z)^2 );
R2 = sqrt( c2.r^2 - (desired_z - c2.z)^2 );

% If radii are imaginary → no intersection with this Z-plane
if ~isreal(R1) || ~isreal(R2)
    points = [];
    return;
end

% Coordinates in XY plane
x1 = c1.x; y1 = c1.y;
x2 = c2.x; y2 = c2.y;

% Distance between circle centers
dx = x2 - x1;
dy = y2 - y1;
d = hypot(dx, dy);

% No intersection cases
if d > R1 + R2 || d < abs(R1 - R2) || d == 0
    points = [];
    return;
end

% Find the point where the line between centers intersects the radical line
a = (R1^2 - R2^2 + d^2) / (2*d);
h = sqrt(R1^2 - a^2);

% Base point along center-to-center line
xm = x1 + a * dx / d;
ym = y1 + a * dy / d;

% Intersection points
rx = -dy * (h / d);
ry =  dx * (h / d);

p1 = [xm + rx, ym + ry, desired_z];
p2 = [xm - rx, ym - ry, desired_z];

points = [p1; p2];
end