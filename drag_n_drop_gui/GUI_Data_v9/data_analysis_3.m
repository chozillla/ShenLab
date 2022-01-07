S = what;
subjects = S.mat;
% things to do:
% plot the spectral data for Eric and lauren's data

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
    gain_total = gain_total - mean(gain_total,2)*ones(1,6);
    
    figure
    title(file_name)
    plotmatrix(gain_total)
    
    figure
    title(file_name)
    for w = 1:3
        subplot(1,3,w)
        plot(gain_total(:,2*w-1),gain_total(:,2*w))
        hold on
        scatter(gain_total(1,2*w-1),gain_total(1,2*w),100,'g')
    end
    
    figure
    title(file_name)
    z = cell2mat(data(2,:));
    mesh(z)
    colorbar
    xlabel('Trial Number')
    ylabel('Frequency Bands')
    zlabel('Gain')
    
end