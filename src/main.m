function main()
%% Path Setup — ensure utils, classes, and data are visible
thisDir = fileparts(mfilename('fullpath'));
addpath(fullfile(thisDir, 'utils'));
addpath(fullfile(thisDir, 'classes'));

%% Program Configuration
TRAVEL_DELTA = 25;
USE_NX_DATA = false;
GENERATE_PDF = false;

%% Car Configuration
BRAKE_BIAS_PERCENT = .6;
COG_HEIGHT_INCHES = convert_mm_to_inches(269);
TOE_FRONT = 0.005;
TOE_REAR = 0.005;

displacements = (-TRAVEL_DELTA:1:TRAVEL_DELTA).';

n = numel(displacements);
front_results = dictionary;
rear_results = dictionary;

P = get_kinematic_points(USE_NX_DATA);

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

    % Wheel Center Y Pos
    front.Y_pos = convert_inches_to_mm(front.WC(2));

    % Camber
    front.camber = calculate_camber(front.WC, front.WCP);

    % Caster
    front.caster = calculate_caster(front.UCO, front.LCO);

    % Kingpin Inclination
    front.kingpin_inclination = calculate_kingpin_inclination(front.UCO, front.LCO);

    % Mechancial Trail
    front.mechanical_trail = calculate_mechanical_trail(front.UCO, front.LCO, front.WCP);

    % Scrub Radius
    front.scrub_radius = calculate_scrub_radius(front.UCO, front.LCO, front.WC, front.WCP);

    % Toe
    front.toe = calculate_toe(front.LCO, front.UCO, front.TRO);

    % Instant Centers
    front.y0 = P.FWC(2);
    front.fvic = calculate_fvic(P.FUCA, P.FUCF, P.FLCA, P.FLCF, front.UCO, front.LCO, front.WC);
    front.svic = calculate_svic_sideview_from_planes_y0(P.FUCA, P.FUCF, P.FLCA, P.FLCF, front.UCO, front.LCO, front.y0);

    % Anti Dive
    wheel_base = abs(front.WC(1) - P.RWC(1));
    front.anti_dive_percent = calculate_anti_dive(front.WCP, front.svic, BRAKE_BIAS_PERCENT, COG_HEIGHT_INCHES, wheel_base);

    % Anti Lift
    front.anti_lift_percent = calculate_anti_lift_accl(front.WCP, front.svic, COG_HEIGHT_INCHES, wheel_base);

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

    % Wheel Center Y in mm
    rear.Y_pos = convert_inches_to_mm(rear.WC(2));

    % Camber
    rear.camber = calculate_camber(rear.WC, rear.WCP);

    % Toe
    rear.toe = calculate_toe(rear.LCO, rear.UCO, rear.TRO);

    % Instant Centers
    rear.y0 = P.RWC(2);
    rear.fvic = calculate_fvic(P.RUCA, P.RUCF, P.RLCA, P.RLCF, rear.UCO, rear.LCO, rear.WC);
    rear.svic = calculate_svic_sideview_from_planes_y0(P.RUCA, P.RUCF, P.RLCA, P.RLCF, rear.UCO, rear.LCO, rear.y0);

    % CG-referenced swing arm angle (Adams style)
    rear.cog = [P.RWC(1) - wheel_base/2, 0, COG_HEIGHT_INCHES];
    rear.swing_arm_angle = calculate_adams_swing_arm_angle(rear.svic, rear.cog);

    % Anti Squat
    rear.y0 = P.RWC(2); 
    rear.svic = calculate_svic_sideview_from_planes_y0(P.RUCA, P.RUCF, P.RLCA, P.RLCF, rear.UCO, rear.LCO, rear.y0);
    rear.anti_squat_percent = calculate_anti_squat(rear.WCP, rear.svic, COG_HEIGHT_INCHES, wheel_base);

    % Anti Lift
    rear.anti_lift_percent = calculate_anti_lift_brake(rear.WCP, rear.svic, BRAKE_BIAS_PERCENT, COG_HEIGHT_INCHES, wheel_base);

    % Roll Center Height (heave)
    rear.roll_center_heave = calculate_roll_center_heave(rear.fvic, rear.WCP);

    rear_results{target_displacement} = rear;

    % Wheelbase
    rear.wheelbase = abs(convert_inches_to_mm((front.WC(1) - rear.WC(1))));

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
kingpin_inclination      = nan(n,1);
y_pos_front              = nan(n,1);
sauce_angle_front        = [];
sauce_front              = [];
sauce_labels_front       = string.empty;

