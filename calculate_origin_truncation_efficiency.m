function orgin_truncation_efficiency = calculate_origin_truncation_efficiency(mirror_positions, mirror_width, mirror_height, installation_height)
    
% ������Ҫ����ı������£�
num_rays = 10000; % �������ߵ�����
collector_diameter = 7  % ָ���ռ���ֱ��
tower_height = 80  % ָ�����߶�
collector_height = 8  % ָ���ռ����߶�
collector_radius = collector_diameter / 2;
collector_base = tower_height;
collector_top = tower_height + collector_height;

cone_angle = 32/60; % ̫��׶��
truncated_ray = 0;
    fpoint = [0, 0, 80];
    vector = fpoint - [mirror_positions(1), mirror_positions(2), installation_height];

    % Generate rays for the current mirror
    for j = 1:num_rays
        % Random point on the mirror
        x_ray = mirror_positions(1) - mirror_width / 2 + rand() * mirror_width;
        y_ray = mirror_positions(2) - mirror_height / 2 + rand() * mirror_height;

        ray_direction = generate_random_cone_vector(vector, cone_angle);

        % Check if this ray can be reflected to the collector
        if ~hits_collector([x_ray, y_ray, installation_height], ray_direction, collector_radius, collector_base, collector_top)
            truncated_ray = truncated_ray + 1;
        end
    end
    orgin_truncation_efficiency = 1 - Decimal(truncated_ray) / Decimal(num_rays);
end

