function svic = calculate_svic(P, UO, LO, WC)
[x0, v] = calculate_instant_axis(P, UO, LO);

% Solve for t when it intersects plane Y = WC(2)
t = (WC(2) - x0(2)) / v(2);

% Compute 3D coordinates of intersection from t we just computed
svic = x0 + t * v;
end