z_disp_rear              = nan(n,1);
camber_rear              = nan(n,1);
toe_rear                 = nan(n,1);
anti_squat_percent_rear  = nan(n,1);
anti_lift_percent_rear   = nan(n,1);
rc_heave_rear            = nan(n,1);
rc_roll_rear             = nan(n,1); 
roll_angle_rear          = nan(n,1);
y_pos_rear               = nan(n,1);
swing_arm_angle_rear     = nan(n,1);
wheelbase                = nan(n,1);
pitch_angle              = nan(n,1);
pitch_center             = nan(n,1);
pitch_center_x           = nan(n,1);
sauce_angle_rear         = [];
sauce_rear               = [];
sauce_labels_rear        = string.empty;

for i = 1:n
    target_displacement = displacements(i);

    current_front = front_results{target_displacement};
    current_rear = rear_results{target_displacement};

    if current_front.z_displacement > -TRAVEL_DELTA && current_front.z_displacement < TRAVEL_DELTA
        zero_front = front_results{0};
        opposite_front = front_results{-target_displacement};
    
        z_disp_front(i)            = current_front.z_displacement;
        camber_front(i)            = current_front.camber - zero_front.camber;
        caster_front(i)            = current_front.caster;
        mech_trail_front(i)        = current_front.mechanical_trail;
        scrub_radius_front(i)      = current_front.scrub_radius;
        toe_front(i)               = current_front.toe - zero_front.toe + TOE_FRONT;
        anti_dive_percent_front(i) = current_front.anti_dive_percent;
        anti_lift_percent_front(i) = current_front.anti_lift_percent;
        rc_heave_front(i)          = current_front.roll_center_heave;
        rc_roll_front(i)           = calculate_roll_center_roll(current_front.WCP, current_front.fvic, opposite_front.WCP, opposite_front.fvic);
        roll_angle_front(i)        = calculate_roll_angle(current_front.WCP, opposite_front.WCP);
        kingpin_inclination(i)     = current_front.kingpin_inclination;
        y_pos_front(i)             = current_front.Y_pos;

        for j = 1:n
            sauce_displacement = displacements(j);
            sauce = front_results{sauce_displacement};
            if sauce.z_displacement > -TRAVEL_DELTA && sauce.z_displacement < TRAVEL_DELTA
                sauce_front(end+1) = calculate_roll_center_roll(current_front.WCP, current_front.fvic, sauce.WCP, sauce.fvic);
                sauce_angle_front(end+1) = calculate_roll_angle(current_front.WCP, sauce.WCP);
                sauce_labels_front(end+1) = sprintf("FL: %dmm; FR: %dmm", target_displacement, sauce_displacement);
            end
        end
    end

    if current_rear.z_displacement > -TRAVEL_DELTA && current_rear.z_displacement < TRAVEL_DELTA
        zero_rear = rear_results{0};
        opposite_rear = rear_results{-target_displacement};

        z_disp_rear(i)             = current_rear.z_displacement;
        camber_rear(i)             = current_rear.camber - zero_rear.camber;
        toe_rear(i)                = current_rear.toe - zero_rear.toe + TOE_REAR;
        anti_squat_percent_rear(i) = current_rear.anti_squat_percent;
        anti_lift_percent_rear(i)  = current_rear.anti_lift_percent;
        rc_heave_rear(i)           = current_rear.roll_center_heave;
        rc_roll_rear(i)            = calculate_roll_center_roll(current_rear.WCP, current_rear.fvic, opposite_rear.WCP, opposite_rear.fvic);
        roll_angle_rear(i)         = calculate_roll_angle(current_rear.WCP, opposite_rear.WCP);
        y_pos_rear(i)              = current_rear.Y_pos;
        swing_arm_angle_rear(i)    = current_rear.swing_arm_angle;
        wheelbase(i)               = current_rear.wheelbase;

        for j = 1:n
            sauce_displacement = displacements(j);
            sauce = rear_results{sauce_displacement};
            if sauce.z_displacement > -TRAVEL_DELTA && sauce.z_displacement < TRAVEL_DELTA
                sauce_rear(end+1) = calculate_roll_center_roll(current_rear.WCP, current_rear.fvic, sauce.WCP, sauce.fvic);
                sauce_angle_rear(end+1) = calculate_roll_angle(current_rear.WCP, sauce.WCP);
                sauce_labels_rear(end+1) = sprintf("RL: %dmm; RR: %dmm", target_displacement, sauce_displacement);
            end
        end
    end

    % Pitch Center (symmetric pitch: front at +d, rear at -d)
    if current_front.z_displacement > -TRAVEL_DELTA && current_front.z_displacement < TRAVEL_DELTA ...
       && current_rear.z_displacement > -TRAVEL_DELTA && current_rear.z_displacement < TRAVEL_DELTA

        opposite_rear_pitch = rear_results{-target_displacement};

        pitch_angle(i)   = calculate_pitch_angle(current_front.WCP, opposite_rear_pitch.WCP);
        [pitch_center(i), pitch_center_x(i)] = calculate_pitch_center(current_front.svic, current_front.WCP, ...
                                                   opposite_rear_pitch.svic, opposite_rear_pitch.WCP);
    end
