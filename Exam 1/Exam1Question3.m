clear all;
% Create true wt
r1 = -0.25; r2 = 0.5; r3 = 0.25;
w_true = [0.5 r1+r2+r3 r1*r2+r1*r3+r2*r3 r1*r2*r3]';

a = w_true(1);
b = w_true(2);
c = w_true(3);
d = w_true(4);
Gamma_N = 50;
Gamma_map = logspace(-3,3,Gamma_N);
L = zeros(100,Gamma_N);
for s = 1:Gamma_N
    Gamma = Gamma_map(s);
    for i = 1:100

    
    Sigma_v = 2;
    mu = [0 0 0 0];
    N = 10;
    I = eye(4);

    w_prior = mvnrnd(mu,Gamma*I,1);

    v = mvnrnd(0,Sigma_v,N);

    x = -1 + 2*rand(N,1);

    xt = zeros(4,N);

    for j = 1:N
        xt(1,j) = x(j)^3;
        xt(2,j) = x(j)^2;
        xt(3,j) = x(j);
        xt(4,j) = 1;
    end

    y = xt'*w_true + v;

    D(1,:) = x;
    D(2,:) = y;

    est_w = estMAP(xt',y',Sigma_v,Gamma*I)';

    L(i,s) = norm(w_true - est_w,2)^2;

    end
end

L = sort(L,1);
figure(1),
plot(log10(Gamma_map),log10(L(1,:)),"-r"),hold on,
plot(log10(Gamma_map),log10(L(25,:)),"-g"),hold on,
plot(log10(Gamma_map),log10(L(50,:)),"-b"),hold on,
plot(log10(Gamma_map),log10(L(75,:)),"-k"),hold on,
plot(log10(Gamma_map),log10(L(100,:)),"-y"),
xlabel('Gamma'), ylabel('L2 Distance between true vector and MAP estimate vector'), 
legend("Minimum of Squared Error","25% of Squared Error","Median of Squared Error","75% of Squared Error","Maximum of Squared Error","location","Northwest");

function w = estMAP(x,y,Sigma_noise,Sigma2)
n = y*inv(Sigma_noise)*x;
d = x'*inv(Sigma_noise)*x+inv(Sigma2);
w = n*inv(d);
end