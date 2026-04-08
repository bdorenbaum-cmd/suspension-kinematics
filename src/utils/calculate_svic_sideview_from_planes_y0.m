function svic = calculate_svic_sideview_from_planes_y0(UCA, UCF, LCA, LCF, UO, LO, y0)
    nS = [0, 1, 0];
    dS = y0;

    nU = cross(UCA - UO, UCF - UO); dU = dot(nU, UO);
    nL = cross(LCA - LO, LCF - LO); dL = dot(nL, LO);

    [pU, vU] = intersect_two_planes(nU, dU, nS, dS, UO);
    [pL, vL] = intersect_two_planes(nL, dL, nS, dS, LO);

    a1 = [pU(1); pU(3)]; a2 = [pU(1)+vU(1); pU(3)+vU(3)];
    b1 = [pL(1); pL(3)]; b2 = [pL(1)+vL(1); pL(3)+vL(3)];

    [ix, iz] = intersect_lines_2d(a1, a2, b1, b2);
    svic = [ix, y0, iz];
end