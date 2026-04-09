function [p0, v] = intersect_two_planes(n1, d1, n2, d2, x_ref)
% Intersection of planes n1·x=d1 and n2·x=d2

    v = cross(n1, n2);
    nv = norm(v);
    if nv < 1e-12, error('Planes nearly parallel'); end
    v = v / nv;

    A = [n1; n2; v];
    b = [d1; d2; dot(v, x_ref)];
    p0 = A \ b;
end