end

% Closing to reset old figures if left open
close all;

% === Camber vs. Displacement ===
f_camber = figure('Name', 'Camber Curve', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, camber_front, 'o-', 'LineWidth', 1.5);
title('Front - Camber Curve');
xlabel('Displacement (mm)');
ylabel('Camber (deg)');
grid on;

subplot(2,1,2);
plot(z_disp_rear, camber_rear, 's-', 'LineWidth', 1.5);
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
f_kingpin = figure('Name', 'Kingpin', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, kingpin_inclination, 'o-', 'LineWidth', 1.5);
title('Kingpin Curve');
xlabel('Displacement (mm)');
ylabel('Kingpin Inclination (deg)');
grid on;

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

% === Swing Arm Angle vs. Displacement ===

f_angle = figure('Name','Adams-Style Swing Arm Angle','NumberTitle','off');
plot(z_disp_rear, swing_arm_angle_rear, 'o-', 'LineWidth', 1.5);
xlabel('Displacement (mm)');
ylabel('Angle (deg)');
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
title('Front - Anti-Lift (Acceleration)');
xlabel('Displacement (mm)');
ylabel('Anti-Lift (%)');
grid on;

subplot(2,1,2);
plot(z_disp_rear, anti_lift_percent_rear, 's-', 'LineWidth', 1.5);
title('Rear - Anti-Lift (Brake)');
xlabel('Displacement (mm)');
ylabel('Anti-Lift (%)');
grid on;

% === Anti-Squat Percent vs. Displacement ===
f_anti_squat = figure('Name', 'Anti-Squat', 'NumberTitle', 'off');
subplot(2,1,1);
plot(z_disp_rear, anti_squat_percent_rear, 's-', 'LineWidth', 1.5);
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

% === Roll Center Height (Symmetric  Roll) ===
f_rc_roll = figure('Name', 'Roll Center (Symmetric Roll)', 'NumberTitle', 'off');

subplot(2,1,1);
plot(roll_angle_front, rc_roll_front, 'o-', 'LineWidth', 1.5);
title('Front - Roll Center (Symmetric Roll)');
xlabel('Roll Angle (deg)');
ylabel('Roll Center Height (mm)');
grid on;

