function antiDivePercent = calculate_anti_dive(WCP, svic, brake_bias, cog_height, wheelbase)
% Vector from contact patch to SVIC in side view (X-Z plane)
tanPhi = (svic(3) - WCP(3)) / (svic(1) - WCP(1));

antiDivePercent = brake_bias * tanPhi * (wheelbase / cog_height);
end