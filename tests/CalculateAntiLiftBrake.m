classdef CalculateAntiLiftBrake < matlab.unittest.TestCase
    methods (Test)
       function verify(testCase)
            WCP = [60.490234177555301	22.827274788969930	-1.054103448831119];
            SVIC = [-125.3177668179140	23.045125234844761	9.096932466083866];
            BRAKE_BIAS_PERCENT = 60;
            COG_HEIGHT_INCHES = 10.590551181102363;
            WHEEL_BASE = 60.5;

            result = calculate_anti_lift_brake(WCP, SVIC, BRAKE_BIAS_PERCENT, COG_HEIGHT_INCHES, WHEEL_BASE);
            testCase.assertEqual(result, 12.483683686495944, "AbsTol", 1e-6)
        end
    end
end