%Plots the simulations 
%% Completely Random 

n_init_trials = 20;
sim_res_err_ran = [];
parfor trials = 1:40
    sim_res_err_ran(:,trials) = simulation(n_init_trials);
end
%values 
avg_error_ran = mean(sim_res_err_ran,2);
std_error_ran = std(sim_res_err_ran);

%% Greater than 20 i.e not random

n_init_trials = 40;
sim_res_err = [];
parfor trials = 1:40
    sim_res_err(:,trials) = simulation(n_init_trials);
end
%values 
avg_error = mean(sim_res_err,2);
std_error = std(sim_res_err);

%% Plot
alpha = 0.05;
standard_error_ran = std(avg_error_ran)*ones(size(trials));
standard_error = std(avg_error)*ones(size(trials));

trials = linspace(1,100)';

%Plot
figure(1)
confplot(trials,avg_error,standard_error);
figure(2)
confplot(trials,avg_error_ran,standard_error_ran);

L = findobj(1,'type','line');
copyobj(L,findobj(2,'type','axes'));

% figure(1)
% plot(avg_error_ran,'k')
% hold on 
% plot(avg_error,'r')
% title('Random vs Iterative Mapping');
% ylabel('Percent Error');
% xlabel('Trials');
% legend('Random','Iterative');

% figure(2)
% lower = ci_ran(1,:);
% upper = ci_ran(2,:);
% x = avg_error;




