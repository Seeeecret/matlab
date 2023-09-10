% ʹ������Ⱥ�㷨���������ƽ������ȹ��ʣ����¼�ƶ���ʣ�Ϊ60 MW�����ϣ����ж��վ��ߴ缰��װ�߶���ͬ������ƶ��վ��������²�������������λ�����ꡢ���վ��ߴ硢��װ�߶ȡ����վ���Ŀ�����վ�λ�ã�
% ʹ�ö��վ����ڴﵽ����ʵ������£� ��λ���������ƽ������ȹ��ʾ�����
etc_sb = 0.873541102107966; %��Ӱ�ڵ�Ч��
etc_ref = 0.92; %���淴����
% ���嵱��ʱ�������
local_time = [9, 10.5, 12, 13.5, 15];
Efield = 0;%������Ŷ��վ�������ƽ�����������
Efield_per_month21_per_mirror =zeros(length(local_time)); %������ŵ�ǰ״̬ĳ���¶��վ���ÿ��21�Ŷ��վ�����ƽ���������
Efield_per_month21 =zeros(length(local_time)); %������ŵ�ǰ״̬ģ����ÿ��21�Ŷ��վ�����ƽ���������
months = 1;
times = 1;% �ȼ�����һ�µ�1��ʱ�䣬���ŵ����ģ��
% ���ϱ�������֪��

% ���±�������δ֪������Ҫʹ������Ⱥ�㷨ȥ�Ż���������Ҫ��ʽ��ʼʹ������Ⱥ�㷨

% ������Ҫ�Ż��Ĳ������䷶Χ
mirror_quantity = 10; % ����Ϊ����Ҫ�Ķ��վ�����
mirror_positions = rand(mirror_quantity, 2); % ������ɶ��վ���λ��
mirror_width = 8; % ���ö��վ�����Ŀ��
mirror_height = 6; % ���ö��վ�����ĸ߶�
installation_height = 3; % ���ö��վ��İ�װ�߶�

% ��������Ⱥ�㷨�Ĳ�����������
popsize = 100; % ���Ӹ���
dim = 4 + mirror_quantity * 2; % ά�ȣ�������λ�ù̶���ԭ�㣩
max_iter = 500; % ����������
xlimit_max = [8;8;6;mirror_quantity;350*ones(mirror_quantity,1);2*pi*ones(mirror_quantity,1)]; % �����Ͻ磨��Լ������ȷ����
xlimit_min = [2;2;2;1;100*ones(mirror_quantity,1);zeros(mirror_quantity,1)]; % �����½磨��Լ������ȷ����
vlimit_max = (xlimit_max - xlimit_min) * 0.2; % �ٶ��Ͻ磨һ������Ϊ������Χ��10%~20%��
vlimit_min = -vlimit_max; % �ٶ��½磨һ������Ϊ�ٶ��Ͻ���෴����
w = 0.6; % ����Ȩ��
c1 = 0.5; % ����ѧϰ����
c2 = 1.5; % ���ѧϰ����
pr = 0.4; % �������

% ��ʼ������λ�ú��ٶ�
pop_x = zeros(dim,popsize); % ��ǰ����λ��
pop_v = zeros(dim,popsize); % ��ǰ�����ٶ�
rand('state',sum(clock)); % �������������
for j = 1:popsize
    % λ�ó�ʼ�����ڱ�����Χ��������ɣ�
    pop_x(:,j) = xlimit_min + rand(dim,1) .* (xlimit_max - xlimit_min);
    % �ٶȳ�ʼ�������ٶȷ�Χ��������ɣ�
    pop_v(:,j) = vlimit_min + rand(dim,1) .* (vlimit_max - vlimit_min);
end

% ��ʼ�����弫ֵ��ȫ�ּ�ֵ
lbest = pop_x; % ������ʷ���λ��
fitness_lbest = zeros(1,popsize); % ������ʷ�����Ӧ��
popbest = pop_x(:,1); % ȫ����ʷ���λ��
fitness_popbest = inf; % ȫ����ʷ�����Ӧ��

