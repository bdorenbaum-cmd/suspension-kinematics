function pitch_deg = calculate_pitch_angle(front_WCP, rear_WCP)
% CALCULATE_PITCH_ANGLE  Chassis pitch angle from front and rear WCPs.
%
%   Positive = nose up (front contact patch higher than rear).
%
%   Inputs:
%       front_WCP  - [x, y, z] front wheel contact patch (inches)
%       rear_WCP   - [x, y, z] rear wheel contact patch (inches)
%
%   Output:
%       pitch_deg  - pitch angle in degrees

    dz = front_WCP(3) - rear_WCP(3);
    dx = abs(front_WCP(1) - rear_WCP(1));

    pitch_deg = atan2d(dz, dx);
end
