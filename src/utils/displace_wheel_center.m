function [FUCO,FLCO,FTRO,FWC,FWCP] = displace_wheel_center(P,displacement)
arguments (Input)
    P (1,1) KinematicsPoints
    displacement (1,1) double
end

arguments (Output)
    FUCO
    FLCO
    FTRO
    FWC
    FWCP
end

% ---- Link lengths from static geometry
L.FUCO_FUCF = distance_between(P.FUCO, P.FUCF);
L.FUCO_FUCA = distance_between(P.FUCO, P.FUCA);
L.FLCO_FLCF = distance_between(P.FLCO, P.FLCF);
L.FLCO_FLCA = distance_between(P.FLCO, P.FLCA);
L.FUCO_FLCO = distance_between(P.FUCO, P.FLCO);
L.FTRO_FUCO = distance_between(P.FTRO, P.FUCO);
L.FTRO_FLCO = distance_between(P.FTRO, P.FLCO);
L.FTRO_FTRI = distance_between(P.FTRO, P.FTRI);
L.FWC_FUCO  = distance_between(P.FWC,  P.FUCO);
L.FWC_FLCO  = distance_between(P.FWC,  P.FLCO);
L.FWC_FTRO  = distance_between(P.FWC,  P.FTRO);
L.FWCP_FUCO = distance_between(P.FWCP, P.FUCO);
L.FWCP_FLCO = distance_between(P.FWCP, P.FLCO);
L.FWCP_FTRO = distance_between(P.FWCP, P.FTRO);

% ---- Target travel (mm -> in) applied at FUCO
desired_z = P.FUCO(3) + convert_mm_to_inches(displacement);

% ---------- Solve FUCO from two upper-pivot circles at desired_z ----------
c1 = struct('x',P.FUCF(1),'y',P.FUCF(2),'z',P.FUCF(3),'r',L.FUCO_FUCF);
c2 = struct('x',P.FUCA(1),'y',P.FUCA(2),'z',P.FUCA(3),'r',L.FUCO_FUCA);
FUCO_cands = intersection_of_circles(c1, c2, desired_z);
assert_non_empty(FUCO_cands, 'Upper conFTROl arm intersection failed (FUCO).');
FUCO = pick_closest(FUCO_cands, P.FUCO);

% ---------- Solve FLCO from three spheres (FLCF, FLCA, FUCO-FLCO length) ----------
c1 = struct('x',P.FLCF(1),'y',P.FLCF(2),'z',P.FLCF(3),'r',L.FLCO_FLCF);
c2 = struct('x',P.FLCA(1),'y',P.FLCA(2),'z',P.FLCA(3),'r',L.FLCO_FLCA);
c3 = struct('x',FUCO(1),'y',FUCO(2),'z',FUCO(3),'r',L.FUCO_FLCO);
FLCO_cands = intersection_of_spheres(c1, c2, c3);
assert_non_empty(FLCO_cands, 'FLCOwer conFTROl arm intersection failed (FLCO).');
FLCO = pick_closest(FLCO_cands, P.FLCO);

% ---------- Solve FTRO from three spheres (FUCO, FLCO, FTRI) ----------
c1 = struct('x',FUCO(1),'y',FUCO(2),'z',FUCO(3),'r',L.FTRO_FUCO);
c2 = struct('x',FLCO(1),'y',FLCO(2),'z',FLCO(3),'r',L.FTRO_FLCO);
c3 = struct('x',P.FTRI(1),'y',P.FTRI(2),'z',P.FTRI(3),'r',L.FTRO_FTRI);
FTRO_cands = intersection_of_spheres(c1, c2, c3);
assert_non_empty(FTRO_cands, 'Tie-rod intersection failed (FTRO).');
FTRO = pick_closest(FTRO_cands, P.FTRO);

% ---------- Dynamically solve WC from three spheres (FUCO, FLCO, FTRO) ----------
c1 = struct('x',FUCO(1),'y',FUCO(2),'z',FUCO(3),'r',L.FWC_FUCO);
c2 = struct('x',FLCO(1),'y',FLCO(2),'z',FLCO(3),'r',L.FWC_FLCO);
c3 = struct('x',FTRO(1),'y',FTRO(2),'z',FTRO(3),'r',L.FWC_FTRO);
FWC_cands = intersection_of_spheres(c1, c2, c3);
assert_non_empty(FWC_cands, 'Wheel center intersection failed (WC).');
FWC = pick_closest(FWC_cands, P.FWC);

% ---------- Dynamically solve FWCP from three spheres (FUCO, FLCO, FTRO) ----------
c1 = struct('x',FUCO(1),  'y',FUCO(2),  'z',FUCO(3),  'r',L.FWCP_FUCO);
c2 = struct('x',FLCO(1),  'y',FLCO(2),  'z',FLCO(3),  'r',L.FWCP_FLCO);
c3 = struct('x',FTRO(1), 'y',FTRO(2), 'z',FTRO(3), 'r',L.FWCP_FTRO);
FWCP_cands = intersection_of_spheres(c1, c2, c3);
assert_non_empty(FWCP_cands, 'Wheel contact patch intersection failed (FWCP).');
FWCP = pick_closest(FWCP_cands, P.FWCP);
tire_radius = norm(P.FWC - P.FWCP);
FWCP = shift_wheel_contact_patch(tire_radius, FWC, FWCP);

% Validate the calculated positions against the original distances
assert(abs(L.FUCO_FUCF - distance_between(FUCO, P.FUCF)) < 1e-6, "Distance of FUCO_FUCF has changed, check logic");
assert(abs(L.FUCO_FUCA - distance_between(FUCO, P.FUCA)) < 1e-6, "Distance of FUCO_FUCA has changed, check logic");
assert(abs(L.FLCO_FLCF - distance_between(FLCO, P.FLCF)) < 1e-6, "Distance of FLCO_FLCF has changed, check logic");
assert(abs(L.FLCO_FLCA - distance_between(FLCO, P.FLCA)) < 1e-6, "Distance of FLCO_FLCA has changed, check logic");
assert(abs(L.FUCO_FLCO - distance_between(FUCO, FLCO)) < 1e-6, "Distance of FUCO_FLCO has changed, check logic");
assert(abs(L.FTRO_FUCO - distance_between(FTRO, FUCO)) < 1e-6, "Distance of FTRO_FUCO has changed, check logic");
assert(abs(L.FTRO_FLCO - distance_between(FTRO, FLCO)) < 1e-6, "Distance of FTRO_FLCO has changed, check logic");
assert(abs(L.FTRO_FTRI - distance_between(FTRO, P.FTRI)) < 1e-6, "Distance of FTRO_FTRI has changed, check logic");
assert(abs(L.FWC_FUCO  - distance_between(FWC,  FUCO)) < 1e-6, "Distance of FWC_FUCO has changed, check logic");
assert(abs(L.FWC_FLCO  - distance_between(FWC,  FLCO)) < 1e-6, "Distance of FWC_FLCO has changed, check logic");
assert(abs(L.FWC_FTRO  - distance_between(FWC,  FTRO)) < 1e-6, "Distance of FWC_FTRO has changed, check logic");
end