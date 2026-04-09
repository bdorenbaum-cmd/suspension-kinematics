function height = calculate_roll_center_roll(left_WCP,left_fvic,right_WCP,right_fvic)
left_vector = left_fvic - left_WCP;

right_vector = right_fvic - right_WCP;
right_vector = [right_vector(1), -right_vector(2), right_vector(3)];

right_WCP = [right_WCP(1), -right_WCP(2), right_WCP(3)];

height = calculate_roll_center(left_WCP,left_vector,right_WCP,right_vector);
end