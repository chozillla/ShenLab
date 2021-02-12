%Plots the simulations 
%Generate Ground truth models

N_reps = 10;
G0 = rand(6,N_reps)*30;  %Defining Ground Truth 30dB range 
sigma0 = 1;

%% Random 

n_init_trials = 100;
sim_res_err_ran = [];
parfor trials = 1:N_reps
    disp(trials)
    sim_res_err_ran(:,trials) = simulation(n_init_trials,G0(:,trials),sigma0);
end
%values 
avg_error_random = mean(sim_res_err_ran,2)';
std_error_random = std(sim_res_err_ran);

%% Active Learning i.e 

n_init_trials = 20;
sim_res_err = [];
parfor trials = 1:N_reps
    disp(trials)
    sim_res_err(:,trials) = simulation(n_init_trials,G0(:,trials),sigma0);
end
%values 
avg_error = mean(sim_res_err,2)';
std_error = std(sim_res_err);

%% Average Differance between errors

Avg_diff_err = mean(sim_res_err_ran - sim_res_err,2);
Std_diff_err = std(sim_res_err_ran - sim_res_err,0,2);


%% Plot
% alpha = 0.05;
% trials = linspace(1,N_reps)';
% standard_error_ran = std(avg_error_ran)*ones(size(trials));
% standard_error = std(avg_error)*ones(size(trials));

figure(1)
amatrix = sim_res_err_ran';
h1 = stdshade(amatrix,0.25,'-r');
title('Error of Iterative vs Random Algorithm');
xlabel('Trials','FontSize',14);
ylabel('Difference in Error','FontSize',14);
yline(0,':r','LineWidth',2);
xline(20,':b','Iterative Algorithm Begins','LineWidth',2);

hold on
amatrix = sim_res_err';
h2 = stdshade(amatrix,0.25,':g');
handlevec = [h1 h2];
legend(handlevec,'Random','Iterative');
a = findall(gcf,'Type','Line');


%Plot

figure(2)
bmatrix = sim_res_err_ran;
h3 = stdshade(bmatrix,0.25,':r');
hold on 
cmatrix = sim_res_err;
h4 = stdshade(cmatrix,0.25,'-g');
handlevec = [h3 h4];

legend(handlevec,'Random','Iterative');
title('Random vs Iterative Mapping');
ylabel('Percent Error');
xlabel('Trials');


figure(1)
plot(avg_error_ran,'k')
hold on 
plot(avg_error,'r')
title('Random vs Iterative Mapping');
ylabel('Percent Error');
xlabel('Trials');
legend('Random','Iterative');


% figure(2)
% lower = ci_ran(1,:);
% upper = ci_ran(2,:);
% x = avg_error;




