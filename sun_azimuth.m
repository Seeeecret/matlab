function gamma = sun_azimuth(phi, delta, omega)% ����һ����������̫����λ��
    alpha = sun_altitude(phi,delta,omega); %����̫���߶Ƚ�
    gamma = (sin(delta)-sin(alpha)* sind(phi))/(cos(delta) * cosd(phi))
end
