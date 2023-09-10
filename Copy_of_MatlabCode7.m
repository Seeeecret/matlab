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

% 定义需要优化的参数及其范围
mirror_quantity = 10; % 设置为您需要的定日镜数量
mirror_positions = rand(mirror_quantity, 2); % 随机生成定日镜的位置
mirror_width = 8; % 设置定日镜镜面的宽度
mirror_height = 6; % 设置定日镜镜面的高度
installation_height = 3; % 设置定日镜的安装高度

% 定义粒子群算法的参数及其设置
popsize = 100; % 粒子个数
dim = 4 + mirror_quantity * 2; % 维度（吸收塔位置固定在原点）
max_iter = 500; % 最大迭代次数
xlimit_max = [8;8;6;mirror_quantity;350*ones(mirror_quantity,1);2*pi*ones(mirror_quantity,1)]; % 变量上界（由约束条件确定）
xlimit_min = [2;2;2;1;100*ones(mirror_quantity,1);zeros(mirror_quantity,1)]; % 变量下界（由约束条件确定）
vlimit_max = (xlimit_max - xlimit_min) * 0.2; % 速度上界（一般设置为变量范围的10%~20%）
vlimit_min = -vlimit_max; % 速度下界（一般设置为速度上界的相反数）
w = 0.6; % 惯性权重
c1 = 0.5; % 个体学习因子
c2 = 1.5; % 社会学习因子
pr = 0.4; % 变异概率

% 初始化粒子位置和速度
pop_x = zeros(dim,popsize); % 当前粒子位置
pop_v = zeros(dim,popsize); % 当前粒子速度
rand('state',sum(clock)); % 设置随机数种子
for j = 1:popsize
    % 位置初始化（在变量范围内随机生成）
    pop_x(:,j) = xlimit_min + rand(dim,1) .* (xlimit_max - xlimit_min);
    % 速度初始化（在速度范围内随机生成）
    pop_v(:,j) = vlimit_min + rand(dim,1) .* (vlimit_max - vlimit_min);
end

% 初始化个体极值和全局极值
lbest = pop_x; % 个体历史最佳位置
fitness_lbest = zeros(1,popsize); % 个体历史最佳适应度
popbest = pop_x(:,1); % 全局历史最佳位置
fitness_popbest = inf; % 全局历史最佳适应度

% 定义目标函数（单位镜面面积年平均输出热功率）
fun = @(x) -sum(Efield_per_month21_per_mirror(x)) / (x(1) * x(2) * x(4));



% 定义约束条件（返回值为0或正数表示满足约束，返回值为负数表示不满足约束）
bind1 = @(x) x(1) - x(2); % 镜面宽度不小于镜面高度
bind2 = @(x) x(3) - x(2)/2; % 安装高度保证镜面不触及地面
bind3 = @(x) min((x(5:end-1)-x(5)).^2 + (x(5:end-1).*x(end-1:end).*cos(x(end-1:end)-x(end))).^2 + (x(5:end-1).*x(end-1:end).*sin(x(end-1:end)-x(end))).^2 - (x(2)+5)^2); % 相邻定日镜底座中心之间的距离比镜面宽度多5 m以上

% 开始迭代优化
iter = 1; % 当前迭代次数
record = zeros(max_iter,1); % 记录每次迭代的全局最佳适应度
format long; % 设置输出格式为长浮点数
while iter <= max_iter
    for j = 1:popsize
        % 更新速度（边界处理）
        pop_v(:,j) = w*pop_v(:,j) + c1*rand*(lbest(:,j) - pop_x(:,j)) + c2*rand*(popbest - pop_x(:,j));
        for i = 1:dim
            if pop_v(i,j) > vlimit_max(i)
                pop_v(i,j) = vlimit_max(i);
            elseif pop_v(i,j) < vlimit_min(i)
                pop_v(i,j) = vlimit_min(i);
            end 
        end
        
        % 更新位置（边界处理）
        pop_x(:,j) = pop_x(:,j) + pop_v(:,j);
        for i = 1:dim
            if pop_x(i,j) > xlimit_max(i)
                pop_x(i,j) = xlimit_max(i);
            elseif pop_x(i,j) < xlimit_min(i)
                pop_x(i,j) = xlimit_min(i);
            end 
        end
        
        % 进行自适应变异（增加搜索多样性）
        if rand < pr
            i = ceil(dim*rand); % 随机选择一个维度进行变异
            pop_x(i,j) = xlimit_min(i) + rand*(xlimit_max(i) - xlimit_min(i)); % 在变量范围内随机生成一个新值替换原值
        end
        
        % 计算当前适应度（约束条件处理）
        if bind1(pop_x(:,j)) >= 0 && bind2(pop_x(:,j)) >= 0 && bind3(pop_x(:,j)) >= 0 % 满足所有约束条件
            fitness_pop(j) = fun(pop_x(:,j)); % 计算目标函数值作为适应度
        else % 不满足某些约束条件
            fitness_pop(j) = inf; % 设置适应度为无穷大，相当于惩罚不可行解
        end
        
        % 当前适应度与个体历史最佳适应度作比较
        if fitness_pop(j) < fitness_lbest(j)
            lbest(:,j) = pop_x(:,j); % 更新个体历史最佳位置
            fitness_lbest(j) = fitness_pop(j); % 更新个体历史最佳适应度
        end
        
        % 个体历史最佳适应度与全局历史最佳适应度作比较
        if fitness_popbest > fitness_lbest(j)
            fitness_popbest = fitness_lbest(j); % 更新全局历史最佳适应度
            popbest = lbest(:,j); % 更新全局历史最佳位置
        end
    end
    record(iter) = fitness_popbest; % 记录当前迭代的全局最佳适应度
    iter = iter + 1; % 更新迭代次数
end

% 输出解
minx = popbest % 最优解
miny = fitness_popbest % 最优值

% 绘制迭代过程曲线
plot(record,'r-'); 
title('粒子群算法迭代过程'); 
xlabel('迭代次数'); 
ylabel('当前迭代最佳函数值');
