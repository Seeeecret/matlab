% 建立三维坐标

% 读取 Excel 文件中的坐标数据
file_path = 'D:\File\学习相关\笔记\竞赛\数学建模\A题\附件(带z轴).xlsx';

data = xlsread(file_path);

% 分别获取 X、Y 和 Z 坐标数据
x = data(:, 1);
y = data(:, 2);
z = data(:, 3);

x_special = 0; % 特殊点的X坐标
y_special = 0; % 特殊点的Y坐标
z_special = 84;
special_color = 'r';
special_size = 75

% 创建一个三维坐标系
figure;
scatter3(x, y, z,10,'MarkerEdgeColor','blue','MarkerFaceColor', 'black','Marker','o','DisplayName','定日镜'); % 使用 'filled' 表示点填充
% 设置坐标轴标签
hold on; % 保持图形不清除
scatter3(x_special, y_special, z_special,special_size, special_color, 'filled','^','DisplayName','集热器'); % 特殊点使用红色并填充
hold off; % 结束图形保持状态
xlabel('X轴坐标(m)'); % 设置X轴标签
ylabel('Y轴坐标(m)'); % 设置Y轴标签
zlabel('Z轴坐标(m)'); % 设置Z轴标签

% 设置网格
grid on;

% 添加标题
title('定日镜与集热器的三维坐标');
legend('Location', 'best'); % 根据需要指定图例位置
