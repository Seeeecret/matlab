function result_vector = generate_random_cone_vector(base_vector, cone_angle)
    % ׶��Ϊ32�ȣ�����ת��Ϊ����
    cone_angle = deg2rad(cone_angle);

    % ��������ϵ����������ǶȺͳ���
    theta = rand() * 2 * pi; % ���ǣ�azimuthal angle����ȡֵ��ΧΪ [0, 2��]
    phi = rand() * cone_angle; % ���ǣ�polar angle����ȡֵ��ΧΪ [0, cone_angle]
    r = rand(); % ������İ뾶��ȡֵ��ΧΪ [0, 1]

    % ��������ת��Ϊ�ѿ�������
    x = r * sin(phi) * cos(theta);
    y = r * sin(phi) * sin(theta);
    z = r * cos(phi);

    % ƽ��������ʹ��1, 1, 1����Ϊ����
    center = base_vector;
    vector = [x, y, z];
    result_vector = center + vector;
end