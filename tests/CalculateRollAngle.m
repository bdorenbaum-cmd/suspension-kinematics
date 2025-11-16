classdef CalculateRollAngle < matlab.unittest.TestCase
    methods (Test)
       function verifyRollRight(testCase)
            left  = [0.035318898824836, 23.423411843793097, -0.972112664044527];
            right = [-0.027744879997082, 23.516055605004311, 0.979160580156086];

            result = calculate_roll_angle(left, right);
            testCase.assertEqual(result, 2.71828324369083, "AbsTol", 1e-6)
       end

       function verifyRollLeft(testCase)
            right  = [0.035318898824836, 23.423411843793097, -0.972112664044527];
            left = [-0.027744879997082, 23.516055605004311, 0.979160580156086];

            result = calculate_roll_angle(left, right);
            testCase.assertEqual(result, -2.71828324369083, "AbsTol", 1e-6)
       end

       function verifyNoRoll(testCase)
            right  = [0.035318898824836, 20, 1];
            left = [-0.027744879997082, 20, 1];

            result = calculate_roll_angle(left, right);
            testCase.assertEqual(result, 0, "AbsTol", 1e-6)
        end
    end
end