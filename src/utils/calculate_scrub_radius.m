function scrubRadius = calculate_scrub_radius(UO, LO, WC, WCP)
d = UO - LO;

% Solve for parameter t where steering axis z = WCP z
% WCP = UO + t*d
t = (WCP(3) - UO(3)) / d(3);

% Intersection of steering axis with ground plane (z = CP z)
SA_ground = UO + t * d;

scrubRadiusInches = WC(2) - SA_ground(2);

scrubRadius = convert_inches_to_mm(scrubRadiusInches);
end