function roll_deg = calculate_roll_angle(left_WCP,right_WCP)
right_WCP = [right_WCP(1), -right_WCP(2), right_WCP(3)];
ground_vec = left_WCP - right_WCP;

roll_deg = atan2d(abs(ground_vec(2)), ground_vec(3)) - 90;
end