function [UCO,LCO,TRO,WC,WCP] = displace_wheel_center(params)
% ---- Link lengths from static geometry
L.UCO_UCF  = distance_between(params.UCO, params.UCF);
L.UCO_UCA  = distance_between(params.UCO, params.UCA);
L.LCO_LCF  = distance_between(params.LCO, params.LCF);
L.LCO_LCA  = distance_between(params.LCO, params.LCA);
L.UCO_LCO  = distance_between(params.UCO, params.LCO);
L.TRO_UCO  = distance_between(params.TRO, params.UCO);
L.TRO_LCO  = distance_between(params.TRO, params.LCO);
L.TRO_TRI  = distance_between(params.TRO, params.TRI);
L.WC_UCO  = distance_between(params.WC, params.UCO);
L.WC_LCO  = distance_between(params.WC, params.LCO);
L.WC_TRO  = distance_between(params.WC, params.TRO);
L.WCP_UCO = distance_between(params.WCP, params.UCO);
L.WCP_LCO = distance_between(params.WCP, params.LCO);
L.WCP_TRO = distance_between(params.WCP, params.TRO);

% ---- Target travel (mm -> in) applied at UCO
desired_z = params.UCO(3) + convert_mm_to_inches(params.displacement);

% ---------- Solve UCO from two upper-pivot circles at desired_z ----------
c1 = struct('x',params.UCF(1),'y',params.UCF(2),'z',params.UCF(3),'r',L.UCO_UCF);
c2 = struct('x',params.UCA(1),'y',params.UCA(2),'z',params.UCA(3),'r',L.UCO_UCA);
UCO_cands = intersection_of_circles(c1, c2, desired_z);
assert_non_empty(UCO_cands, 'Upper conTROl arm intersection failed (UCO).');
UCO = pick_closest(UCO_cands, params.UCO);

% ---------- Solve LCO from three spheres (LCF, LCA, UCO-LCO length) ----------
c1 = struct('x',params.LCF(1),'y',params.LCF(2),'z',params.LCF(3),'r',L.LCO_LCF);
c2 = struct('x',params.LCA(1),'y',params.LCA(2),'z',params.LCA(3),'r',L.LCO_LCA);
c3 = struct('x',UCO(1),'y',UCO(2),'z',UCO(3),'r',L.UCO_LCO);
LCO_cands = intersection_of_spheres(c1, c2, c3);
assert_non_empty(LCO_cands, 'LCOwer conTROl arm intersection failed (LCO).');
LCO = pick_closest(LCO_cands, params.LCO);

% ---------- Solve TRO from three spheres (UCO, LCO, TRI) ----------
c1 = struct('x',UCO(1),'y',UCO(2),'z',UCO(3),'r',L.TRO_UCO);
c2 = struct('x',LCO(1),'y',LCO(2),'z',LCO(3),'r',L.TRO_LCO);
c3 = struct('x',params.TRI(1),'y',params.TRI(2),'z',params.TRI(3),'r',L.TRO_TRI);
TRO_cands = intersection_of_spheres(c1, c2, c3);
assert_non_empty(TRO_cands, 'Tie-rod intersection failed (TRO).');
TRO = pick_closest(TRO_cands, params.TRO);

% ---------- Dynamically solve WC from three spheres (UCO, LCO, TRO) ----------
c1 = struct('x',UCO(1),'y',UCO(2),'z',UCO(3),'r',L.WC_UCO);
c2 = struct('x',LCO(1),'y',LCO(2),'z',LCO(3),'r',L.WC_LCO);
c3 = struct('x',TRO(1),'y',TRO(2),'z',TRO(3),'r',L.WC_TRO);
WC_cands = intersection_of_spheres(c1, c2, c3);
assert_non_empty(WC_cands, 'Wheel center intersection failed (WC).');
WC = pick_closest(WC_cands, params.WC);

% ---------- Dynamically solve WCP from three spheres (UCO, LCO, TRO) ----------
c1 = struct('x',UCO(1),  'y',UCO(2),  'z',UCO(3),  'r',L.WCP_UCO);
c2 = struct('x',LCO(1),  'y',LCO(2),  'z',LCO(3),  'r',L.WCP_LCO);
c3 = struct('x',TRO(1), 'y',TRO(2), 'z',TRO(3), 'r',L.WCP_TRO);
WCP_cands = intersection_of_spheres(c1, c2, c3);
assert_non_empty(WCP_cands, 'Wheel contact patch intersection failed (WCP).');
% Sort candidates by ascending Y, We want to select the large Y since we
% are on the left side of the car.
[~, order] = sort(WCP_cands(:,2));
sorted = WCP_cands(order, :);
WCP = sorted(end, :);
tire_radius = norm(params.WC - params.WCP);
WCP = shift_wheel_contact_patch(tire_radius, WC, WCP);

% Validate the calculated positions against the original distances
assert(abs(L.UCO_UCF - distance_between(UCO, params.UCF)) < 1e-6, "Distance of UCO_UCF has changed, check logic");
assert(abs(L.UCO_UCA - distance_between(UCO, params.UCA)) < 1e-6, "Distance of UCO_UCA has changed, check logic");
assert(abs(L.LCO_LCF - distance_between(LCO, params.LCF)) < 1e-6, "Distance of LCO_LCF has changed, check logic");
assert(abs(L.LCO_LCA - distance_between(LCO, params.LCA)) < 1e-6, "Distance of LCO_LCA has changed, check logic");
assert(abs(L.UCO_LCO - distance_between(UCO, LCO)) < 1e-6, "Distance of UCO_LCO has changed, check logic");
assert(abs(L.TRO_UCO - distance_between(TRO, UCO)) < 1e-6, "Distance of TRO_UCO has changed, check logic");
assert(abs(L.TRO_LCO - distance_between(TRO, LCO)) < 1e-6, "Distance of TRO_LCO has changed, check logic");
assert(abs(L.TRO_TRI - distance_between(TRO, params.TRI)) < 1e-6, "Distance of TRO_TRI has changed, check logic");
assert(abs(L.WC_UCO  - distance_between(WC,  UCO)) < 1e-6, "Distance of WC_UCO has changed, check logic");
assert(abs(L.WC_LCO  - distance_between(WC,  LCO)) < 1e-6, "Distance of WC_LCO has changed, check logic");
assert(abs(L.WC_TRO  - distance_between(WC,  TRO)) < 1e-6, "Distance of WC_TRO has changed, check logic");
end