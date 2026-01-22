function tests = test_calculate_kingpin_inclination
% Unit tests for calculate_kingpin_inclination
tests = functiontests(localfunctions);
end

function testZeroAngle(t)
% vy=0, vz>0 => 0 deg
LO = [0 0 0];
UO = [0 0 10];
act = calculate_kingpin_inclination(UO, LO);
verifyEqual(t, act, 0, "AbsTol", 1e-12);
end

function testPositiveAngle45(t)
% vy=vz => 45 deg
LO = [0 0 0];
UO = [0 10 10];
act = calculate_kingpin_inclination(UO, LO);
verifyEqual(t, act, 45, "AbsTol", 1e-12);
end

function testNegativeAngle45(t)
% vy=-vz => -45 deg
LO = [0 0 0];
UO = [0 -10 10];
act = calculate_kingpin_inclination(UO, LO);
verifyEqual(t, act, -45, "AbsTol", 1e-12);
end

function testReversePointsSignFlip(t)
% Swapping endpoints should flip the sign (because vector reverses)
LO = [0 0 0];
UO = [0 10 10];
a1 = calculate_kingpin_inclination(UO, LO);
a2 = calculate_kingpin_inclination(LO, UO);
verifyEqual(t, a2, a1 - 180, "AbsTol", 1e-12); 
% Note: atan2d(vy,vz) with reversed vector adds/subtracts 180 depending on quadrant.
% If you want a different convention (e.g., abs or limited range), test accordingly.
end

function testVZZero90(t)
% vz=0, vy>0 => +90 deg
LO = [0 0 0];
UO = [0 10 0];
act = calculate_kingpin_inclination(UO, LO);
verifyEqual(t, act, 90, "AbsTol", 1e-12);
end
