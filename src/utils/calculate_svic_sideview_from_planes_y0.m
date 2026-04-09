function svic = calculate_svic_sideview_from_planes_y0(UCA, UCF, LCA, LCF, UO, LO, y0)
% SVIC from true arm planes intersected with fixed side-view plane Y = y0

    % Side-view plane
    nS = [0 1 0];
    dS = y0;

    % Upper arm plane
    nU = cross(UCA - UO, UCF - UO);
    if norm(nU) < 1e-12, error('Upper arm plane degenerate'); end
    dU = dot(nU, UO);

    % Lower arm plane
    nL = cross(LCA - LO, LCF - LO);
    if norm(nL) < 1e-12, error('Lower arm plane degenerate'); end
    dL = dot(nL, LO);

    % Line = Upper plane ∩ side plane
    [pU, vU] = intersect_two_planes(nU, dU, nS, dS, UO);

    % Line = Lower plane ∩ side plane
    [pL, vL] = intersect_two_planes(nL, dL, nS, dS, LO);

    % Intersect those two lines in X-Z
    a1 = [pU(1); pU(3)];
    a2 = [pU(1) + vU(1); pU(3) + vU(3)];
    b1 = [pL(1); pL(3)];
    b2 = [pL(1) + vL(1); pL(3) + vL(3)];

    [ix, iz] = intersect_lines_2d(a1, a2, b1, b2);

    svic = [ix, y0, iz];
end