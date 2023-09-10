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


mirror_quantity; % ���վ�������
mirror_positions;% ���վ���λ��,��x�����y�������������
mirror_width;% ���վ�����Ŀ��
mirror_height% ���վ�����ĸ߶�
installation_height;% ���վ��İ�װ�߶ȣ������ĸ߶�

eta_at = calculate_atmospheric_transmissivity(mirror_positions,installation_height);% ����͸����

for months = 1:12
    Efield_per_mirror_total = 0;
    for times = 1 : length(local_time)
        DNI_value = DNI(months,times); % ��ǰʱ���ķ���ֱ�ӷ�����ն� DNI
        alpha = alpha_matrix(months,times);% ��ǰʱ����̫���߶Ƚ�
        gamma = gamma_matrix(months,times);% ��ǰʱ����̫����λ��

        etc_cos = calculate_cosine_efficiency(alpha, gamma, mirror_positions, absorber_height, collector_height);% ����Ч��
        eta_trunc = calculate_truncation_efficiency(calculate_origin_truncation_efficiency(mirror_positions, mirror_width, mirror_height, installation_height),etc_cos);% �������ض�Ч��
        eta = etc_sb * etc_ref * etc_cos * eta_trunc * eta_at; % ����˾��ӵ�ǰʱ���ѧЧ�ʣ���Ϊ����Efield������ı���

        Efield_per_mirror = calculate_Efield_per_mirror(DNI_value,mirror_width,mirror_height,eta); % ���㵥�����浱ǰʱ������ȹ���,etaΪ����
        Efield_per_mirror_total = Efield_per_mirror_total +  Efield_per_mirror;
    end
    Efield_per_month21_per_mirror(months) = Efield_per_mirror_total/5;
end
    Efield_per_month21 = Efield_per_month21 + Efield_per_month21_per_mirror; % 
    
    % �����ж�
    Efield = sum(Efield_per_month21)* 365;%�����������жϴ˱�����Ҳ���Ƕ��վ����Ķ��ƽ������ȹ����Ƿ����60 000 000