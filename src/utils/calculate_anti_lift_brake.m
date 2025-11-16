function anti_lift_percent = calculate_anti_lift_brake(WCP, svic, brake_bias, cog_height, wheelbase)
% Calculating Anti-Lift brake assuming outboard brakes, thus we use WCP
% (not WC).

% Vector from contact patch to SVIC in side view (X-Z plane)
tan_phi = -(svic(3) - WCP(3)) / (svic(1) - WCP(1));

anti_lift_percent = (100 - brake_bias) * tan_phi * (wheelbase / cog_height);
end