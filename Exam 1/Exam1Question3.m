clear all;
% Create true wt
r1 = -0.25; r2 = 0.5; r3 = 0.25;
w_true = [0.5 r1+r2+r3 r1*r2+r1*r3+r2*r3 r1*r2*r3];

a = w_true(1);
b = w_true(2);
c = w_true(3);
d = w_true(4);

gamma = 1;
Sigma_v = 2;
mu = [0 0 0 0];
N = 10;
I = eye(4);
 
g_prior = mvnrnd(mu,gamma*I,1);
w = g_prior;
v = mvnrnd(0,Sigma_v,N);

x = -1 + 2*rand(N,1);
y = a*x.^3 + b*x.^2 + c*x + d + v; 
D(1,:) = x;
D(2,:) = y;

discriminantScore = evalGaussian(D(2,:),0,Sigma_v);

function g = evalGaussian(x,mu,Sigma)
% Evaluates the Gaussian pdf N(mu,Sigma) at each column of X
[n,N] = size(x);
C = ((2*pi)^n * det(Sigma))^(-1/2);
E = -0.5*sum((x-repmat(mu,1,N)).*(inv(Sigma)*(x-repmat(mu,1,N))),1);
g = C*exp(E);
end