function roll_deg = calculate_roll_angle(left_WCP,right_WCP)
ground_vec = left_WCP - right_WCP;
roll_deg = atan2d(ground_vec(2), ground_vec(3));
if roll_deg > 0
    roll_deg = -roll_deg;
elseif roll_deg < 0
    roll_deg = roll_deg + 180;
end
end