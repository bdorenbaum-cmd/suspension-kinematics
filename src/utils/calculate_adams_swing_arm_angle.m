function phi_deg = calculate_adams_swing_arm_angle(svic, cog, wheelbase)

dx = svic(1) - cog(1);
dz = svic(3) - cog(3);

phi_deg = atan2(dz, dx) * 180/pi;

end