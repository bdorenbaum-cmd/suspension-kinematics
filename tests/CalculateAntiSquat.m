classdef CalculateAntiSquat < matlab.unittest.TestCase
    methods (Test)
       function verify(testCase)
            WCP = [60.490234177555301	22.827274788969930	-1.054103448831119];
            SVIC = [-125.3177668179140	23.045125234844761	9.096932466083866];
            COG_HEIGHT_INCHES = 10.590551181102363;
            WHEEL_BASE = 60.5;

            result = calculate_anti_squat(WCP, SVIC, COG_HEIGHT_INCHES, WHEEL_BASE);
            testCase.assertEqual(result, 31.20920921623986, "AbsTol", 1e-6)
        end
    end
end