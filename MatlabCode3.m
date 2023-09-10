%�����ѧЧ��

%����Excel�ļ�
file_path = 'D:\File\ѧϰ���\�ʼ�\����\��ѧ��ģ\A��\����(��z��).xlsx';
data = xlsread(file_path);

file_path_2 = 'D:\File\ѧϰ���\�ʼ�\����\��ѧ��ģ\A��\����(TE).xlsx';
data_2 = xlsread(file_path_2);

eta_trunc_values = data_2(:,3);

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
% ����DNI����
DNI = G0 * (a + b * exp(-c ./ sin(alpha_matrix)));

% ��������
mirror_positions = data; % ���� data �����˾��ӵ�λ������
tower_center = [0, 0]; % ��λ�ڳ�������
absorber_height = 80; % �������߶ȣ���λ���ף�
mirror_height = 4; % ���Ӹ߶ȣ���λ���ף�
mirror_width = 6; % ���ӿ�ȣ���λ���ף�
collector_height = 8;% �������߶�
collector_diameter = 7; % ������ֱ��


eta_ref = 0.92; % ���淴����
capacity = 1800; % ָ������

% ����ÿ�����ӵ�����ˮƽ���루dHR��
dHR_values = []; % ʹ�� zeros ����Ԥ�ȷ���ռ�;
for i = 1:size(mirror_positions, 1)
    x = mirror_positions(i, 1);
    y = mirror_positions(i, 2);
    dHR = sqrt((x - tower_center(1))^2 + (y - tower_center(2))^2 + (absorber_height - mirror_height + collector_height/2)^2);
    dHR_values(i) = dHR;
end

% ����ÿ�� dHR ֵ��Ӧ�Ĵ���͸���ʣ�eta_at��
eta_at_values = zeros(1, length(dHR_values)); % ʹ�� zeros ����Ԥ�ȷ���ռ�;
for i = 1:length(dHR_values)
    dHR = dHR_values(i);
    if dHR <= 1000
        eta_at = 0.99321 - 0.0001176 * dHR + 1.97e-8 * dHR^2;
    else
        eta_at = 0; % ���� dHR > 1000 ��������ȼ���͸����Ϊ0
    end
    eta_at_values(i) = eta_at;
end
%data_table = table([], [], [],[],[],[], 'VariableNames', {'date ',' time ',' cosine_efficiency ',' shadow_blocking_efficiency ',' truncation_efficiency ',' overall_optical_efficiency'});
%data_table = table([], [], [],[],[],[],'VariableNames',{'Date','Time','CosineLoss','ShadowLoss','TruncationLoss','OpticalEfficiency'});
% ����һ���ַ���Ԫ�����飬�����б�������
varNames = {'date', 'time', 'eta_cos', 'eta_sb', 'eta_trunc', 'eta'};

% ����һ������һ�����ݵı�񣬲�ָ���б�������
data_table = cell2table(cell(1, numel(varNames)), 'VariableNames', varNames);

months = 4;%ָ��ʹ�õ�6�µ�����
times = 3;%ָ��ʹ��12�������

for months = 1:length(m21_date)
    for times = 1:length(local_time)
% ����ÿ�����ӵ���Ӱ�赲Ч�ʣ�eta_sb��
        eta_sb = 1; % ����û����Ӱ�赲��ʧ
%xlswrite(eta_sb, output_file_path,'Sheet1','Range','D2:','WriteVariableNames', false);
 
%xlswrite(m21_date(months), output_file_path,'Sheet1''Range','A2','WriteVariableNames', false);

%xlswrite(local_time(times), output_file_path,'Sheet',1,'Range','B2','WriteVariableNames', false);


%xlswrite(eta_trunc, output_file_path,'Sheet',1,'Range','E2' ,'WriteVariableNames', false);

% ������ÿ��̫���߶Ƚ��µ�����Ч�ʣ�eta_cos��
        eta_cos_values = zeros(1, length(dHR_values));
