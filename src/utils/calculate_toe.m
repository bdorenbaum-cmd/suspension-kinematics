function toe_deg = calculate_toe(WC, WCP, UO, LO)

k = UO - LO;        % steering axis
k = k / norm(k);

r = WCP - WC;       % radial vector
r = r / norm(r);

t = cross(k, r);    % wheel rolling direction
t(3) = 0;           % project to ground
t = t / norm(t);

toe_deg = atan2d(t(2), t(1));

end