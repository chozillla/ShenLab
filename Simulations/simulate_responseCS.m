function X = simulate_responseCS(a, Glast, Mu, Sigma, N)

if nargin < 5
    N = 1;
end
% a is a 6-by-1 vector indicating the orientation of x2

Ndims = length(Mu);
A = [ones(Ndims,1), a];    % 6 by 2 matrix that maps x to g
%Mu2 = (A'*A)\A'*(Mu-Glast);
Mu2 = (A'+A)*(Mu-Glast);
Sigma2 = inv(A'/Sigma*A); %

X = mvnrnd(Mu2, Sigma2);
    
    
end
