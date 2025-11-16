function main()
TRAVEL_DELTA = 24;
BRAKE_BIAS_PERCENT = 60;
COG_HEIGHT_INCHES = convert_mm_to_inches(269);

EXPORT_GRAPHICS_FILE_NAME = "Suspension Report.pdf";
EXPORT_GRAPHICS_HEGIHT = "auto";
EXPORT_GRAPHICS_WIDTH = "auto";
EXPORT_GRAPHICS_PADDING = 30;

WHEEL_BASE = 60.5; % TODO: derive from rear WC point

displacements = (-TRAVEL_DELTA:1:TRAVEL_DELTA).';

n = numel(displacements);
front_results = dictionary;
rear_results = dictionary;

P = get_kinematic_points();

for i = 1:n

    target_displacement = displacements(i);

    %% Front Kinematic Calculations
    front_params = struct( ...
        "UCO",  P.FUCO, ...
        "UCF",  P.FUCF, ...
        "UCA",  P.FUCA, ...
        "LCO",  P.FLCO, ...
        "LCF",  P.FLCF, ...
        "LCA",  P.FLCA, ...
        "TRO",  P.FTRO, ...
        "TRI",  P.FTRI, ...
        "WC",  P.FWC, ...
        "WCP", P.FWCP, ...
        "displacement", target_displacement ...
    );
    
    [FUCO, FLCO, FTRO, FWC, FWCP] = displace_wheel_center(front_params);

    front.UCO = FUCO;
    front.LCO = FLCO;
    front.TRO = FTRO;
    front.WC = FWC;
    front.WCP = FWCP;

    % Wheel Center Z in mm (this is the true value wheel travel)
    front.z_displacement = convert_inches_to_mm(front.WC(3) - P.FWC(3));

    % Camber
    front.camber = calculate_camber(front.WC, front.WCP);

    % Caster
    front.caster = calculate_caster(front.UCO, front.LCO);

    % Mechancial Trail
    front.mechanical_trail = calculate_mechanical_trail(front.UCO, front.LCO, front.WCP);

    % Scrub Radius
    front.scrub_radius = calculate_scrub_radius(front.UCO, front.LCO, front.WC, front.WCP);

    % Toe
    front.toe = calculate_toe(front.LCO, front.UCO, front.TRO);

    % Instant Centers
    front.fvic = calculate_fvic(P.FUCA, P.FUCF, P.FLCA, P.FLCF, front.UCO, front.LCO, front.WC);
    front.svic = calculate_svic(P.FUCA, P.FUCF, P.FLCA, P.FLCF, front.UCO, front.LCO, front.WC);

    % Anti Dive
    front.anti_dive_percent = calculate_anti_dive(front.WCP, front.svic, BRAKE_BIAS_PERCENT, COG_HEIGHT_INCHES, WHEEL_BASE);

    % Anti Lift
    front.anti_lift_percent = calculate_anti_lift();

    % Roll Center Height (heave)
    front.roll_center_heave = calculate_roll_center_heave(front.fvic, front.WCP);

    front_results{target_displacement} = front;
    
    %% Rear Kinematic Calculations
    rear_params = struct( ...
        "UCO",  P.RUCO, ...
        "UCF",  P.RUCF, ...
        "UCA",  P.RUCA, ...
        "LCO",  P.RLCO, ...
        "LCF",  P.RLCF, ...
        "LCA",  P.RLCA, ...
        "TRO",  P.RTRO, ...
        "TRI",  P.RTRI, ...
        "WC",  P.RWC, ...
        "WCP", P.RWCP, ...
        "displacement", target_displacement ...
    );
    
    [RUCO, RLCO, RTRO, RWC, RWCP] = displace_wheel_center(rear_params);

    rear.UCO = RUCO;
    rear.LCO = RLCO;
    rear.TRO = RTRO;
    rear.WC = RWC;
    rear.WCP = RWCP;

    % Wheel Center Z in mm (this is the true value wheel travel)
    rear.z_displacement = convert_inches_to_mm(rear.WC(3) - P.RWC(3));

    % Camber
    rear.camber = calculate_camber(rear.WC, rear.WCP);

    % Toe
    rear.toe = calculate_toe(rear.LCO, rear.UCO, rear.TRO);

    % Instant Centers
    rear.fvic = calculate_fvic(P.RUCA, P.RUCF, P.RLCA, P.RLCF, rear.UCO, rear.LCO, rear.WC);
    rear.svic = calculate_svic(P.RUCA, P.RUCF, P.RLCA, P.RLCF, rear.UCO, rear.LCO, rear.WC);

    % Anti Dive
    rear.anti_squat_percent = calculate_anti_dive(rear.WCP, rear.svic, BRAKE_BIAS_PERCENT, COG_HEIGHT_INCHES, WHEEL_BASE);

    % Anti Lift
    rear.anti_lift_percent = calculate_anti_lift();

    % Roll Center Height (heave)
    rear.roll_center_heave = calculate_roll_center_heave(rear.fvic, rear.WCP);

    rear_results{target_displacement} = rear;
