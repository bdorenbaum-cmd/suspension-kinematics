function toe = calculate_toe(LO,UO,TRO)
% Knuckle-plane normal (order matters; ensure outward direction)
v2 = TRO - UO;
v1 = TRO - LO;
knuckle = cross(v1, v2);

% Top (x–y) view; ignore z
toe = atan2d(knuckle(1), knuckle(2));
end