% 定义目标的经纬度和海拔
lon = 98.5; % 东经为正
lat = 39.4; % 北纬为正
alt = 3000; % 单位为米

% 太阳常数
G0 = 1.366; % kW/m^2

% 海拔高度（单位：km）
H = 3;

a = 0.4237 - 0.00821 * (6 - H)^2;
b = 0.5055 + 0.00595 * (6.5 - H)^2;
c = 0.2711 + 0.01858 * (2.5 - H)^2;


% 定义春分日期和每月21日的日期序号
eq_date = datenum(2023,3,21); % 春分日期
m21_date = datenum(2023,1:12,21); % 每月21日的日期序号
% 定义当地时间的数组
local_time = [9, 10.5, 12, 13.5, 15];

% 创建一个空矩阵存储结果
result = zeros(length(m21_date), length(local_time));
alpha_matrix = zeros(length(m21_date), length(local_time));
omega_matrix = zeros(length(m21_date), length(local_time));
delta_matrix = zeros(length(m21_date), length(local_time));
gamma_matrix = zeros(length(m21_date), length(local_time));
% 循环遍历每个日期和时间
for i = 1:length(m21_date)
    for j = 1:length(local_time)
        % 计算天数D
        if m21_date(i) < eq_date % 如果是一月份或二月份
            D = m21_date(i) - eq_date + 365; % 加上一年的天数
        else % 如果是其他月份
            D = m21_date(i) - eq_date;
        end
        % 计算太阳赤纬角delta
        delta = sun_declination(D);
        % 计算太阳时角omega
        omega = sun_hour_angle(local_time(j));
        % 计算太阳高度角alpha
        alpha = (sun_altitude(lat, delta, omega));
        
        % 计算太阳方位角gamma
        gamma = sun_azimuth(lat, delta, omega);
        
        % 将结果存入矩阵中
        result(i,j) = rad2deg(alpha);
        alpha_matrix(i,j) = alpha;
        omega_matrix(i,j) = omega;
        delta_matrix(i,j) = delta;
        gamma_matrix(i,j) = gamma;
    end
end

fprintf('radResult=\n');
disp(alpha_matrix);


% 显示结果矩阵
fprintf('result=\n');
disp(result);

% 计算DNI矩阵

DNI = G0 * (a + b * exp(-c ./ sin(alpha_matrix)));

disp(DNI);

% 绘制DNI矩阵的图表
imagesc(DNI);
colorbar;
title('DNI 矩阵');
y = 1:12; % 创建一个从1到12，步长为1的向量，表示月份
set(gca,'YTick',y); % 设置纵轴坐标的刻度
set(gca,'XTickLabel',local_time); 
ylabel('月份');
xlabel('时间');
