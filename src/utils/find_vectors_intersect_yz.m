function coords = find_vectors_intersect_yz(p1, v1, p2, v2)
num =  v2(2)*(p1(3) - p2(3)) - v2(3)*(p1(2) - p2(2));
den =  v1(2)*v2(3) - v1(3)*v2(2);

t = num / den;

x = v1(1) * t + p1(1);
y = v1(2) * t + p1(2);
z = v1(3) * t + p1(3);

coords = [x, y, z];
end