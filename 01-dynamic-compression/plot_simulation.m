%Plots the simulations 
%% Completely Random 
%Actually this is non-random just too lazy to relabel

n_init_trials = 20;
sim_res_err_ran = [];
parfor trials = 1:100
    sim_res_err_ran(:,trials) = simulation(n_init_trials);
end
%values 
avg_error_ran = mean(sim_res_err_ran,2)';
std_error_ran = std(sim_res_err_ran);

%% Greater than 20 i.e not random

n_init_trials = 100;
sim_res_err = [];
parfor trials = 1:100
    sim_res_err(:,trials) = simulation(n_init_trials);
end
%values 
avg_error = mean(sim_res_err,2)';
std_error = std(sim_res_err);

%% Plot
% alpha = 0.05;
% trials = linspace(1,100)';
% standard_error_ran = std(avg_error_ran)*ones(size(trials));
% standard_error = std(avg_error)*ones(size(trials));

figure(1)
amatrix = sim_res_err_ran';
stdshade(amatrix,0.5,'r')
xlabel('Trials');
ylabel('Error');
legend('Iterative','Random');
hold on
amatrix = sim_res_err';
stdshade(amatrix,0.5,'g')



%Plot

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




