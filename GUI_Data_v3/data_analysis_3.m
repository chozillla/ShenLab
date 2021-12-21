S = what;
subjects = S.mat;

[w,~] = size(subjects);
for i = 1:w
    file_name = char(subjects(i));
    load(file_name)
    n = size(data,2);
    gain_total = [];
    for k = 1:n
        if data{5,k} == 2
            glast = data{2,k};
            gain_total = [gain_total;glast'];
        end
    end
    figure
    plotmatrix(gain_total)
    title(file_name)
    
    figure
    for w = 1:3
        subplot(1,3,w)
        plot(gain_total(:,2*w-1),gain_total(:,2*w))
        hold on
        scatter(gain_total(1,2*w-1),gain_total(1,2*w),100,'r')
    end
    title(file_name)
end