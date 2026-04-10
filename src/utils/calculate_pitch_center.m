function [pitch_center_height, pitch_center_x] = calculate_pitch_center(front_svic, front_WCP, rear_svic, rear_WCP)
% CALCULATE_PITCH_CENTER  Pitch center from front/rear SVICs and WCPs.
%
%   The pitch center is the intersection of the side-view force lines
%   (WCP-to-SVIC) for the front and rear axles, projected into the X-Z plane.
%
%   Inputs:
%       front_svic  - [x, y, z] front side-view instant center
%       front_WCP   - [x, y, z] front wheel contact patch
%       rear_svic   - [x, y, z] rear side-view instant center
%       rear_WCP    - [x, y, z] rear wheel contact patch
%
%   Outputs:
%       pitch_center_height - Z-coordinate of the pitch center (mm)
%       pitch_center_x      - X-coordinate of the pitch center (mm)

    % Front force line in X-Z
    a1 = [front_WCP(1); front_WCP(3)];
    a2 = [front_svic(1); front_svic(3)];

    % Rear force line in X-Z
    b1 = [rear_WCP(1); rear_WCP(3)];
    b2 = [rear_svic(1); rear_svic(3)];

    try
        [ix, iz] = intersect_lines_2d(a1, a2, b1, b2);
        pitch_center_height = convert_inches_to_mm(iz);
        pitch_center_x = convert_inches_to_mm(ix);
    catch
        pitch_center_height = NaN;
        pitch_center_x = NaN;
    end
end
