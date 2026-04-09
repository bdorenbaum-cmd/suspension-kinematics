classdef CalculateAntiLiftAccl < matlab.unittest.TestCase
    methods (Test)
       function verify(testCase)
            WCP = [0.1, 2, 0.13];
            SVIC = [0.1 + 0.80, 3, 0.13 + 0.12];
            COG_HEIGHT_INCHES = 0.5;
            WHEEL_BASE = 2.6;

            result = calculate_anti_lift_accl(WCP, SVIC, COG_HEIGHT_INCHES, WHEEL_BASE);
            testCase.assertEqual(result, 78, "AbsTol", 1e-6)
        end
    end
end