subplot(2,1,2);
plot(roll_angle_rear, rc_roll_rear, 's-', 'LineWidth', 1.5);
title('Rear - Roll Center (Symmetric Roll)');
xlabel('Roll Angle (deg)');
ylabel('Roll Center Height (mm)');
grid on;

% === Pitch Center Height (Symmetric Pitch) ===
f_pitch_center = figure('Name', 'Pitch Center (Symmetric Pitch)', 'NumberTitle', 'off');

subplot(2,1,1);
plot(pitch_angle, pitch_center, 'o-', 'LineWidth', 1.5);
title('Pitch Center (Symmetric Pitch)');
xlabel('Pitch Angle (deg)');
ylabel('Pitch Center Height (mm)');
grid on;

% === Pitch Center X-Position (Symmetric Pitch) ===
f_pitch_center_x = figure('Name', 'Pitch Center X-Position (Symmetric Pitch)', 'NumberTitle', 'off');

subplot(2,1,1);
plot(pitch_angle, pitch_center_x, 'o-', 'LineWidth', 1.5);
title('Pitch Center X-Position (Symmetric Pitch)');
xlabel('Pitch Angle (deg)');
ylabel('Pitch Center X-Position (mm)');
grid on;

% === Wheel Center Y-Pos ===
f_wc_y_pos = figure('Name', 'Wheel Center Y-Position', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_front, y_pos_front, 'o-', 'LineWidth', 1.5);
title('Front - Wheel Center Y-Position');
xlabel('Z-displacement (mm)');
ylabel('Y-Position (mm)');
grid on;

subplot(2,1,2);
plot(z_disp_rear, y_pos_rear, 's-', 'LineWidth', 1.5);
title('Rear - Wheel Center Y-Position');
xlabel('Z-displacement (mm)');
ylabel('Y-Position (mm)');
grid on;

% === Wheelbase === 
wheelbase_fig = figure('Name', 'Wheelbase', 'NumberTitle', 'off');

subplot(2,1,1);
plot(z_disp_rear, wheelbase, 'o-', 'LineWidth', 1.5);
title('Wheelbase');
xlabel('Z-Displacement (mm)');
ylabel('Wheelbase (mm)');
grid on;

% === Secret Sauce ===
f_sauce = figure('Name', 'Secret Sauce', 'NumberTitle', 'off');

subplot(2,1,1);
s_sauce_front = scatter(sauce_angle_front, sauce_front, 'filled');
title('Front - Sauce');
xlabel('Roll Angle (deg)');
ylabel('Roll Center Height (mm)');
grid on;


% Add custom tooltip field
s_sauce_front.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Data', sauce_labels_front);

subplot(2,1,2);
s_sauce_rear = scatter(sauce_angle_rear, sauce_rear, 'filled');
title('Rear - Sauce');
xlabel('Roll Angle (deg)');
ylabel('Roll Center Height (mm)');
grid on;

% Add custom tooltip field
s_sauce_rear.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Data', sauce_labels_rear);

%% Export to PDF
if GENERATE_PDF
    EXPORT_GRAPHICS_FILE_NAME = "Suspension Report.pdf";
    EXPORT_GRAPHICS_HEGIHT = "auto";
    EXPORT_GRAPHICS_WIDTH = "auto";
    EXPORT_GRAPHICS_PADDING = 30;

    exportgraphics(f_camber, EXPORT_GRAPHICS_FILE_NAME, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_caster, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_mech_trail, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_scrub_radius, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_toe, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_anti_dive, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_anti_lift, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_anti_squat, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_rc_heave, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_rc_roll, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_pitch_center, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_pitch_center_x, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_sauce, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'Padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_kingpin, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH);
    exportgraphics(f_wc_y_pos, EXPORT_GRAPHICS_FILE_NAME, 'Append', true, 'padding', EXPORT_GRAPHICS_PADDING, 'Height', EXPORT_GRAPHICS_HEGIHT, 'Width', EXPORT_GRAPHICS_WIDTH)
end

end
