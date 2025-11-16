function anti_dive_percent = calculate_anti_dive(WCP, svic, brake_bias, cog_height, wheelbase)
% Calculating Anti-Dive percent assuming outborad braking, thus we use WCP
% (not WC)

% Vector from contact patch to SVIC in side view (X-Z plane)
tan_phi = (svic(3) - WCP(3)) / (svic(1) - WCP(1));

anti_dive_percent = brake_bias * tan_phi * (wheelbase / cog_height);
end