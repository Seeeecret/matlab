% 使用粒子群算法求出满足额定年平均输出热功率（以下简称额定功率）为60 MW或以上，所有定日镜尺寸及安装高度相同，请设计定日镜场的以下参数：吸收塔的位置坐标、定日镜尺寸、安装高度、定日镜数目、定日镜位置，
% 使得定日镜场在达到额定功率的条件下， 单位镜面面积年平均输出热功率尽量大
etc_sb = 0.873541102107966; %阴影遮挡效率
etc_ref = 0.92; %镜面反射率
% 定义当地时间的数组
local_time = [9, 10.5, 12, 13.5, 15];
Efield = 0;%用来存放定日镜场的年平均日输出功率
Efield_per_month21_per_mirror =zeros(length(local_time)); %用来存放当前状态某个下定日镜下每月21号定日镜场的平均输出功率
Efield_per_month21 =zeros(length(local_time)); %用来存放当前状态模拟下每月21号定日镜场的平均输出功率
months = 1;
times = 1;% 先假设在一月的1号时间，即九点进行模拟
% 以上变量是已知量

% 以下变量都是未知量，需要使用粒子群算法去优化，下面需要正式开始使用粒子群算法


mirror_quantity; % 定日镜的数量
mirror_positions;% 定日镜的位置,由x坐标和y坐标两部分组成
mirror_width;% 定日镜镜面的宽度
mirror_height% 定日镜镜面的高度
installation_height;% 定日镜的安装高度，即中心高度

eta_at = calculate_atmospheric_transmissivity(mirror_positions,installation_height);% 大气透射率

for months = 1:12
    Efield_per_mirror_total = 0;
    for times = 1 : length(local_time)
        DNI_value = DNI(months,times); % 当前时间点的法向直接辐射辐照度 DNI
        alpha = alpha_matrix(months,times);% 当前时间点的太阳高度角
        gamma = gamma_matrix(months,times);% 当前时间点的太阳方位角

        etc_cos = calculate_cosine_efficiency(alpha, gamma, mirror_positions, absorber_height, collector_height);% 余弦效率
        eta_trunc = calculate_truncation_efficiency(calculate_origin_truncation_efficiency(mirror_positions, mirror_width, mirror_height, installation_height),etc_cos);% 集热器截断效率
        eta = etc_sb * etc_ref * etc_cos * eta_trunc * eta_at; % 计算此镜子当前时间光学效率，此为计算Efield所必须的变量

        Efield_per_mirror = calculate_Efield_per_mirror(DNI_value,mirror_width,mirror_height,eta); % 计算单个镜面当前时间输出热功率,eta为必须
        Efield_per_mirror_total = Efield_per_mirror_total +  Efield_per_mirror;
    end
    Efield_per_month21_per_mirror(months) = Efield_per_mirror_total/5;
end
    Efield_per_month21 = Efield_per_month21 + Efield_per_month21_per_mirror; % 
    
    % 若干判断
    Efield = sum(Efield_per_month21)* 365;%迭代结束，判断此变量，也就是定日镜场的额定年平均输出热功率是否大于60 000 000