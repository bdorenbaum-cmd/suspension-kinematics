function [x0, axis] = calculate_instant_axis(UCA, UCF, LCA, LCF, UO, LO)
% Instantaneous rotation axis of the upright (intersection of two planes):
%  - Plane through UO with normal along upper arm axis (FUCF->FUCA)
%  - Plane through LO with normal along lower arm axis (FLCF->FLCA)
vectorU1 = UCA - UO;
vectorU2 = UCA - UCF;
planeU = cross(vectorU1, vectorU2);

vectorL1 = LCA - LO;
vectorL2 = LCA - LCF;
planeL = cross(vectorL1, vectorL2);

axisDirectionVector = cross(planeU, planeL);

% Solve for the intersection point
% Use the two plane equations from above and set z=0, sovle for x,y
x = (planeL(1) * LCA(1) + planeL(2) * LCA(2) + planeL(3) * LCA(3) ...
    - (planeL(2) / planeU(2)) * (planeU(1) * UCA(1) + planeU(2) * UCA(2) + planeU(3) * UCA(3))) ...
    / (planeL(1) - (planeL(2) * planeU(1) / planeU(2)));

y = (planeU(1) * UCA(1) + planeU(2) * UCA(2) + planeU(3) * UCA(3) - planeU(1) * x) / planeU(2);

x0 = [x, y, 0];
axis = axisDirectionVector;
end