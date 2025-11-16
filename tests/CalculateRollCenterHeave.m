classdef CalculateRollCenterHeave < matlab.unittest.TestCase
    methods (Test)
        function verify_at_ride_height(testCase)
            fvic = [0, -54.656078715540133, 3.725298755717627];
            WCP = [0, 23.5, 0];

            result = calculate_roll_center_heave(fvic, WCP);

            testCase.assertEqual(result, 28.4511565041673, "AbsTol", 1e-6)
        end

        function verify_in_bump(testCase)
            fvic = [-0.028801215962229, -43.819783786628243, -0.122973168284043];
            WCP = [-0.028801215962229, 23.515482181413269, 1.020204110247282];

            result = calculate_roll_center_heave(fvic, WCP);
            
            testCase.assertEqual(result, -10.1404822456775, "AbsTol", 1e-6)
        end

        function verify_in_droop(testCase)

            fvic = [0.037033264799447, -68.320380567879212, 9.355523286464759];
            WCP = [0.037033264799458, 23.418818619826887, -1.012551219899511];

            result = calculate_roll_center_heave(fvic, WCP);

            testCase.assertEqual(result, 67.2267109879234, "AbsTol", 1e-6)
        end
    end

end