% 步骤1：导入Excel文件
file_path = 'D:\File\学习相关\笔记\竞赛\数学建模\A题\附件.xlsx';
data = xlsread(file_path);

% 步骤2：创建散点图
x = data(:, 1); % 提取X坐标数据
y = data(:, 2); % 提取Y坐标数据
x_special = 0; % 特殊点的X坐标
y_special = 0; % 特殊点的Y坐标
special_color = 'r';
special_size = 100

scatter(x, y,10,'MarkerEdgeColor','blue','MarkerFaceColor', 'black','Marker','o','DisplayName','定日镜'); % 创建散点图
hold on; % 保持图形不清除
scatter(x_special, y_special, special_size, special_color, 'filled','^','DisplayName','吸收塔'); % 特殊点使用红色并填充
hold off; % 结束图形保持状态

xlabel('X轴坐标(m)'); % 设置X轴标签
ylabel('Y轴坐标(m)'); % 设置Y轴标签
grid on;
title('问题一中定日镜与吸收塔位置图'); % 设置图表标题
legend('Location', 'best'); % 根据需要指定图例位置


