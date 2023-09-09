function delta = sun_declination(d)
   delta = asin(sin(2*pi*(23.45)/360) * sin(2*pi*d/(365)));
   %delta = (sin(2*pi*(23.45)/360) * sin(2*pi*d/(365)));

end