end

% Build numeric arrays from dictionary for plotting
z_disp_front             = nan(n,1);
camber_front             = nan(n,1);
caster_front             = nan(n,1);
mech_trail_front         = nan(n,1);
scrub_radius_front       = nan(n,1);
toe_front                = nan(n,1);
anti_dive_percent_front  = nan(n,1);
anti_lift_percent_front  = nan(n,1);
rc_heave_front           = nan(n,1);
rc_roll_front            = nan(n,1); 
roll_angle_front         = nan(n,1);

z_disp_rear              = nan(n,1);
camber_rear              = nan(n,1);
toe_rear                 = nan(n,1);
anti_squat_percent_rear  = nan(n,1);
anti_lift_percent_rear   = nan(n,1);
rc_heave_rear            = nan(n,1);
rc_roll_rear             = nan(n,1); 
roll_angle_rear          = nan(n,1);

for i = 1:n
    target_displacement = displacements(i);

    current_front = front_results{target_displacement};
    current_rear = rear_results{target_displacement};

    if current_front.z_displacement > -25 && current_front.z_displacement < 25
        opposite_front = front_results{-target_displacement};
    
        z_disp_front(i)            = current_front.z_displacement;
        camber_front(i)            = current_front.camber;
        caster_front(i)            = current_front.caster;
        mech_trail_front(i)        = current_front.mechanical_trail;
        scrub_radius_front(i)      = current_front.scrub_radius;
        toe_front(i)               = current_front.toe;
        anti_dive_percent_front(i) = current_front.anti_dive_percent;
        anti_lift_percent_front(i) = current_front.anti_lift_percent;
        rc_heave_front(i)          = current_front.roll_center_heave;
        rc_roll_front(i)           = calculate_roll_center_roll(current_front.WCP, current_front.fvic, opposite_front.WCP, opposite_front.fvic);
        roll_angle_front(i)        = calculate_roll_angle(current_front.WCP, opposite_front.WCP);
    end

    if current_rear.z_displacement > -25 && current_rear.z_displacement < 25
        opposite_rear = rear_results{-target_displacement};

        z_disp_rear(i)             = current_rear.z_displacement;
        camber_rear(i)             = current_rear.camber;
        toe_rear(i)                = current_rear.toe;
        anti_squat_percent_rear(i) = current_rear.anti_squat_percent;
        anti_lift_percent_rear(i)  = current_rear.anti_lift_percent;
        rc_heave_rear(i)           = current_rear.roll_center_heave;
        rc_roll_rear(i)            = calculate_roll_center_roll(current_rear.WCP, current_rear.fvic, opposite_rear.WCP, opposite_rear.fvic);
        roll_angle_rear(i)         = calculate_roll_angle(current_rear.WCP, opposite_rear.WCP);
    end
end

% Calculate camber rate based on array of results
camber_rate_front  = calculate_camber_rate(camber_front);
camber_rate_rear  = calculate_camber_rate(camber_rear);

% Closing to reset old figures if left open
close all;

% === Camber vs. Displacement ===
f_camber = figure('Name', 'Camber Curve', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, camber_rate_front, 'o-', 'LineWidth', 1.5);
title('Front - Camber Curve');
xlabel('Displacement (mm)');
ylabel('Camber (deg)');
grid on;

subplot(2,1,2);
plot(z_disp_rear, camber_rate_rear, 's-', 'LineWidth', 1.5);
title('Rear - Camber Curve');
xlabel('Displacement (mm)');
ylabel('Camber (deg)');
grid on;

