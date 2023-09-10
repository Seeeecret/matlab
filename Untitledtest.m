% �����ʼ��
x0 = [0,0,4,6,24,zeros(1,24*24*2)]; % ������λ�ã����վ��ߴ磬���վ���Ŀ��λ��

% �����Ż�ѡ��
options = optimoptions ('fsolve', 'Display', 'iter', 'PlotFcn' ,@optimplotfirstorderopt);

% ���� fsolve ����
[x,fval] = fsolve (@objfun,x0,options);

% ��ȡ����
x_tower = x(1); % ������ x ����
y_tower = x(2); % ������ y ����
h_mirror = x(3); % ���վ��߶�
w_mirror = x(4); % ���վ����
n_mirror = x(5); % ���վ���Ŀ
p_mirror = reshape(x(6:end),[],2); % ���վ�λ�þ���

% ��������ָ��
P_o_bar = fval(1)+60; % ƽ���������
P_u_bar = -fval(1)/(h_mirror*w_mirror*n_mirror*360*5); % ƽ����λ����

% ������
fprintf ('������λ������Ϊ (%.2f,%.2f) m\n', x_tower, y_tower);
fprintf ('���վ��ߴ�Ϊ %.2f m x %.2f m\n', h_mirror, w_mirror);
fprintf ('���վ���ĿΪ %d ��\n', n_mirror);
fprintf ('���վ�λ�þ���Ϊ\n');
disp (p_mirror);
fprintf ('��λ���������ƽ������ȹ���Ϊ %.3f MW/m^2\n', P_u_bar);
