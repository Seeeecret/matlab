function Efield_per_mirror = calculate_Efield_per_mirror( DNI_value,mirror_width,mirror_height,eta )
%Efield_per_mirror ���㵥�����վ��ڵ�ǰʱ�������ȹ���
%   �˴���ʾ��ϸ˵��
Efield_per_mirror = DNI_value * mirror_height * mirror_width * eta;

end

