function fvic = calculate_fvic(P, UO, LO, WC)
[x0, v] = calculate_instant_axis(P, UO, LO);

% Solve for intersection with side-view plane at X = WC(1)
t = (WC(1) - x0(1)) / v(1);

% Compute 3D coordinates of intersection by using t we just computed
fvic = x0 + t * v;
end