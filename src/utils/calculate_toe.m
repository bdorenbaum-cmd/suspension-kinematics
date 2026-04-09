function toe = calculate_toe(LCO, UCO, TRO)
% Knuckle-plane normal using LCO as the common base point
v1 = UCO - LCO;
v2 = TRO - LCO;
knuckle = cross(v1, v2);
% Top (x-y) view: angle from Y-axis gives toe
toe = atan2d(knuckle(1), knuckle(2));
end
