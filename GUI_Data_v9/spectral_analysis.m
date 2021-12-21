% loading in data
S = what;
subjects = S.mat;

[w,~] = size(subjects);

for i = 1:w
    file_name = char(subjects(i));
    load(file_name)

    flag = cell2mat(data(5,:));
    index = find(flag == 2);
    x_data = cell2mat(data(3,index));
    a_values = cell2mat(data(1,index));

    data_spec = cumsum((x_data.*a_values))';
    figure
    plotmatrix(data_spec)
    title(file_name)
    figure
    plot(mean(data_spec))
    figure
     
    for w = 1:3
        subplot(1,3,w)
        plot(data_spec(:,2*w-1),data_spec(:,2*w))
        hold on
        scatter(data_spec(1,2*w-1),data_spec(1,2*w),100,'r')
    end
    % put in end points 
    % put in point every x number of points
    % check about the 100 db range in the third subplot
    title(file_name)
end
