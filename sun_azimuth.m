function gamma = sun_azimuth(phi, delta, omega)% ����һ����������̫����λ��
    %alpha = sun_altitude(phi,delta,omega); %����̫���߶Ƚ�
    %gamma = acos((sin(delta)-sin(alpha)* sind(phi))/(cos(alpha) * cosd(phi)));
    gamma = atan(sin(omega)/(cos(omega)*sind(phi)-tan(delta)*cos(phi)));
end
