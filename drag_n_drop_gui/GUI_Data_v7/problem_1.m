clear all
close all
clc

% Parameters

interval = [0, 10]; % the time interval
init = [2; 0]; % initial values of y(1) and y(2)

% call ode45
[t, y] = ode45(@myfunction, interval, init); % myfunction is the functon to solve

figure(1)
plot(t, y(:, 1), '-', 'linewidth',2)
hold on
plot(t, y(:, 2), '-','linewidth',2)
xlabel('t', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
legend('y(t)', 'dy(t)/dt')
set(gca,'fontsize',12)
hold off