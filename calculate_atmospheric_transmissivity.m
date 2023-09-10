function eta_at = calculate_atmospheric_transmissivity(mirror_positions,installation_height)
    tower_center = [0,0];
    absorber_height=80;
    collector_height= 8;
    % 计算镜子镜面中心到集热器中心（dHR）
    dHR = sqrt((mirror_positions(1) - tower_center(1))^2 + (mirror_positions(2) - tower_center(2))^2 + (absorber_height - installation_height + collector_height/2)^2);
    % 计算大气透射率（eta_at）
    if dHR <= 1000
        eta_at = 0.99321 - 0.0001176 * dHR + 1.97e-8 * dHR^2;
    else
        eta_at = 0;
    end
end