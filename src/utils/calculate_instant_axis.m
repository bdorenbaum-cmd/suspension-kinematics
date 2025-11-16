function [x0, axis] = calculate_instant_axis(P, UO, LO)
% Instantaneous rotation axis of the upright (intersection of two planes):
%  - Plane through UO with normal along upper arm axis (FUCF->FUCA)
%  - Plane through LO with normal along lower arm axis (FLCF->FLCA)
vectorU1 = P.FUCA - UO;
vectorU2 = P.FUCA - P.FUCF;
planeU = cross(vectorU1, vectorU2);

vectorL1 = P.FLCA - LO;
vectorL2 = P.FLCA - P.FLCF;
planeL = cross(vectorL1, vectorL2);

axisDirectionVector = cross(planeU, planeL);

% Solve for the intersection point
% Use the two plane equations from above and set z=0, sovle for x,y
x = (planeL(1) * P.FLCA(1) + planeL(2) * P.FLCA(2) + planeL(3) * P.FLCA(3) ...
    - (planeL(2) / planeU(2)) * (planeU(1) * P.FUCA(1) + planeU(2) * P.FUCA(2) + planeU(3) * P.FUCA(3))) ...
    / (planeL(1) - (planeL(2) * planeU(1) / planeU(2)));

y = (planeU(1) * P.FUCA(1) + planeU(2) * P.FUCA(2) + planeU(3) * P.FUCA(3) - planeU(1) * x) / planeU(2);

x0 = [x, y, 0];
axis = axisDirectionVector;
end