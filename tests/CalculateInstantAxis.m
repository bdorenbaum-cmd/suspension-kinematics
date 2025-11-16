classdef CalculateInstantAxis < matlab.unittest.TestCase
    properties
        P = KinematicsPoints( ...
            FUCO = [  1.063000  -20.905512   11.653000 ], ...
            FUCF = [ -4.078307   -9.493208   10.259000 ], ...
            FUCA = [  4.829961  -10.310332   10.696000 ], ...
            FLCO = [  0.236000  -22.165354    4.488189 ], ...
            FLCF = [ -0.750000   -8.697931    4.329000 ], ...
            FLCA = [  4.851890   -9.214100    4.485000 ], ...
            FTRO = [ -1.653000  -22.480000    4.875000 ], ...
            FTRI = [ -2.000000   -9.047900    4.664000 ], ...
            FWC  = [  0.000000  -23.500000    7.992126 ], ...
            FWCP = [  0.000000  -23.500000    0.000000 ], ...
            RUCO = [ 60.551000  -18.819000   11.811000 ], ...
            RUCF = [ 56.345000  -10.193470    9.901000 ], ...
            RUCA = [ 64.055000  -10.202930    9.993000 ], ...
            RLCO = [ 62.223000  -21.220000    4.685000 ], ...
            RLCF = [ 58.195000   -9.797804    4.802000 ], ...
            RLCA = [ 65.086000   -9.734372    4.602000 ], ...
            RTRO = [ 58.661000  -20.944000    4.764000 ], ...
            RTRI = [ 56.296100   -9.797692    4.802000 ], ...
            RWC  = [ 60.500000  -23.000000    7.992126 ], ...
            RWCP = [ 60.500000  -23.000000    0.000000 ] ...
            );

        % NOTE: Straight from points csv
        LO_AT_0 = [0.236, 22.1654, 4.48819];
        UO_AT_0 = [1.063, 20.90551181, 11.653];
        TRO_AT_0 = [-1.653, 22.48, 4.875];
        WC_AT_0 = [0, 23.5, 7.992126];
        WCP_AT_0 = [0, 23.5, 0];
        
        % NOTE: Calculated these values in +25 displacement
        LO_IN_BUMP = [0.212485680515167, 22.117951272244795, 5.489575668344954];
        UO_IN_BUMP = [1.028296859416164, 20.757464147745914, 12.637251968503938];
        TRO_IN_BUMP = [-1.677079929296870, 22.427306979179608, 5.877850041569000];
        WC_IN_BUMP = [-0.028801215962229, 23.403235514190609, 9.011541838411054];
        WCP_IN_BUMP = [-0.028801215962229, 23.515482181413269, 1.020204110247282];

        % NOTE: Calculated these values in -25 displacement
        LO_IN_DROOP = [0.266299404272329, 22.137980911887098, 3.490875557270098];
        UO_IN_DROOP = [1.105943976028235, 20.963718026383368, 10.668748031496063];
        TRO_IN_DROOP = [-1.621907011183506, 22.457762299392044, 3.877311234889075];
        WC_IN_DROOP = [0.037033264799458, 23.514510008800890, 6.979001893103836];
        WCP_IN_DROOP = [0.037033264799458, 23.418818619826887, -1.012551219899511];
    end

    methods (Test)
        function verify_at_ride_height(testCase)
            [point_result, axis_result] = calculate_instant_axis(testCase.P.FUCA, testCase.P.FUCF, testCase.P.FLCA, testCase.P.FLCF, testCase.UO_AT_0, testCase.LO_AT_0);

            testCase.assertEqual(point_result, [-145.3295341366340  -35.3700437683667, 0], "AbsTol", 1e-6, "Point differs at full bump.")
            testCase.assertEqual(axis_result, [-690.262657431606, 91.601681743773, -17.6938200079189], "AbsTol", 1e-6, "Axis differs at full bump.")
        end

        function verify_in_bump(testCase)
            [point_result, axis_result] = calculate_instant_axis(testCase.P.FUCA, testCase.P.FUCF, testCase.P.FLCA, testCase.P.FLCF, testCase.UO_IN_BUMP, testCase.LO_IN_BUMP);
            
            testCase.assertEqual(point_result, [10.492531813426801, -44.849514542834854, 0], "AbsTol", 1e-6, "Point differs at full bump.")
            testCase.assertEqual(axis_result, [-804.720203508462, 78.758569981472021, -9.405556570749688], "AbsTol", 1e-6, "Axis differs at full bump.")
        end

        function verify_in_droop(testCase)
            [point_result, axis_result] = calculate_instant_axis(testCase.P.FUCA, testCase.P.FUCF, testCase.P.FLCA, testCase.P.FLCF, testCase.UO_IN_DROOP, testCase.LO_IN_DROOP);

            testCase.assertEqual(point_result, [-206.632692283198, -31.905357897626, 0], "AbsTol", 1e-6, "Point differs at full droop.")
            testCase.assertEqual(axis_result, [-578.9158188503714, 102.0044547487847, -26.2063561065678], "AbsTol", 1e-6, "Axis differs at full droop.")
        end
       
    end

end