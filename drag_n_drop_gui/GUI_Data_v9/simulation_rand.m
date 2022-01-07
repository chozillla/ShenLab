function sim_res_err = simulation_rand(par,G0,Sigma0)
%n_init_trials must be an integer >= 6

% G0 = rand(6,1)*30;  %Defining Ground Truth 30dB range
% sigma0 = 0;

% Sigma0 = diag(sigma0^2*ones(1,6));
% Sigma0(1,6) = 0.8*sigma0^2;
% Sigma0(6,1) = 0.8*sigma0^2;



Glast = zeros(6,1);
D = zeros(par.Ntrials,6); % all estimated gain from the procedure, with each row corresponding to a trial


for itrial = 1:par.Ntrials
    %Random
    
    a = randn(6,1);
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
% figure
% plotmatrix(D)
% title('Rand')


% figure(3)
sim_res_err = D;
% semilogx(rms(ones(Ntrials,1)*G0-D, 2));


%                 % present stimuli continuous to the listener until a pair of x1 and x2 are identified as “preferred”
%                 while not yet stopped by the user
%                     G = G_last + x1 + a*x2;
%                                 Send the gain table G to the audio playback device
%                 end
%                 G_last = G;
%                 D(itrial,:) = G;
%