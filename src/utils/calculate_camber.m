function camber = calculate_camber(WC, WCP)
% Side (x–z) view; positive when upper ball joint behind lower
axis_vec = WC - WCP;
camber = atan2d(axis_vec(2), axis_vec(3));
end