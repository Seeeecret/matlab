function orgin_truncation_efficiency = calculate_origin_truncation_efficiency(mirror_positions, mirror_width, mirror_height, installation_height)
    
% 假设需要定义的变量如下：
num_rays = 10000; % 发射射线的数量
collector_diameter = 7  % 指定收集器直径
tower_height = 80  % 指定塔高度
collector_height = 8  % 指定收集器高度
collector_radius = collector_diameter / 2;
collector_base = tower_height;
collector_top = tower_height + collector_height;

cone_angle = 32/60; % 太阳锥角
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

