%Define the parameters of the active-learning algorithm to be tested, e.g., 
par = struct('Ntrials',300,'n_init_trials',25, 'n_candidates',200, 'n_samps',100,'n_burn_in',15);
%Define N_reps
N_reps = 50;

%Define the simulated listeners, including G0 and sigma0 for each of the repetitions
G0 = rand(6,N_reps)*30;  %Defining Ground Truth 30dB range, new listener reach rep
sigma0 = 15;

r = 0.8; % correlation coefficient, i.e 1 = same number
Sigma0 = diag(sigma0^2*ones(1,6)); % This is the variance for each of the 6 bands
Sigma0(1,6) = r*sigma0^2; % This will add the coviarance between the 1st and 6th band
Sigma0(6,1) = r*sigma0^2;

%Define the data matrix, e.g., 
error_matrix = zeros(par.Ntrials,3,N_reps);  
% 100 trials per run, one run per algorithm


parfor irep = 1:N_reps
    
    err_tmp = zeros(par.Ntrials,3);
    err_tmp(:,1) = calc_error(simulation_rand(par,G0(:,irep),Sigma0),G0(:,irep),par);
    err_tmp(:,2) = calc_error(simulation_bb(par,G0(:,irep),Sigma0),G0(:,irep),par);
    err_tmp(:,3) = calc_error(simulation_active(par,G0(:,irep),Sigma0),G0(:,irep),par);% note that I pass the parameters into the function here.
    error_matrix(:,:,irep) = err_tmp;
    
end

%Calculate the descriptive statistics of the errors
%Plot the results

rand_err = squeeze(error_matrix(:,1,:));
band_err = squeeze(error_matrix(:,2,:));
active_err = squeeze(error_matrix(:,3,:));

figure
amatrix = rand_err;
h1 = stdshade(amatrix',0.25,'-r');
xlabel('Trials','FontSize',14);
ylabel('Error From Ground Truth(dB)','FontSize',14);

hold on
amatrix2 = band_err;
h2 = stdshade(amatrix2',0.25,':g');

hold on 
amatrix3 = active_err;
h3 = stdshade(amatrix3',0.25,'-.b');


handlevec = [h1 h2 h3];
legend(handlevec,'Random','Band by Band','Iterative');
a = findall(gcf,'Type','Line');

std_rand = mean(std(rand_err));
std_band = mean(std(band_err));
std_active = mean(std(active_err));
