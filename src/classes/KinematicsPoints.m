classdef KinematicsPoints < handle
    % KinematicsPoints
    % Stores key suspension / wheel center points as 3D coordinates.
    % All points are reflected to the left side of the vehicle (y >= 0).

    properties (SetAccess = immutable)
        % 3D points (x y z)
        FUCO (1,3) double = [NaN NaN NaN]
        FUCF (1,3) double = [NaN NaN NaN]
        FUCA (1,3) double = [NaN NaN NaN]

        FLCO (1,3) double = [NaN NaN NaN]
        FLCF (1,3) double = [NaN NaN NaN]
        FLCA (1,3) double = [NaN NaN NaN]

        FTRO (1,3) double = [NaN NaN NaN]
        FTRI (1,3) double = [NaN NaN NaN]

        FWC  (1,3) double = [NaN NaN NaN]
        FWCP (1,3) double = [NaN NaN NaN]

        RUCO (1,3) double = [NaN NaN NaN]
        RUCF (1,3) double = [NaN NaN NaN]
        RUCA (1,3) double = [NaN NaN NaN]

        RLCO (1,3) double = [NaN NaN NaN]
        RLCF (1,3) double = [NaN NaN NaN]
        RLCA (1,3) double = [NaN NaN NaN]

        RTRO (1,3) double = [NaN NaN NaN]
        RTRI (1,3) double = [NaN NaN NaN]

        RWC  (1,3) double = [NaN NaN NaN]
        RWCP (1,3) double = [NaN NaN NaN]
    end

    methods
        function obj = KinematicsPoints(opts)
            arguments
                opts.?KinematicsPoints
            end
            % Set properties from opts, reflecting all 3D points to left side
            for prop = string(fieldnames(opts))'
                val = opts.(prop);
                val(2) = abs(val(2));
                obj.(prop) = val;
            end
        end
    end
end
