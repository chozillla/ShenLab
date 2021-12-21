function dy = myfunction(t, y)
% Function y'' = -sin(theta) - gamma(theta)'
% Rewrite this equation by making the substitution
% y = y(1) and y' = y(2)
% y(2)' = 0.5*(-3*y(2)-y(1)+1-t)

dy1 = y(2);
dy2 = 0.5 * (-3 * y(2) - y(1) + 1 - t);
dy = [dy1; dy2];
end