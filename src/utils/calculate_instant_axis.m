function [x0, axis] = calculate_instant_axis(UCA, UCF, LCA, LCF, UO, LO)
%CALCULATE_INSTANT_AXIS  Instantaneous rotation axis of the upright.
%
% Geometric model:
% - Upper plane: passes through UO and contains vectors (UCA-UO) and (UCF-UO)
% - Lower plane: passes through LO and contains vectors (LCA-LO) and (LCF-LO)
% - Instant axis direction = intersection direction of the two planes:
%       axis ∝ nU × nL
%   where nU, nL are plane normals.
%
% Returns:
%   x0   - a point on the intersection line
%   axis - direction vector of the intersection line (unit length)
%
% Notes:
% - Robustly computes x0 by solving:
%       nU · x = dU
%       nL · x = dL
%       axis · x = axis · x_ref   (chooses the point closest to x_ref)
%   where x_ref is chosen as the midpoint of UO and LO.

    % ---- Build plane normals (use points through UO and LO as intended) ----
    u1 = UCA - UO;
    u2 = UCF - UO;
    nU = cross(u1, u2);

    l1 = LCA - LO;
    l2 = LCF - LO;
    nL = cross(l1, l2);

    % ---- Validate normals ----
    epsn = 1e-12;
    if norm(nU) < epsn
        error('calculate_instant_axis:degenerateUpper', ...
            'Upper plane is degenerate (points nearly collinear).');
    end
    if norm(nL) < epsn
        error('calculate_instant_axis:degenerateLower', ...
            'Lower plane is degenerate (points nearly collinear).');
    end

    % ---- Intersection direction ----
    axis = cross(nU, nL);
    if norm(axis) < epsn
        error('calculate_instant_axis:planesParallel', ...
            'Upper and lower planes are nearly parallel; instant axis ill-defined.');
    end
    axis = axis / norm(axis);

    % ---- Plane constants: n · x = d, with point on plane ----
    dU = dot(nU, UO);
    dL = dot(nL, LO);

    % ---- Choose a stable reference point for the "closest point" constraint ----
    x_ref = 0.5 * (UO + LO);

    % Solve for x0 using 3 linear constraints:
    %   [nU; nL; axis] * x = [dU; dL; axis·x_ref]
    A = [nU; nL; axis];
    b = [dU; dL; dot(axis, x_ref)];

    % Use least-squares (more stable than explicit inversion)
    x0 = A \ b;

    % Optional: you can assert that x0 satisfies the first two planes well
    % (tolerances depend on coordinate scaling)
end