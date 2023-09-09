function alpha = sun_altitude(phi, delta, omega)
    sinAlpha = (sind(phi)*sin(delta) + cosd(phi)*cos(delta)*cos(omega));
    alpha = asin(sinAlpha);
end