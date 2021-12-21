load("Chemay16-Nov-2021.mat")

flag = cell2mat(data(5,:));
index = find(flag == 1);
counting_idx = 1;

for i = 1:numel(index)
    missing_data = data{2,index};
    a = data{1,index};
    x = data{3,index};
    y = data{4,index};
    Glast = data{2,counting_idx};
    G = Glast + x + y*a;
    data{2,index(i)} = G;
    %gt_empty = data{2,index};
    counting_idx = counting_idx + 1;
end


% glast = cell2mat(data(2,index(end))); 
% Glast = awgn(glast,5);
% G = Glast + x + y*a;

