function a = a_value(D)

n_trial_int = 10; % Number of trials with randomly drawn "a" before active learning

n_candidates = 100; % Number of candidates for "a" from which the selection is made before each trial 
n_samps = 100; % Number of simulated responses per candidate "a" 
itrial = size(D,1); % Number of trials that have been completed 
-SUbj
if itrial < n_trial_int
    a = randn(6,1);
else
        
     Glast = D(end,:)';
     a_candidate = randn(6,n_candidates);
     Mu = mean(D)';            %mean (6 by 1)
     Sigma = cov(D);           %covariance matrix (6 by 6)

     Ent = zeros(1,n_candidates);                       % expected entropy
 
         % draw 100 candidates a and then select one from the candidates

         for icandidate = 1:n_candidates        % for each a_candidate
                                                %Generate n_samps simulated responses for the candidate a
                                                % the resulting sim_res has a size of n_samps by 2, with x1 and x2 in the two columns
                                                
                Ent_tmp = zeros(1,n_samps);
                sim_res = simulate_responseYS(a_candidate(:,icandidate), Glast, Mu, Sigma,n_samps); 
                
                for ires = 1:n_samps
                         
                         % estimate a gaussian distribution from the previously collected data points
                         G_tmp = Glast + sim_res(ires,1)+ a_candidate(:,icandidate)*sim_res(ires,2);
                         Sigma_tmp = cov([D; G_tmp']);        % re-estimate the covariance matrix
                         % estimate the simulated entropy
                         Ent_tmp(ires) = log(det(Sigma_tmp)); % Entropy, proportional to the natural log of the determinant of the covariance matrix
                end
                Ent(icandidate) = mean(Ent_tmp);            % estimate the expected entropy based on the sample of n_samps responses
         end 
         [~, idx_min_entropy] = min(Ent);               % identify the candidate a with the lowest expected entropy
         a = a_candidate(:,idx_min_entropy);
end
    


end 






