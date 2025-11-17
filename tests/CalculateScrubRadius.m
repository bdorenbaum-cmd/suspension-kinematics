classdef CalculateScrubRadius < matlab.unittest.TestCase
    properties
        % NOTE: Straight from points csv
        LO_AT_0 = [-0.236, 22.1654, 4.48819];
        UO_AT_0 = [-1.063, 20.90551181, 11.653];
        TRO_AT_0 = [1.653, 22.48, 4.875];
        WC_AT_0 = [0, 23.5, 7.992126]
        WCP_AT_0 = [0, 23.5, 0]

        % NOTE: Calculated these values in +25 displacement
        LO_IN_BUMP = [-0.212485680515167, 22.117951272244795, 5.489575668344954];
        UO_IN_BUMP = [-1.028296859416164, 20.757464147745914, 12.637251968503938];
        TRO_IN_BUMP = [1.677079929296870, 22.427306979179608, 5.877850041569000];
        WC_IN_BUMP = [0.028801215962229, 23.403235514190609, 9.011541838411054]
        WCP_IN_BUMP = [0.028801215962229, 23.515482181413269, 1.020204110247282]

        % NOTE: Calculated these values in -25 displacement
        LO_IN_DROOP = [-0.266299404272329, 22.137980911887098, 3.490875557270098];
        UO_IN_DROOP = [-1.105943976028235, 20.963718026383368, 10.668748031496063];
        TRO_IN_DROOP = [1.621907011183506, 22.457762299392044, 3.877311234889075];
        WC_IN_DROOP = [-0.037033264799458, 23.514510008800890, 6.979001893103836]
        WCP_IN_DROOP = [-0.037033264799458, 23.418818619826887, -1.012551219899511]
    end

    methods (Test)
        function verify_at_ride_height(testCase)
            result = calculate_scrub_radius(testCase.UO_AT_0, testCase.LO_AT_0, testCase.WC_AT_0, testCase.WCP_AT_0);
            testCase.assertEqual(result, 13.8526299236556, "AbsTol", 1e-6, "Scrub Radius differs at ride height.")
        end

        function verify_in_bump(testCase)
            result = calculate_scrub_radius(testCase.UO_IN_BUMP, testCase.LO_IN_BUMP, testCase.WC_IN_BUMP, testCase.WCP_IN_BUMP);
            testCase.assertEqual(result, 11.0384602466959, "AbsTol", 1e-6, "Scrub Radius at full bump.")
        end

        function verify_in_droop(testCase)
            result = calculate_scrub_radius(testCase.UO_IN_DROOP, testCase.LO_IN_DROOP, testCase.WC_IN_DROOP, testCase.WCP_IN_DROOP);
            testCase.assertEqual(result, 16.2507097462781, "AbsTol", 1e-6, "Scrub Radius at full droop.")
        end
       
    end
end