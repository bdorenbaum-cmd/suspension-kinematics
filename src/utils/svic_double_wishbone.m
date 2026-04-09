function svic = svic_double_wishbone(UTI, UFI, LTI, LFI)
%INTERSECT_INBOARD_LINES Intersection of upper/lower inboard mount lines (XZ-plane)
%
% Inputs (1x3 or 3x1):
%   UTI, UFI = upper inboard points
%   LTI, LFI = lower inboard points
%
% Output:
%   P = 1x3 intersection point (XY intersection, Z = 0)

    % Use XY projection (top view)
    p1 = UTI([1 3]);
    p2 = UFI([1 3]);
    p3 = LTI([1 3]);
    p4 = LFI([1 3]);

    d1 = p2 - p1;
    d2 = p4 - p3;

    % Solve p1 + t*d1 = p3 + u*d2  (least-squares handles parallel case)
    A = [d1(:), -d2(:)];
    b = (p3 - p1).';

    tu = A \ b;      % least-squares if singular/parallel
    t = tu(1);

    Pint2 = p1 + t * d1;
    svic = [Pint2(1), 0, Pint2(2)];
end