function mechanicalTrail = calculate_mechanical_trail(UO, LO, WCP)
axisVec = UO - LO;

% Find intersection of steering axis with ground plane
t0 = (WCP(3)-  LO(3)) / axisVec(3);
K  = LO + t0 * axisVec;

mechanicalTrailInches = K(1) - WCP(1);

mechanicalTrail = convert_inches_to_mm(mechanicalTrailInches);
end