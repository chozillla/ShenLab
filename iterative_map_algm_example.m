clear
close all
clc

% parameters that characterize a simulated user
G0 = randn(1,6)*40-20;
sigma0 = 15;

ntrials = 100;
gain_tot = zeros(ntrials,6);
Glast = zeros(6,1);

for itrial = 1:ntrials
    % draw a new map from controls (x1,x2) to gains (G)
    a = randn(6,1);
    G = @(x1, x2) Glast + x1 + x2*a;
    
    % simulate a response using G0 and sigma0
    xlim = [-20 20; -20 20];
    R = simulate_response(a', xlim, Glast', G0, sigma0);
    
    Glast = G(R(1), R(2));
    gain_tot(itrial, :) = Glast;
    
    figure(1)
    plot(G0);
    hold on
    plot(Glast,'r');
    hold off
    drawnow;
end

figure(2)
plot(rms(ones(ntrials,1)*G0-gain_tot, 2));
