function caster = calculate_caster(UO,LO)
% Side (x–z) view; positive when upper ball joint behind lower
axis_vec = UO - LO;
caster = atan2d(axis_vec(1), axis_vec(3));
end