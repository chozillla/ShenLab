function sim_res_err = simulation(n_init_trials,G0,sigma0)
%n_init_trials must be an integer >= 6

% G0 = rand(6,1)*30;  %Defining Ground Truth 30dB range 
% sigma0 = 0;

Sigma0 = diag(sigma0^2*ones(1,6));

% xlim = [-5 5; -5 5];
Ntrials = 100;
Glast = zeros(6,1);         % initial gain "G0"
D = zeros(Ntrials,6);  % all estimated gain from the procedure, with each row corresponding to a trial
n_candidates = 100;
n_samps = 100;


for itrial = 1:Ntrials
 
      % divide the procedure into the Initiation part and the Active-Learning part
      if itrial <= n_init_trials              %Turn this into a parameter like a switch 
        a = randn(6,1);
      else
        % estimate a gaussian distribution from the previously collected data points
        a_candidate = randn(6,n_candidates);
        Mu = mean(D(1:itrial-1,:))';            %mean (6 by 1)
        Sigma = cov(D(1:itrial-1,:));           %covariance matrix (6 by 6)
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
                         Sigma_tmp = cov([D(1:itrial-1,:); G_tmp']);        % re-estimate the covariance matrix
                         % estimate the simulated entropy
                         Ent_tmp(ires) = log(det(Sigma_tmp)); % Entropy, proportional to the natural log of the determinant of the covariance matrix
                end
                         Ent(icandidate) = mean(Ent_tmp);            % estimate the expected entropy based on the sample of n_samps responses
         end 
                                [~, idx_min_entropy] = min(Ent);               % identify the candidate a with the lowest expected entropy
                                a = a_candidate(:,idx_min_entropy);
      end 
            
            R = simulate_responseYS(a,Glast,G0,Sigma0);
            G = @(x1, x2) Glast + x1 + x2*a;
            Glast = G(R(1), R(2));
            D(itrial, :) = Glast;
            
%         figure(1)
%         plot(G0);
%         hold on
%         plot(Glast,'r');
%         hold off
%         drawnow;
end

% figure(3)
sim_res_err = rms(ones(Ntrials,1)*G0'-D, 2);
% semilogx(rms(ones(Ntrials,1)*G0-D, 2));

               
%                 % present stimuli continuous to the listener until a pair of x1 and x2 are identified as “preferred”
%                 while not yet stopped by the user
%                     G = G_last + x1 + a*x2;
%                                 Send the gain table G to the audio playback device
%                 end
%                 G_last = G;
%                 D(itrial,:) = G;
%  