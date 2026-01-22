function kingpin_inclination = calculate_kingpin_inclination(UO, LO)
   vect = UO - LO; % Calculate the vector between control arm outboards
   kingpin_inclination = rad2deg(atan(vect(2)/vect(3))); % Calculate the angle using atan (looking from front)
   
end
