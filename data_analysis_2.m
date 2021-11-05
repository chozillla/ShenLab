S = what;
subjects = S.mat;

[w,~] = size(subjects);
for i = 1:w
    file_name = subjects(i);
    sprintf('%s.mat',file_name);
    get(file_name,'name')
    load('file_name')
    n = size(data,2);
    gain_total = [];
    for i = 1:n
        if data{5,i} == 2
            glast = data{2,i};
            gain_total = [gain_total;glast'];
        end
    end
    figure
    plotmatrix(gain_total)


    figure
    for i = 1:3
    subplot(1,3,i)
    plot(gain_total(:,2*i-1),gain_total(:,2*i))
    hold on
    scatter(gain_total(1,2*i-1),gain_total(1,2*i),100,'r')
    end
end