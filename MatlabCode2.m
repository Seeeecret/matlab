% ����Ŀ��ľ�γ�Ⱥͺ���
lon = 98.5; % ����Ϊ��
lat = 39.4; % ��γΪ��
alt = 3000; % ��λΪ��

% ̫������
G0 = 1.366; % kW/m^2

% ���θ߶ȣ���λ��km��
H = 3;

a = 0.4237 - 0.00821 * (6 - H)^2;
b = 0.5055 + 0.00595 * (6.5 - H)^2;
c = 0.2711 + 0.01858 * (2.5 - H)^2;


% ���崺�����ں�ÿ��21�յ��������
eq_date = datenum(2023,3,21); % ��������
m21_date = datenum(2023,1:12,21); % ÿ��21�յ��������
% ���嵱��ʱ�������
local_time = [9, 10.5, 12, 13.5, 15];

% ����һ���վ���洢���
result = zeros(length(m21_date), length(local_time));
alpha_matrix = zeros(length(m21_date), length(local_time));
omega_matrix = zeros(length(m21_date), length(local_time));
delta_matrix = zeros(length(m21_date), length(local_time));
gamma_matrix = zeros(length(m21_date), length(local_time));
% ѭ������ÿ�����ں�ʱ��
for i = 1:length(m21_date)
    for j = 1:length(local_time)
        % ��������D
        if m21_date(i) < eq_date % �����һ�·ݻ���·�
            D = m21_date(i) - eq_date + 365; % ����һ�������
        else % ����������·�
            D = m21_date(i) - eq_date;
        end
        % ����̫����γ��delta
        delta = sun_declination(D);
        % ����̫��ʱ��omega
        omega = sun_hour_angle(local_time(j));
        % ����̫���߶Ƚ�alpha
        alpha = (sun_altitude(lat, delta, omega));
        
        % ����̫����λ��gamma
        gamma = sun_azimuth(lat, delta, omega);
        
        % ��������������
        result(i,j) = rad2deg(alpha);
        alpha_matrix(i,j) = alpha;
        omega_matrix(i,j) = omega;
        delta_matrix(i,j) = delta;
        gamma_matrix(i,j) = gamma;
    end
end

fprintf('radResult=\n');
disp(alpha_matrix);


% ��ʾ�������
fprintf('result=\n');
disp(result);

% ����DNI����

DNI = G0 * (a + b * exp(-c ./ sin(alpha_matrix)));

disp(DNI);

% ����DNI�����ͼ��
imagesc(DNI);
colorbar;
title('DNI ����');
y = 1:12; % ����һ����1��12������Ϊ1����������ʾ�·�
set(gca,'YTick',y); % ������������Ŀ̶�
set(gca,'XTickLabel',local_time); 
ylabel('�·�');
xlabel('ʱ��');
