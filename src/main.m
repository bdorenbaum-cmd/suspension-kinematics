function main()
TRAVEL_DELTA = 24;
BRAKE_BIAS_PERCENT = 60;
COG_HEIGHT_INCHES = convert_mm_to_inches(269);
WHEEL_BASE = 60.5; % TODO: derive from rear WC point

displacements = (-TRAVEL_DELTA:1:TRAVEL_DELTA).';

n = numel(displacements);
results = dictionary;

P = get_kinematic_points();

for i = 1:n

    target_displacement = displacements(i);
    
    [UO, LO, TRO, WC, WCP] = displace_wheel_center(P,target_displacement);

    result.UO = UO;
    result.LO = LO;
    result.TRO = TRO;
    result.WC = WC;
    result.WCP = WCP;

    % Wheel Center Z in mm (this is the true value wheel travel)
    result.z_displacement = convert_inches_to_mm(result.WC(3) - P.FWC(3));

    % Camber
    result.camber = calculate_camber(result.WC, result.WCP);

    % Caster
    result.caster = calculate_caster(result.UO, result.LO);

    % Mechancial Trail
    result.mechanical_trail = calculate_mechanical_trail(result.UO, result.LO, result.WCP);

    % Scrub Radius
    result.scrub_radius = calculate_scrub_radius(result.UO, result.LO, result.WC, result.WCP);

    % Toe
    result.toe = calculate_toe(result.LO, result.UO, result.TRO);

    % Instant Centers
    result.fvic = calculate_fvic(P, result.UO, result.LO, result.WC);
    result.svic = calculate_svic(P, result.UO, result.LO, result.WC);

    % Anti Dive
    result.anti_dive_percent = calculate_anti_dive(result.WCP, result.svic, BRAKE_BIAS_PERCENT, COG_HEIGHT_INCHES, WHEEL_BASE);

    % Anti Lift
    result.anti_lift_percent = calculate_anti_lift();

    % Roll Center Height (heave)
    result.roll_center_heave = calculate_roll_center_heave(result.fvic, result.WCP);

    results{target_displacement} = result;
end

% Build numeric arrays from dictionary for plotting
z_disp             = zeros(n,1);
camber             = zeros(n,1);
caster             = zeros(n,1);
mech_trail         = zeros(n,1);
scrub_radius       = zeros(n,1);
toe                = zeros(n,1);
anti_dive_percent  = zeros(n,1);
anti_lift_percent  = zeros(n,1);
rc_heave           = zeros(n,1);
rc_roll            = zeros(n,1); 
roll_angle         = zeros(n,1);

for i = 1:n
    target_displacement = displacements(i);

    current = results{target_displacement};
    opposite = results{-target_displacement};

    z_disp(i)            = current.z_displacement;
    camber(i)            = current.camber;
    caster(i)            = current.caster;
    mech_trail(i)        = current.mechanical_trail;
    scrub_radius(i)      = current.scrub_radius;
    toe(i)               = current.toe;
    anti_dive_percent(i) = current.anti_dive_percent;
    anti_lift_percent(i) = current.anti_lift_percent;
    rc_heave(i)          = current.roll_center_heave;
    rc_roll(i)           = calculate_roll_center_roll(current.WCP, current.fvic, opposite.WCP, opposite.fvic);
    roll_angle(i)        = calculate_roll_angle(current.WCP, opposite.WCP);
end

% Calculate camber rate based on array of results
camber_rate  = calculate_camber_rate(camber);

% Closing to reset old figures if left open
close all;

% === Camber vs. Displacement ===
figure('Name', 'Camber Rate', 'NumberTitle', 'off');
plot(z_disp, camber_rate, 'o-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Camber Change (deg)');
title('Camber Rate');
grid on;

% === Caster vs. Displacement ===
figure('Name', 'Caster Rate', 'NumberTitle', 'off');
plot(z_disp, caster, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Caster Change (deg)');
title('Caster Rate');
grid on;

% === Kingpin vs. Displacement ===
% TODO: Implement

% === Mechanical Trail vs. Displacement ===
figure('Name', 'Mechancial Trail', 'NumberTitle', 'off');
plot(z_disp, mech_trail, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Mechancial Trail (mm)');
title('Mechancial Trail');
grid on;

% === Scrub Radius vs. Displacement ===
figure('Name', 'Scrub Radius', 'NumberTitle', 'off');
plot(z_disp, scrub_radius, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Scrub Radius (mm)');
title('Scrub Radius');
grid on;

% === Toe vs. Displacement (Bump Steer) ===
figure('Name', 'Bump Steer', 'NumberTitle', 'off');
plot(z_disp, toe, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Toe Change (deg)');
title('Bump Steer');
grid on;

% === Anti-Dive Percent vs. Displacement ===
figure('Name', 'Anti-Dive Angle', 'NumberTitle', 'off');
plot(z_disp, anti_dive_percent, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Anti-Dive (%)');
title('Anti-Dive Angle');
grid on;

% === Anti-Lift Percent vs Displacement ===
figure('Name', 'Anti-Lift Angle', 'NumberTitle', 'off');
plot(z_disp, anti_lift_percent, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Anti-Lift (%)');
title('Anti-Lift Angle');
grid on;

% === Roll Center Height (Heave) ===
figure('Name', 'Roll Center (Heave)', 'NumberTitle', 'off');
plot(z_disp, rc_heave, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Roll Center Height (mm)');
title('Roll Center (Heave)');
grid on;

% === Roll Center Height (Roll) ===
figure('Name', 'Roll Center (Roll)', 'NumberTitle', 'off');
plot(roll_angle, rc_roll, 's-', 'LineWidth', 1.5);
xlabel('Roll Angle (deg)');
ylabel('Roll Center Height (mm)');
title('Roll Center (Roll)');
grid on;

end