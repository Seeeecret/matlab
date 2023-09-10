% 求平均输出热功率

% 读取每月平均光学效率
data = xlsread('D:\Programs\MatlabSoftware\bin\project\testproject\eta_average_2.xls');

N_data = xlsread('D:\File\学习相关\笔记\竞赛\数学建模\A题\附件.xlsx');
N = length(N_data);
eta_average = data(: , 2);
%eta_average = [1,1,1,1,1,1,1,1,1,1,1,1];
E_per_months21 = [];
E = 0;
E_per_months21_total = 0;
for month = 1:12
    E = 0;
    for times = 1:5
        DNI_value = DNI(month,times);
        for i = 1:N;
            E = E + DNI_value * 36 * eta_average(month);
        end
    end
    E_per_months21(month) = E;
    E_per_months21_total = E_per_months21_total + E;
end
E_in_year_average = 365*E_per_months21_total/12
E_in_year_per_unit_area_average = 365* E_per_months21_total / (36*N)/12;% 单位面积镜面年平均输出热功率
fprintf('E_per_months21:\n')
disp(E_per_months21);
fprintf('E_in_year_average:\n')
disp(E_in_year_average);
fprintf('E_in_year_per_unit_area_average:\n')
disp(E_in_year_per_unit_area_average);
        