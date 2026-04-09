function height = calculate_roll_center(left_WCP,left_vector,right_WCP,right_vector)
% Find roll center coords
roll_center = find_vectors_intersect_yz(left_WCP,left_vector,right_WCP,right_vector);

% Ground vector in yz plane
ground_vector = left_WCP - right_WCP;
ground_vector_normal = cross(ground_vector, [1, 0, 0]);

% Find coords where the normal from the ground connects with RC
intersection_with_ground = find_vectors_intersect_yz(left_WCP,ground_vector,roll_center,ground_vector_normal);

% Find the distance between roll cetner and ground (Assume x will always
% match across all vectors/points we are comparing)
diff_vec = intersection_with_ground - roll_center;
normal_unit = ground_vector_normal / norm(ground_vector_normal);
height_inches = dot(diff_vec, normal_unit);

height = convert_inches_to_mm(height_inches);
end