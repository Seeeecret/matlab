function eta_cos = calculate_cosine_efficiency(alpha, gamma, mirror_positions, absorber_height, collector_height)
    % 计算太阳光向量
    sunlight_incidence_vector = [cos(alpha) * sin(gamma), cos(alpha) * cos(gamma), sin(alpha)];
    
    
    
    % 计算余弦效率（cosine_loss）
    x = mirror_positions(i, 1);
            y = mirror_positions(i, 2);
            z = mirror_positions(i, 3);
            heliostat_collector_vector = [-x,-y,-z+collector_height/2+absorber_height]; %定日镜与集热器相对位置的向量
    
            % 单位化 sunlight_incidence_vector
            norm_sunlight = norm(sunlight_incidence_vector);
            unit_sunlight_vector = sunlight_incidence_vector / norm_sunlight;

            % 单位化 heliostat_collector_vector
            norm_heliostat = norm(heliostat_collector_vector);
            unit_heliostat_collector_vector = heliostat_collector_vector / norm_heliostat;
    
            sum_vector = unit_sunlight_vector + unit_heliostat_collector_vector; % 计算两个单位向量的和
    
            form_vector = norm(sum_vector); % 计算两个向量的和的范数
            mirror_normal_vector = sum_vector ./ form_vector; %计算定日镜法向量的单位向量
            % 计算两个向量的点积
            dot_product = dot(unit_heliostat_collector_vector,mirror_normal_vector);
            % 计算两个向量的范数
            norm_unit_heliostat_collector_vector = norm(unit_heliostat_collector_vector);
            norm_mirror_normal_vector= norm(mirror_normal_vector);
            cosine_loss = dot_product / (norm_unit_heliostat_collector_vector * norm_mirror_normal_vector);
            eta_cos = cosine_loss;
end
