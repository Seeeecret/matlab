function eta_cos = calculate_cosine_efficiency(alpha, gamma, mirror_positions, absorber_height, collector_height)
    % ����̫��������
    sunlight_incidence_vector = [cos(alpha) * sin(gamma), cos(alpha) * cos(gamma), sin(alpha)];
    
    
    
    % ��������Ч�ʣ�cosine_loss��
    x = mirror_positions(i, 1);
            y = mirror_positions(i, 2);
            z = mirror_positions(i, 3);
            heliostat_collector_vector = [-x,-y,-z+collector_height/2+absorber_height]; %���վ��뼯�������λ�õ�����
    
            % ��λ�� sunlight_incidence_vector
            norm_sunlight = norm(sunlight_incidence_vector);
            unit_sunlight_vector = sunlight_incidence_vector / norm_sunlight;

            % ��λ�� heliostat_collector_vector
            norm_heliostat = norm(heliostat_collector_vector);
            unit_heliostat_collector_vector = heliostat_collector_vector / norm_heliostat;
    
            sum_vector = unit_sunlight_vector + unit_heliostat_collector_vector; % ����������λ�����ĺ�
    
            form_vector = norm(sum_vector); % �������������ĺ͵ķ���
            mirror_normal_vector = sum_vector ./ form_vector; %���㶨�վ��������ĵ�λ����
            % �������������ĵ��
            dot_product = dot(unit_heliostat_collector_vector,mirror_normal_vector);
            % �������������ķ���
            norm_unit_heliostat_collector_vector = norm(unit_heliostat_collector_vector);
            norm_mirror_normal_vector= norm(mirror_normal_vector);
            cosine_loss = dot_product / (norm_unit_heliostat_collector_vector * norm_mirror_normal_vector);
            eta_cos = cosine_loss;
end
