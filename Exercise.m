v1 = randn(6,1); 
v1 = v1/sqrt(sum(v1.^2)); 

v2 = randn(6,1); 
v2 = v1/sqrt(sum(v2.^2)); 

X = M'*G;


M = [v1, v2];
G = M.^-1 * X;

