classdef CalculateRollCenterRoll < matlab.unittest.TestCase
    methods (Test)
        function verify_roll_right(testCase)
            left_fvic = [0.036956575660014, -68.446209300369844, 9.362505625777745];
            left_WCP = [0.036956575660026, 23.418905989987728, -1.012482674095398];

            right_fvic = [-0.028736936310088, -43.885852355344085, -0.129047860237640];
            right_WCP = [-0.028736936310088, 23.515405037678484, 1.020134024172399];

            result = calculate_roll_center_roll(left_WCP, left_fvic, right_WCP, right_fvic);

            testCase.assertEqual(result,22.7095331597443, "AbsTol", 1e-6)
        end

        function verify_roll_left(testCase)
            left_fvic = [-0.028736936310088, -43.885852355344085, -0.129047860237640];
            left_WCP = [-0.028736936310088, 23.515405037678484, 1.020134024172399];

            right_fvic = [0.036956575660014, -68.446209300369844, 9.362505625777745];
            right_WCP = [0.036956575660026, 23.418905989987728, -1.012482674095398];

            result = calculate_roll_center_roll(left_WCP, left_fvic, right_WCP, right_fvic);

            testCase.assertEqual(result,22.7095331597443, "AbsTol", 1e-6)
        end

        function verify_no_roll(testCase)
            left_fvic = [0, -54.656078715540133, 3.725298755717627];
            left_WCP = [0, 23.5, 0];

            right_fvic = [0, -54.656078715540133, 3.725298755717627];
            right_WCP = [0, 23.5, 0];

            result = calculate_roll_center_roll(left_WCP, left_fvic, right_WCP, right_fvic);

            testCase.assertEqual(result,28.4511565041673, "AbsTol", 1e-6)
        end
    end
end