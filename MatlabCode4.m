% ������ά����

% ��ȡ Excel �ļ��е���������
file_path = 'D:\File\ѧϰ���\�ʼ�\����\��ѧ��ģ\A��\����(��z��).xlsx';

data = xlsread(file_path);

% �ֱ��ȡ X��Y �� Z ��������
x = data(:, 1);
y = data(:, 2);
z = data(:, 3);

x_special = 0; % ������X����
y_special = 0; % ������Y����
z_special = 84;
special_color = 'r';
special_size = 75

% ����һ����ά����ϵ
figure;
scatter3(x, y, z,10,'MarkerEdgeColor','blue','MarkerFaceColor', 'black','Marker','o','DisplayName','���վ�'); % ʹ�� 'filled' ��ʾ�����
% �����������ǩ
hold on; % ����ͼ�β����
scatter3(x_special, y_special, z_special,special_size, special_color, 'filled','^','DisplayName','������'); % �����ʹ�ú�ɫ�����
hold off; % ����ͼ�α���״̬
xlabel('X������(m)'); % ����X���ǩ
ylabel('Y������(m)'); % ����Y���ǩ
zlabel('Z������(m)'); % ����Z���ǩ

% ��������
grid on;

% ��ӱ���
title('���վ��뼯��������ά����');
legend('Location', 'best'); % ������Ҫָ��ͼ��λ��
