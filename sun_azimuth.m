function gamma = sun_azimuth(phi, delta, omega)% 定义一个函数计算太阳方位角
    alpha = sun_altitude(phi,delta,omega); %计算太阳高度角
    gamma = (sin(delta)-sin(alpha)* sind(phi))/(cos(delta) * cosd(phi))
end
