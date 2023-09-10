%计算光学效率

%导入Excel文件
file_path = 'D:\File\学习相关\笔记\竞赛\数学建模\A题\附件(带z轴).xlsx';
data = xlsread(file_path);

file_path_2 = 'D:\File\学习相关\笔记\竞赛\数学建模\A题\附件(TE).xlsx';
data_2 = xlsread(file_path_2);

eta_trunc_values = data_2(:,3);

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
% 计算DNI矩阵
DNI = G0 * (a + b * exp(-c ./ sin(alpha_matrix)));

% 给定参数
mirror_positions = data; % 假设 data 包含了镜子的位置数据
tower_center = [0, 0]; % 塔位于场地中心
absorber_height = 80; % 吸收塔高度（单位：米）
mirror_height = 4; % 镜子高度（单位：米）
mirror_width = 6; % 镜子宽度（单位：米）
collector_height = 8;% 集热器高度
collector_diameter = 7; % 集热器直径


eta_ref = 0.92; % 镜面反射率
capacity = 1800; % 指定容量

% 计算每个镜子到塔的水平距离（dHR）
dHR_values = []; % 使用 zeros 函数预先分配空间;
for i = 1:size(mirror_positions, 1)
    x = mirror_positions(i, 1);
    y = mirror_positions(i, 2);
    dHR = sqrt((x - tower_center(1))^2 + (y - tower_center(2))^2 + (absorber_height - mirror_height + collector_height/2)^2);
    dHR_values(i) = dHR;
end

% 计算每个 dHR 值对应的大气透射率（eta_at）
eta_at_values = zeros(1, length(dHR_values)); % 使用 zeros 函数预先分配空间;
for i = 1:length(dHR_values)
    dHR = dHR_values(i);
    if dHR <= 1000
        eta_at = 0.99321 - 0.0001176 * dHR + 1.97e-8 * dHR^2;
    else
        eta_at = 0; % 对于 dHR > 1000 的情况，先假设透射率为0
    end
    eta_at_values(i) = eta_at;
end
%data_table = table([], [], [],[],[],[], 'VariableNames', {'date ',' time ',' cosine_efficiency ',' shadow_blocking_efficiency ',' truncation_efficiency ',' overall_optical_efficiency'});
%data_table = table([], [], [],[],[],[],'VariableNames',{'Date','Time','CosineLoss','ShadowLoss','TruncationLoss','OpticalEfficiency'});
% 创建一个字符串元胞数组，包含列变量名称
varNames = {'date', 'time', 'eta_cos', 'eta_sb', 'eta_trunc', 'eta'};

% 创建一个含有一行数据的表格，并指定列变量名称
data_table = cell2table(cell(1, numel(varNames)), 'VariableNames', varNames);

months = 4;%指定使用第6月的数据
times = 3;%指定使用12点的数据

for months = 1:length(m21_date)
    for times = 1:length(local_time)
% 计算每个镜子的阴影阻挡效率（eta_sb）
        eta_sb = 1; % 假设没有阴影阻挡损失
%xlswrite(eta_sb, output_file_path,'Sheet1','Range','D2:','WriteVariableNames', false);
 
%xlswrite(m21_date(months), output_file_path,'Sheet1''Range','A2','WriteVariableNames', false);

%xlswrite(local_time(times), output_file_path,'Sheet',1,'Range','B2','WriteVariableNames', false);


%xlswrite(eta_trunc, output_file_path,'Sheet',1,'Range','E2' ,'WriteVariableNames', false);

% 当计算每个太阳高度角下的余弦效率（eta_cos）
        eta_cos_values = zeros(1, length(dHR_values));
% 计算每个镜子的总体光学效率（eta_values）：将各种效率乘在一起，包括阴影阻挡效率、余弦效率、大气透射率、截断效率和镜面反射率
        eta_values = [];
        for i = 1:length(dHR_values)
            etc_alpha = alpha_matrix(months,times);
            etc_gamma = gamma_matrix(months,times);
            % 创建太阳光向量
            sunlight_incidence_vector = [cos(etc_alpha) * sin(etc_gamma),cos(etc_alpha) * cos(etc_gamma),sin(etc_alpha)];
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
            eta_cos_values(i) =  cosine_loss;
            %disp(cosine_loss);
            
            % 对于截断效率（eta_trunc），我们需要知道集热器接收到的能量和镜子反射的能量。其值已在文件中得到
             eta_trunc = eta_trunc_values(i);
            
            eta_at = eta_at_values(i);
            eta_cos = eta_cos_values(i); % 已经计算了余弦效率
            eta = eta_sb * eta_cos * eta_at * eta_trunc * eta_ref;
            eta_values(i) = eta;
            date = months;
            time = local_time(times);
            new_row = table (date,time,eta_cos,eta_sb,eta_trunc,eta);
            
            % 将新的表格行添加到空表格中
            data_table = vertcat(data_table, new_row);
        end
    end
end

%disp(eta_values); % 显示每个镜子的光学效率
% 保存 table 到.mat 文件
save('data_table_new.mat', 'data_table');

% 或者将 table 导出为其他格式，例如 CSV
writetable(data_table, 'data_table_new.xlsx');
% 创建一个新的图形窗口
figure;
x_special = 0; % 特殊点的X坐标
y_special = 0; % 特殊点的Y坐标
z_special = 84; 


special_color = 'r';
special_size = 100;
% 使用 scatter 函数生成带颜色的柱状图
scatter3(mirror_positions(:, 1), mirror_positions(:, 2),mirror_positions(:,3), 15, eta_values, 'filled','DisplayName','定日镜');
% 设置颜色映射范围
min_eta = 0;
max_eta = 1.0;
% 设置图形属性，如标题和轴标签
title('镜子光学效率分布图');
xlabel('X轴坐标(m)'); % 设置X轴标签
ylabel('Y轴坐标(m)'); % 设置Y轴标签
zlabel('Z轴坐标(m)'); % 设置Z轴标签
hold on; % 保持图形不清除
scatter3(x_special, y_special, z_special,special_size, special_color, 'filled','^','DisplayName','吸收塔'); % 特殊点使用红色并填充
hold off; % 结束图形保持状态
% 添加颜色栏
colorbar;
% 选择颜色映射
colormap(jet);

% 设置颜色映射范围
caxis([min_eta, max_eta]);

% 设置颜色栏标题
c = colorbar;
c.Label.String = '光学效率';
grid on;
xtick_values = -400:50:400; % 根据需要调整X轴刻度
ytick_values = -400:50:400; % 根据需要调整Y轴刻度
%ztick_values = 0:20:100; % 根据需要调整Z轴刻度
set(gca, 'XTick', xtick_values);
set(gca, 'YTick', ytick_values);
%set(gca, 'ZTick', ztick_values);
legend('Location', 'best'); % 根据需要指定图例位置
%disp(alpha_matrix);
disp(gamma_matrix);