% ����Ŀ�꺯������λ���������ƽ������ȹ��ʣ�
fun = @(x) -sum(Efield_per_month21_per_mirror(x)) / (x(1) * x(2) * x(4));



% ����Լ������������ֵΪ0��������ʾ����Լ��������ֵΪ������ʾ������Լ����
bind1 = @(x) x(1) - x(2); % �����Ȳ�С�ھ���߶�
bind2 = @(x) x(3) - x(2)/2; % ��װ�߶ȱ�֤���治��������
bind3 = @(x) min((x(5:end-1)-x(5)).^2 + (x(5:end-1).*x(end-1:end).*cos(x(end-1:end)-x(end))).^2 + (x(5:end-1).*x(end-1:end).*sin(x(end-1:end)-x(end))).^2 - (x(2)+5)^2); % ���ڶ��վ���������֮��ľ���Ⱦ����ȶ�5 m����

% ��ʼ�����Ż�
iter = 1; % ��ǰ��������
record = zeros(max_iter,1); % ��¼ÿ�ε�����ȫ�������Ӧ��
format long; % ���������ʽΪ��������
while iter <= max_iter
    for j = 1:popsize
        % �����ٶȣ��߽紦��
        pop_v(:,j) = w*pop_v(:,j) + c1*rand*(lbest(:,j) - pop_x(:,j)) + c2*rand*(popbest - pop_x(:,j));
        for i = 1:dim
            if pop_v(i,j) > vlimit_max(i)
                pop_v(i,j) = vlimit_max(i);
            elseif pop_v(i,j) < vlimit_min(i)
                pop_v(i,j) = vlimit_min(i);
            end 
        end
        
        % ����λ�ã��߽紦��
        pop_x(:,j) = pop_x(:,j) + pop_v(:,j);
        for i = 1:dim
            if pop_x(i,j) > xlimit_max(i)
                pop_x(i,j) = xlimit_max(i);
            elseif pop_x(i,j) < xlimit_min(i)
                pop_x(i,j) = xlimit_min(i);
            end 
        end
        
        % ��������Ӧ���죨�������������ԣ�
        if rand < pr
            i = ceil(dim*rand); % ���ѡ��һ��ά�Ƚ��б���
            pop_x(i,j) = xlimit_min(i) + rand*(xlimit_max(i) - xlimit_min(i)); % �ڱ�����Χ���������һ����ֵ�滻ԭֵ
        end
        
        % ���㵱ǰ��Ӧ�ȣ�Լ����������
        if bind1(pop_x(:,j)) >= 0 && bind2(pop_x(:,j)) >= 0 && bind3(pop_x(:,j)) >= 0 % ��������Լ������
            fitness_pop(j) = fun(pop_x(:,j)); % ����Ŀ�꺯��ֵ��Ϊ��Ӧ��
        else % ������ĳЩԼ������
            fitness_pop(j) = inf; % ������Ӧ��Ϊ������൱�ڳͷ������н�
        end
        
        % ��ǰ��Ӧ���������ʷ�����Ӧ�����Ƚ�
        if fitness_pop(j) < fitness_lbest(j)
            lbest(:,j) = pop_x(:,j); % ���¸�����ʷ���λ��
            fitness_lbest(j) = fitness_pop(j); % ���¸�����ʷ�����Ӧ��
        end
        
        % ������ʷ�����Ӧ����ȫ����ʷ�����Ӧ�����Ƚ�
        if fitness_popbest > fitness_lbest(j)
            fitness_popbest = fitness_lbest(j); % ����ȫ����ʷ�����Ӧ��
            popbest = lbest(:,j); % ����ȫ����ʷ���λ��
        end
    end
    record(iter) = fitness_popbest; % ��¼��ǰ������ȫ�������Ӧ��
    iter = iter + 1; % ���µ�������
end

% �����
minx = popbest % ���Ž�
miny = fitness_popbest % ����ֵ

% ���Ƶ�����������
plot(record,'r-'); 
title('����Ⱥ�㷨��������'); 
xlabel('��������'); 
ylabel('��ǰ������Ѻ���ֵ');
