classdef DisplaceWheelCenter < matlab.unittest.TestCase
    properties
        P = KinematicsPoints(...
            FUCO = [ 1.063000  -20.905512   11.653000 ], ...
            FUCF = [-4.078307   -9.493208   10.259000 ], ...
            FUCA = [ 4.829961  -10.310332   10.696000 ], ...
            FLCO = [ 0.236000  -22.165354    4.488189 ], ...
            FLCF = [-0.750000   -8.697931    4.329000 ], ...
            FLCA = [ 4.851890   -9.214100    4.485000 ], ...
            FTRO = [-1.653000  -22.480000    4.875000 ], ...
            FTRI = [-2.000000   -9.047900    4.664000 ], ...
            FWC  = [ 0.000000  -23.500000    7.992126 ], ...
            FWCP = [ 0.000000  -23.500000    0.000000 ], ...
            RUCO = [NaN NaN NaN], ...
            RUCF = [NaN NaN NaN], ...
            RUCA = [NaN NaN NaN], ...
            RLCO = [NaN NaN NaN], ...
            RLCF = [NaN NaN NaN], ...
            RLCA = [NaN NaN NaN], ...
            RTRO = [NaN NaN NaN], ...
            RTRI = [NaN NaN NaN], ...
            RWC  = [NaN NaN NaN], ...
            RWCP = [NaN NaN NaN] ... 
            );
    end

    methods (Test)
        function verify_at_ride_height(testCase)
            [UO, LO, TRO, WC, WCP] = displace_wheel_center(testCase.P, 0);

            testCase.assertEqual(UO, testCase.P.FUCO, "AbsTol", 1e-6, "UO differs at ride height.")
            testCase.assertEqual(LO, testCase.P.FLCO, "AbsTol", 1e-6, "LO differs at ride height.")
            testCase.assertEqual(TRO, testCase.P.FTRO, "AbsTol", 1e-6, "TRO differs at ride height.")
            testCase.assertEqual(WC, testCase.P.FWC, "AbsTol", 1e-6, "WC differs at ride height.")
            testCase.assertEqual(WCP, testCase.P.FWCP, "AbsTol", 1e-6, "WCP differs at ride height.")
        end

        function verify_in_bump(testCase)
            [UO, LO, TRO, WC, WCP] = displace_wheel_center(testCase.P, 25);

            expected_FUCO = [1.0282968669216 20.7574643348547 12.6372519685039];
            expected_FLCO = [0.212485706984092 22.1179052411713 5.48957400832507];
            expected_FTRO = [-1.67707989180379 22.427306979534 5.87785002768826];
            expected_FWC = [-0.028801149423022 23.403235503376699 9.011541812730615];
            expected_FWCP = [-0.0288011494230225 23.515482095603 1.02020408351353];

            testCase.assertEqual(UO, expected_FUCO, "AbsTol", 1e-6, "UO differs in bump.")
            testCase.assertEqual(LO, expected_FLCO, "AbsTol", 1e-6, "LO differs in bump.")
            testCase.assertEqual(TRO, expected_FTRO, "AbsTol", 1e-6, "TRO differs in bump.")
            testCase.assertEqual(WC, expected_FWC, "AbsTol", 1e-6, "WC differs in bump.")
            testCase.assertEqual(WCP, expected_FWCP, "AbsTol", 1e-6, "WCP differs in bump.")
        end

        function verify_in_droop(testCase)
            [UO, LO, TRO, WC, WCP] = displace_wheel_center(testCase.P, -25);

            expected_FUCO = [1.10594397209433 20.9637182181938 10.6687480314961];
            expected_FLCO = [0.266299403009513 22.1379347780234 3.49087508758619];
            expected_FTRO = [-1.62190697554716 22.4577622975396 3.87731122044001];
            expected_FWC = [0.0370333871296902 23.514509983735 6.97900184019536];
            expected_FWCP = [0.0370333871296902 23.4188183978923 -1.01255127045061];

            testCase.assertEqual(UO, expected_FUCO, "AbsTol", 1e-6, "UO differs in droop.")
            testCase.assertEqual(LO, expected_FLCO, "AbsTol", 1e-6, "LO differs in droop.")
            testCase.assertEqual(TRO, expected_FTRO, "AbsTol", 1e-6, "TRO differs in droop.")
            testCase.assertEqual(WC, expected_FWC, "AbsTol", 1e-6, "WC differs in droop.")
            testCase.assertEqual(WCP, expected_FWCP, "AbsTol", 1e-6, "WCP differs in droop.")
        end
    end

end