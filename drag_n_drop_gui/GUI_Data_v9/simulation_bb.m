function sim_res_err = simulation_bb(par,G0,Sigma0)
%n_init_trials must be an integer >= 6

% G0 = rand(6,1)*30;  %Defining Ground Truth 30dB range
% sigma0 = 0;

% Sigma0 = diag(sigma0^2*ones(1,6));
% Sigma0(1,6) = sigma0^2;
% Sigma0(6,1) = sigma0^2;



Glast = zeros(6,1);
D = zeros(par.Ntrials,6); % all estimated gain from the procedure, with each row corresponding to a trial
a = zeros(6,par.Ntrials);

for itrial = 1:par.Ntrials
    
    %Band by Band
    
    w = mod(itrial,6);
    
    if w == 0
        w = 6;
    end
    
    
    a(w,itrial) = 1;
    %R = simulate_responseYS(a(:,itrial),Glast,G0,Sigma0);
    %G = @(x2) Glast + a(:,itrial) * x2;
    %Glast = G(R(2)); % Needs to be a 6x1
    x2 = a(:,itrial)'*(G0-Glast) + randn*sqrt(Sigma0(w,w));
    Glast = Glast + x2*a(:,itrial);
    D(itrial,:) = Glast;
    
     
end
% figure
% plotmatrix(D)





%         figure(1)
%         plot(G0);
%         hold on
%         plot(Glast,'r');
%         hold off
%         drawnow;


% figure(3)
sim_res_err = D; %Approaches the standard deviation




% Factor sqrt(Ntrials) between sim_res_err and D_error

% semilogx(rms(ones(Ntrials,1)*G0-D, 2));


%                 % present stimuli continuous to the listener until a pair of x1 and x2 are identified as “preferred”
%                 while not yet stopped by the user
%                     G = G_last + x1 + a*x2;
%                                 Send the gain table G to the audio playback device
%                 end
%                 G_last = G;
%                 D(itrial,:) = G;
%