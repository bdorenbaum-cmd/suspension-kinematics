function shiftedWCP = shift_wheel_contact_patch(tire_radius, WC, WCP)
if WC(2) - WCP(2) == 0
    % If denomintor for slope m is 0, line will be infinite. Return WCP
    shiftedWCP = WCP;
    return
end

% Slope in the (y,z) plane
m = (WC(3) - WCP(3)) / (WC(2) - WCP(2));

% Solve for both possible y-values on the circle
dy = sqrt(tire_radius^2 / (1 + m^2));
y1 = WC(2) + dy;
y2 = WC(2) - dy;

% Select the one closest to previous contact point (physical choice)
if abs(y1 - WCP(2)) < abs(y2 - WCP(2))
    y_contact = y1;
else
    y_contact = y2;
end

z_contact = m * (y_contact - WC(2)) + WC(3);

shiftedWCP = [WC(1), y_contact, z_contact];
end