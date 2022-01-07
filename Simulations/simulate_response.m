function X = simulate_response(a, xlim, Glast, Mu,Sigma)

% a is a 1-by-6 vector indicating the orientation of x2
% xlim = [x1_min, x1_max; x2_min, x2_max]

Ndims = length(Mu);
Nsmps = 1000;

stopflag = 0;
while stopflag == 0
    X = [rand(Nsmps, 1)*(xlim(1,2)-xlim(1,1))+xlim(1,1), rand(Nsmps, 1)*(xlim(2,2)-xlim(2,1))+xlim(2,1)];
    G = ones(Nsmps,1)*Glast + X(:,1)*ones(1,Ndims) + X(:,2)*a;
    p = mvnpdf(G,Mu,Sigma); %diag(sigma0^2*ones(1, Ndims))
    Y = rand(Nsmps,1)*max(p);
    idx = find(Y<p,1);
    if ~isempty(idx)
        stopflag =1;
    end
end

X = X(idx,:);

end