% === Caster vs. Displacement ===
f_caster = figure('Name', 'Caster Curve', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, caster_front, 'o-', 'LineWidth', 1.5);
title('Caster Curve');
xlabel('Displacement (mm)');
ylabel('Caster (deg)');
grid on;

% === Kingpin vs. Displacement ===
% TODO: Implement

% === Mechanical Trail vs. Displacement ===
f_mech_trail = figure('Name', 'Mechancial Trail', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, mech_trail_front, 'o-', 'LineWidth', 1.5);
title('Mechancial Trail');
xlabel('Displacement (mm)');
ylabel('Mechancial Trail (mm)');
grid on;

% === Scrub Radius vs. Displacement ===
f_scrub_radius = figure('Name', 'Scrub Radius', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, scrub_radius_front, 'o-', 'LineWidth', 1.5);
title('Scrub Radius');
xlabel('Displacement (mm)');
ylabel('Scrub Radius (mm)');
grid on;

% === Toe vs. Displacement (Bump Steer) ===
f_toe = figure('Name', 'Bump Steer', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, toe_front, 'o-', 'LineWidth', 1.5);
title('Front - Bump Steer');
xlabel('Displacement (mm)');
ylabel('Toe (deg)');
grid on;

subplot(2,1,2);
plot(z_disp_rear, toe_rear, 's-', 'LineWidth', 1.5);
title('Rear - Bump Steer');
xlabel('Displacement (mm)');
ylabel('Toe (deg)');
grid on;

% === Anti-Dive Percent vs. Displacement ===
f_anti_dive = figure('Name', 'Anti-Dive', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, anti_dive_percent_front, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Anti-Dive (%)');
title('Anti-Dive Percent');
grid on;

% === Anti-Lift Percent vs Displacement ===
f_anti_lift = figure('Name', 'Anti-Lift', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, anti_lift_percent_front, 'o-', 'LineWidth', 1.5);
title('Front - Anti-Lift');
xlabel('Displacement (mm)');
ylabel('Anti-Lift (%)');
grid on;

subplot(2,1,2);
plot(z_disp_rear, anti_lift_percent_rear, 's-', 'LineWidth', 1.5);
title('Rear - Anti-Lift');
xlabel('Displacement (mm)');
ylabel('Anti-Lift (%)');
grid on;

% === Anti-Squat Percent vs. Displacement ===
f_anti_squat = figure('Name', 'Anti-Squat', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, anti_squat_percent_rear, 's-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Anti-Squat (%)');
title('Anti-Squat Percent');
grid on;

% === Roll Center Height (Heave) ===
f_rc_heave = figure('Name', 'Roll Center (Heave)', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, rc_heave_front, 'o-', 'LineWidth', 1.5);
title('Front - Roll Center (Heave)');
xlabel('Displacement (mm)');
ylabel('Roll Center Height (mm)');
grid on;

subplot(2,1,2);
plot(z_disp_rear, rc_heave_rear, 's-', 'LineWidth', 1.5);
title('Rear - Roll Center (Heave)');
xlabel('Displacement (mm)');
ylabel('Roll Center Height (mm)');
grid on;

% === Roll Center Height (Roll) ===
f_rc_roll = figure('Name', 'Roll Center (Roll)', 'NumberTitle', 'off');

subplot(2,1,1);
plot(roll_angle_front, rc_roll_front, 'o-', 'LineWidth', 1.5);
title('Front - Roll Center (Roll)');
xlabel('Roll Angle (deg)');
ylabel('Roll Center Height (mm)');
grid on;

subplot(2,1,2);
plot(roll_angle_rear, rc_roll_rear, 's-', 'LineWidth', 1.5);
title('Rear - Roll Center (Roll)');
xlabel('Roll Angle (deg)');
ylabel('Roll Center Height (mm)');
grid on;

%% Export to PDF
% Uncomment when you want a PDF generated from all figures

% exportgraphics(f_camber, EXPORT_GRAPHICS_FILE_NAME, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_caster, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_mech_trail, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_scrub_radius, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_toe, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_anti_dive, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_anti_lift, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_anti_squat, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_rc_heave, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
% exportgraphics(f_rc_roll, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);

end