% ����ÿ�����ӵ������ѧЧ�ʣ�eta_values����������Ч�ʳ���һ�𣬰�����Ӱ�赲Ч�ʡ�����Ч�ʡ�����͸���ʡ��ض�Ч�ʺ;��淴����
        eta_values = [];
        for i = 1:length(dHR_values)
            etc_alpha = alpha_matrix(months,times);
            etc_gamma = gamma_matrix(months,times);
            % ����̫��������
            sunlight_incidence_vector = [cos(etc_alpha) * sin(etc_gamma),cos(etc_alpha) * cos(etc_gamma),sin(etc_alpha)];
            x = mirror_positions(i, 1);
            y = mirror_positions(i, 2);
            z = mirror_positions(i, 3);
            heliostat_collector_vector = [-x,-y,-z+collector_height/2+absorber_height]; %���վ��뼯�������λ�õ�����
    
            % ��λ�� sunlight_incidence_vector
            norm_sunlight = norm(sunlight_incidence_vector);
            unit_sunlight_vector = sunlight_incidence_vector / norm_sunlight;

            % ��λ�� heliostat_collector_vector
            norm_heliostat = norm(heliostat_collector_vector);
            unit_heliostat_collector_vector = heliostat_collector_vector / norm_heliostat;
    
            sum_vector = unit_sunlight_vector + unit_heliostat_collector_vector; % ����������λ�����ĺ�
    
            form_vector = norm(sum_vector); % �������������ĺ͵ķ���
            mirror_normal_vector = sum_vector ./ form_vector; %���㶨�վ��������ĵ�λ����
            % �������������ĵ��
            dot_product = dot(unit_heliostat_collector_vector,mirror_normal_vector);
            % �������������ķ���
            norm_unit_heliostat_collector_vector = norm(unit_heliostat_collector_vector);
            norm_mirror_normal_vector= norm(mirror_normal_vector);
            cosine_loss = dot_product / (norm_unit_heliostat_collector_vector * norm_mirror_normal_vector);
            eta_cos_values(i) =  cosine_loss;
            %disp(cosine_loss);
            
            % ���ڽض�Ч�ʣ�eta_trunc����������Ҫ֪�����������յ��������;��ӷ������������ֵ�����ļ��еõ�
             eta_trunc = eta_trunc_values(i);
            
            eta_at = eta_at_values(i);
            eta_cos = eta_cos_values(i); % �Ѿ�����������Ч��
            eta = eta_sb * eta_cos * eta_at * eta_trunc * eta_ref;
            eta_values(i) = eta;
            date = months;
            time = local_time(times);
            new_row = table (date,time,eta_cos,eta_sb,eta_trunc,eta);
            
            % ���µı������ӵ��ձ����
            data_table = vertcat(data_table, new_row);
        end
    end
end

%disp(eta_values); % ��ʾÿ�����ӵĹ�ѧЧ��
% ���� table ��.mat �ļ�
save('data_table_new.mat', 'data_table');

% ���߽� table ����Ϊ������ʽ������ CSV
writetable(data_table, 'data_table_new.xlsx');
% ����һ���µ�ͼ�δ���
figure;
x_special = 0; % ������X����
y_special = 0; % ������Y����
z_special = 84; 


special_color = 'r';
special_size = 100;
% ʹ�� scatter �������ɴ���ɫ����״ͼ
scatter3(mirror_positions(:, 1), mirror_positions(:, 2),mirror_positions(:,3), 15, eta_values, 'filled','DisplayName','���վ�');
% ������ɫӳ�䷶Χ
min_eta = 0;
max_eta = 1.0;
% ����ͼ�����ԣ����������ǩ
title('���ӹ�ѧЧ�ʷֲ�ͼ');
xlabel('X������(m)'); % ����X���ǩ
ylabel('Y������(m)'); % ����Y���ǩ
zlabel('Z������(m)'); % ����Z���ǩ
hold on; % ����ͼ�β����
scatter3(x_special, y_special, z_special,special_size, special_color, 'filled','^','DisplayName','������'); % �����ʹ�ú�ɫ�����
hold off; % ����ͼ�α���״̬
% �����ɫ��
colorbar;
% ѡ����ɫӳ��
colormap(jet);

% ������ɫӳ�䷶Χ
caxis([min_eta, max_eta]);

% ������ɫ������
c = colorbar;
c.Label.String = '��ѧЧ��';
grid on;
xtick_values = -400:50:400; % ������Ҫ����X��̶�
ytick_values = -400:50:400; % ������Ҫ����Y��̶�
%ztick_values = 0:20:100; % ������Ҫ����Z��̶�
set(gca, 'XTick', xtick_values);
set(gca, 'YTick', ytick_values);
%set(gca, 'ZTick', ztick_values);
legend('Location', 'best'); % ������Ҫָ��ͼ��λ��
%disp(alpha_matrix);
disp(gamma_matrix);
