function result_vector = generate_random_cone_vector(base_vector, cone_angle)
    % 锥角为32度，将其转换为弧度
    cone_angle = deg2rad(cone_angle);

    % 在球坐标系下生成随机角度和长度
    theta = rand() * 2 * pi; % 极角（azimuthal angle），取值范围为 [0, 2π]
    phi = rand() * cone_angle; % 仰角（polar angle），取值范围为 [0, cone_angle]
    r = rand(); % 球坐标的半径，取值范围为 [0, 1]

    % 将球坐标转换为笛卡尔坐标
    x = r * sin(phi) * cos(theta);
    y = r * sin(phi) * sin(theta);
    z = r * cos(phi);

    % 平移向量以使（1, 1, 1）成为轴心
    center = base_vector;
    vector = [x, y, z];
    result_vector = center + vector;
end