%Define the parameters of the active-learning algorithm to be tested, e.g., 
par = struct('Ntrials',100,'n_init_trials',50, 'n_candidates',1000, 'n_samps',100,'n_burn_in',20);
%Define N_reps
N_reps = 100;

%Define the simulated listeners, including G0 and sigma0 for each of the repetitions
G0 = rand(6,N_reps)*30;  %Defining Ground Truth 30dB range, new listener reach rep
sigma0 = 15;

r = 0.8; % correlation coefficient, i.e 1 = same number
Sigma0 = diag(sigma0^2*ones(1,6)); % This is the variance for each of the 6 bands
Sigma0(1,6) = r*sigma0^2; % This will add the coviarance between the 1st and 6th band
Sigma0(6,1) = r*sigma0^2;

%Define the data matrix, e.g., 
gt_matrix = zeros(par.Ntrials,6);  
% 100 trials per run, one run per algorithm

parfor irep = 1:N_reps
    gain_tmp = zeros(par.Ntrials,6);
    gain_tmp = simulation_rand(par,G0(:,irep),Sigma0);
    gt_matrix(:,:,irep) = gain_tmp;
end

average_gt = mean(gt_matrix,1);
C = permute(average_gt,[1 3 2]);
C = reshape(C,[],size(average_gt,2),1);
plotmatrix(C)


