% ����1������Excel�ļ�
file_path = 'D:\File\ѧϰ���\�ʼ�\����\��ѧ��ģ\A��\����.xlsx';
data = xlsread(file_path);

% ����2������ɢ��ͼ
x = data(:, 1); % ��ȡX��������
y = data(:, 2); % ��ȡY��������
x_special = 0; % ������X����
y_special = 0; % ������Y����
special_color = 'r';
special_size = 100

scatter(x, y,10,'MarkerEdgeColor','blue','MarkerFaceColor', 'black','Marker','o','DisplayName','���վ�'); % ����ɢ��ͼ
hold on; % ����ͼ�β����
scatter(x_special, y_special, special_size, special_color, 'filled','^','DisplayName','������'); % �����ʹ�ú�ɫ�����
hold off; % ����ͼ�α���״̬

xlabel('X������(m)'); % ����X���ǩ
ylabel('Y������(m)'); % ����Y���ǩ
grid on;
title('����һ�ж��վ���������λ��ͼ'); % ����ͼ�����
legend('Location', 'best'); % ������Ҫָ��ͼ��λ��


