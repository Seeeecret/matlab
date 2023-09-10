% 定义初始点
x0 = [0,0,4,6,24,zeros(1,24*24*2)]; % 吸收塔位置，定日镜尺寸，定日镜数目和位置

% 定义优化选项
options = optimoptions ('fsolve', 'Display', 'iter', 'PlotFcn' ,@optimplotfirstorderopt);

% 调用 fsolve 函数
[x,fval] = fsolve (@objfun,x0,options);

% 提取变量
x_tower = x(1); % 吸收塔 x 坐标
y_tower = x(2); % 吸收塔 y 坐标
h_mirror = x(3); % 定日镜高度
w_mirror = x(4); % 定日镜宽度
n_mirror = x(5); % 定日镜数目
p_mirror = reshape(x(6:end),[],2); % 定日镜位置矩阵

% 计算性能指标
P_o_bar = fval(1)+60; % 平均输出功率
P_u_bar = -fval(1)/(h_mirror*w_mirror*n_mirror*360*5); % 平均单位功率

% 输出结果
fprintf ('吸收塔位置坐标为 (%.2f,%.2f) m\n', x_tower, y_tower);
fprintf ('定日镜尺寸为 %.2f m x %.2f m\n', h_mirror, w_mirror);
fprintf ('定日镜数目为 %d 面\n', n_mirror);
fprintf ('定日镜位置矩阵为\n');
disp (p_mirror);
fprintf ('单位镜面面积年平均输出热功率为 %.3f MW/m^2\n', P_u_bar);
