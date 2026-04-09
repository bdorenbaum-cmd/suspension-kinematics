classdef CalculateCamber < matlab.unittest.TestCase
    properties
        % NOTE: Straight from points csv
        WC_AT_0 = [0, 23.5, 7.992126]
        WCP_AT_0 = [0, 23.5, 0]

        % NOTE: Calculated these values in +25 displacement
        WC_IN_BUMP = [-0.028801215962229, 23.403235514190609, 9.011541838411054]
        WCP_IN_BUMP = [-0.028801215962229, 23.515482181413269, 1.020204110247282]

        % NOTE: Calculated these values in -25 displacement
        WC_IN_DROOP = [0.037033264799458, 23.514510008800890, 6.979001893103836]
        WCP_IN_DROOP = [0.037033264799458, 23.418818619826887, -1.012551219899511]
    end

    methods (Test)
        function verify_at_ride_height(testCase)
            camber = calculate_camber(testCase.WC_AT_0, testCase.WCP_AT_0);
            testCase.assertEqual(camber, 0, "AbsTol", 1e-6, "Camber differs at ride height.")
        end

        function verify_in_bump(testCase)
            camber = calculate_camber(testCase.WC_IN_BUMP, testCase.WCP_IN_BUMP);
            testCase.assertEqual(camber, -0.804726019744598, "AbsTol", 1e-6, "Camber differs at full bump.")
        end

        function verify_in_droop(testCase)
            camber = calculate_camber(testCase.WC_IN_DROOP, testCase.WCP_IN_DROOP);
            testCase.assertEqual(camber, 0.686030692033891, "AbsTol", 1e-6, "Camber differs at full droop.")
        end
       
    end

end