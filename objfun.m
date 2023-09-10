function F = objfun (x)
% x 是一个向量，包含 x, y, h, w, n, 和 p
% F 是一个向量，包含 F1, F2, ..., Fm
% 定义参数和变量
I0 = 1367; % 太阳常数
k1 = 0.05; % 热损失系数
k2 = 0.01; % 热损失系数
T = 500; % 导热介质温度
Ta = 10; % 环境温度
r = 3.5; % 集热器半径
rho_m = 0.9; % 定日镜反射率
rho_c = 0.8; % 集热器吸收率
phi = 39.4 * pi / 180; % 地理纬度
omega = 15 * pi / 180; % 地球自转角速度
% 从 x 中提取变量
x_tower = x (1); % 吸收塔 x 坐标
y_tower = x (2); % 吸收塔 y 坐标
h_mirror = x (3); % 定日镜高度
w_mirror = x (4); % 定日镜宽度
n_mirror = x (5); % 定日镜数目
p_mirror = reshape (x (6:end), [], 2); % 定日镜位置矩阵
% 计算目标函数值
F = zeros (5 + n_mirror * (n_mirror-1) / 2, 1); % 初始化 F
P_o = 0; % 初始化输出功率
P_u = 0; % 初始化单位功率
for n = 1:360 % 循环每一天
    delta = 23.45 * pi / 180 * sin (2 * pi / 365 * (284 + n)); % 太阳赤纬角
    for t = [9,10.5,12,13.5,15] % 循环每个时点
        theta_s = acos (sin (delta) * sin (phi) + cos (delta) * cos (phi) * cos (omega * t)); % 太阳入射角
        I_s = I0 * (1 + 0.033 * cos (2 * pi / 365 * n)) * cos (theta_s); % 太阳辐射强度
        for i = 1:n_mirror % 循环每个定日镜
            x_mirror = p_mirror (i,1); % 定日镜 x 坐标
            y_mirror = p_mirror (i,2); % 定日镜 y 坐标
            d = sqrt ((x_tower-x_mirror)^2 + (y_tower-y_mirror)^2 + h_tower^2); % 定日镜和集热器之间的距离
            theta_m = acos (sin (beta) * sin (alpha-gamma) + cos (beta) * cos (alpha-gamma)); % 定日镜法向角
            theta_r = acos (cos (theta_s + theta_m)); % 定日镜反射角
            theta_c = acos (h_tower / d); % 集热器接收角
            phi = theta_r - theta_c; % 反射光线和集热器轴线之间的夹角
            A_c = pi * r^2 * cos (phi); % 集热器截面积
            P_c = I_s * h_mirror * w_mirror * rho_m * A_c / d^2 * rho_c; % 集热器接收功率
            P_l = k1 * P_c + k2 * (T-Ta); % 热损失功率
            P_o = P_o + P_c - P_l; % 输出功率
            P_u = P_u + P_o / (h_mirror * w_mirror); % 单位功率
        end
    end
end
F (1) = P_o / (360*5) - 60; % 平均输出功率约束
F (2) = x_tower^2 + y_tower^2 - (350-100)^2; % 吸收塔位置约束
F (3) = h_mirror - 6; % 定日镜高度约束
F (4) = w_mirror - 8; % 定日镜宽度约束
F (5) = w_mirror - h_mirror; % 定日镜形状约束
k = 6; % F 向量的索引
for i = 1:n_mirror-1 % 循环每个定日镜
    for j = i+1:n_mirror % 循环每个定日镜
        d_ij = sqrt ((p_mirror(i,1)-p_mirror(j,1))^2 + (p_mirror(i,2)-p_mirror(j,2))^2); % 定日镜之间的距离
        F(k) = d_ij - w_mirror - 5; % 定日镜间距约束
        k = k+1; % 更新 F 向量的索引
    end
end

end

