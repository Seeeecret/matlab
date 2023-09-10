function F = objfun (x)
% x ��һ������������ x, y, h, w, n, �� p
% F ��һ������������ F1, F2, ..., Fm
% ��������ͱ���
I0 = 1367; % ̫������
k1 = 0.05; % ����ʧϵ��
k2 = 0.01; % ����ʧϵ��
T = 500; % ���Ƚ����¶�
Ta = 10; % �����¶�
r = 3.5; % �������뾶
rho_m = 0.9; % ���վ�������
rho_c = 0.8; % ������������
phi = 39.4 * pi / 180; % ����γ��
omega = 15 * pi / 180; % ������ת���ٶ�
% �� x ����ȡ����
x_tower = x (1); % ������ x ����
y_tower = x (2); % ������ y ����
h_mirror = x (3); % ���վ��߶�
w_mirror = x (4); % ���վ����
n_mirror = x (5); % ���վ���Ŀ
p_mirror = reshape (x (6:end), [], 2); % ���վ�λ�þ���
% ����Ŀ�꺯��ֵ
F = zeros (5 + n_mirror * (n_mirror-1) / 2, 1); % ��ʼ�� F
P_o = 0; % ��ʼ���������
P_u = 0; % ��ʼ����λ����
for n = 1:360 % ѭ��ÿһ��
    delta = 23.45 * pi / 180 * sin (2 * pi / 365 * (284 + n)); % ̫����γ��
    for t = [9,10.5,12,13.5,15] % ѭ��ÿ��ʱ��
        theta_s = acos (sin (delta) * sin (phi) + cos (delta) * cos (phi) * cos (omega * t)); % ̫�������
        I_s = I0 * (1 + 0.033 * cos (2 * pi / 365 * n)) * cos (theta_s); % ̫������ǿ��
        for i = 1:n_mirror % ѭ��ÿ�����վ�
            x_mirror = p_mirror (i,1); % ���վ� x ����
            y_mirror = p_mirror (i,2); % ���վ� y ����
            d = sqrt ((x_tower-x_mirror)^2 + (y_tower-y_mirror)^2 + h_tower^2); % ���վ��ͼ�����֮��ľ���
            theta_m = acos (sin (beta) * sin (alpha-gamma) + cos (beta) * cos (alpha-gamma)); % ���վ������
            theta_r = acos (cos (theta_s + theta_m)); % ���վ������
            theta_c = acos (h_tower / d); % ���������ս�
            phi = theta_r - theta_c; % ������ߺͼ���������֮��ļн�
            A_c = pi * r^2 * cos (phi); % �����������
            P_c = I_s * h_mirror * w_mirror * rho_m * A_c / d^2 * rho_c; % ���������չ���
            P_l = k1 * P_c + k2 * (T-Ta); % ����ʧ����
            P_o = P_o + P_c - P_l; % �������
            P_u = P_u + P_o / (h_mirror * w_mirror); % ��λ����
        end
    end
end
F (1) = P_o / (360*5) - 60; % ƽ���������Լ��
F (2) = x_tower^2 + y_tower^2 - (350-100)^2; % ������λ��Լ��
F (3) = h_mirror - 6; % ���վ��߶�Լ��
F (4) = w_mirror - 8; % ���վ����Լ��
F (5) = w_mirror - h_mirror; % ���վ���״Լ��
k = 6; % F ����������
for i = 1:n_mirror-1 % ѭ��ÿ�����վ�
    for j = i+1:n_mirror % ѭ��ÿ�����վ�
        d_ij = sqrt ((p_mirror(i,1)-p_mirror(j,1))^2 + (p_mirror(i,2)-p_mirror(j,2))^2); % ���վ�֮��ľ���
        F(k) = d_ij - w_mirror - 5; % ���վ����Լ��
        k = k+1; % ���� F ����������
    end
end

end

