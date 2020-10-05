%Plots the simulations 
%% Completely Random 

n_init_trials = 20;
sim_res_err_ran = [];
parfor trials = 1:100
    sim_res_err_ran(:,trials) = simulation(n_init_trials);
end
%plotting 
avg_error_ran = mean(sim_res_err_ran,2);



%% Greater than 20 i.e not random

n_init_trials = 40;
sim_res_err = [];
parfor trials = 1:100
    sim_res_err(:,trials) = simulation(n_init_trials);
end
%plotting 
avg_error = mean(sim_res_err,2);

%% Plot

figure(1)
plot(avg_error_ran,'k')
hold on 
plot(avg_error,'r')
title('Random vs Iterative Mapping');
ylabel('Percent Error');
xlabel('Trials');
legend('Random','Iterative');



