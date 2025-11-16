function anti_squat_percent = calculate_anti_squat(WCP, svic, cog_height, wheelbase)
% Calculating Anti-Squat percent assuming torque reaction taken by
% control arms (and no torque reaction taken by chassis), thus we use WCP
% (not WC).

% Vector from contact patch to SVIC in side view (X-Z plane)
tan_phi = -(svic(3) - WCP(3)) / (svic(1) - WCP(1));

anti_squat_percent = 100 * tan_phi * (wheelbase / cog_height);
end