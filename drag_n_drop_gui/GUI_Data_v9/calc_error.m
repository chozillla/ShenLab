function D_error =  calc_error(D,G0,par)
[N_trials,~] = size(D);
N_burn_in = par.n_burn_in;
D_error = zeros(N_trials,1);

for itrial = 1:N_trials
    
    if itrial > N_burn_in
        D_error(itrial) = rms(mean(D(N_burn_in + 1:itrial,:)) - G0'); %Approaches standard error of the mean
    end
    
end
end