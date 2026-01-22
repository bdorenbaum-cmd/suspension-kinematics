function tests = test_calculate_svic_from_axis
tests = functiontests(localfunctions);
end

function testIntersectionHitsRequestedY(t)
% Choose a line with a known intersection with Y=WC(2)

x0 = [ 10,  2,  30];
v  = [  3,  4,  -5];     % v(2)=4 != 0
WC = [  0, 18,   0];     % we only use WC(2)=18

svic = calculate_svic_from_axis(x0, v, WC);

% 1) Must lie on plane Y=18
verifyEqual(t, svic(2), WC(2), "AbsTol", 1e-12);

% 2) Must lie on the line x0 + t*v for the computed t
t_expected = (WC(2) - x0(2)) / v(2);
svic_expected = x0 + t_expected * v;
verifyEqual(t, svic, svic_expected, "AbsTol", 1e-12);
end

function testWorksWithColumnVectors(t)
% Your code should work with either row or column inputs

x0 = [10; 2; 30];
v  = [ 3; 4; -5];
WC = [ 0; 18; 0];

svic = calculate_svic_from_axis(x0, v, WC);

verifyEqual(t, size(svic), size(x0));
verifyEqual(t, svic(2), WC(2), "AbsTol", 1e-12);
end

function testParallelAxisThrows(t)
% If v(2)=0, intersection with Y=const plane is undefined/degenerate

x0 = [0, 5, 0];
v  = [1, 0, 2];     % v(2)=0
WC = [0, 7, 0];

verifyError(t, @() calculate_svic_from_axis(x0, v, WC), "calculate_svic:ParallelToPlane");
end