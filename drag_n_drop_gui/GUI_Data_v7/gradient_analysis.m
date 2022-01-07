end_test = 79; % this is the number where you ended the trial
test_data = data(:,2:end_test);
gradient_data = cell(4,end_test);

for i = 1:(end_test-1)
        a = test_data{1,i};
        x = test_data{3,i};
        y = test_data{4,i};
        weight = test_data{5,i};
        gradient_data{1,i} = a;
        gradient_data{2,i} = x;
        gradient_data{3,i} = y;
        gradient_data{4,i} = weight;
end

% organize the data 

flag = cell2mat(test_data(5,:));
index = find(flag == 2);

%new_test_data = reshape(gradient_data,[5,11]);
count = 0;
for i = 1:(end_test-1)
    x = gradient_data{2,i};
    count = count + 1;
    y = gradient_data{3,i};
    count = count + 1;
    z = gradient_data{4,i};
    count = count + 1;
    quiver(x,y,z)
    hold on 
    axis equal
end






