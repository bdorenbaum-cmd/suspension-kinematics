function height = calculate_roll_center_heave(fvic, WCP)
left_WCP = WCP;
left_vector = fvic - WCP;

right_WCP = [left_WCP(1), -left_WCP(2), left_WCP(3)];
right_vector = [left_vector(1), -left_vector(2), left_vector(3)];

height = calculate_roll_center(left_WCP,left_vector,right_WCP,right_vector);
end