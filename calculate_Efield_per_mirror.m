function Efield_per_mirror = calculate_Efield_per_mirror( DNI_value,mirror_width,mirror_height,eta )
%Efield_per_mirror 计算单个定日镜在当前时间的输出热功率
%   此处显示详细说明
Efield_per_mirror = DNI_value * mirror_height * mirror_width * eta;

end

