function svic = calculate_svic(UCA, UCF, LCA, LCF, UO, LO, WC)
[x0, v] = calculate_instant_axis(UCA, UCF, LCA, LCF, UO, LO);

% Solve for t when it intersects plane Y = WC(2)
t = (WC(2) - x0(2)) / v(2);

% Compute 3D coordinates of intersection from t we just computed
svic = x0 + t * v;
end