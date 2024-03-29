clear all;

m(:,1) = [-1;0]; Sigma(:,:,1) = 0.1*[10 -4;-4,5]; % mean and covariance of data pdf conditioned on label 1
m(:,2) = [1;0]; Sigma(:,:,2) = 0.1*[5 0;0,2]; % mean and covariance of data pdf conditioned on label 2
m(:,3) = [0;1]; Sigma(:,:,3) = 0.1*eye(2); % mean and covariance of data pdf conditioned on label 3
classPriors = [0.15,0.35,0.5]; thr = [0,cumsum(classPriors)];
N = 10000; u = rand(1,N); L = zeros(1,N); x = zeros(2,N);
figure(1),clf, colorList = 'rbg';

for l = 1:3
    
    indices = find(thr(l)<=u & u<thr(l+1)); % if u happens to be precisely 1, that sample will get omitted - needs to be fixed
    L(1,indices) = l*ones(1,length(indices));
    x(:,indices) = mvnrnd(m(:,l),Sigma(:,:,l),length(indices))';
   
    %figure(1), plot(x(1,indices),x(2,indices),'.','MarkerFaceColor',colorList(l)); axis equal, hold on,
    
    % store the actual value for each 3 classes
    switch l
        case 1
            actual_number_c1 = [x(1,indices);x(2,indices)];
        case 2
            actual_number_c2 = [x(1,indices);x(2,indices)];
        case 3
            actual_number_c3 = [x(1,indices);x(2,indices)];
    end
end

% Show from the actual_number
figure(1), plot(actual_number_c1(1,:),actual_number_c1(2,:),'.','MarkerFaceColor',colorList(1)); axis equal, hold on
figure(1), plot(actual_number_c2(1,:),actual_number_c2(2,:),'.','MarkerFaceColor',colorList(2)); axis equal, hold on
figure(1), plot(actual_number_c3(1,:),actual_number_c3(2,:),'.','MarkerFaceColor',colorList(3)); axis equal, hold on

% Let r = decision class, c = ture class and store in the confusion_matrix

% Nc count for each class decision
Nc = [length(find(L==1)),length(find(L==2)),length(find(L==3))];
discriminantScore = [evalGaussian(x,m(:,1),Sigma(:,:,1));evalGaussian(x,m(:,2),Sigma(:,:,2));evalGaussian(x,m(:,3),Sigma(:,:,3))]';

% By chooing the max discriminant set to make the decision in class 1,2,3
for i = 1:10000
    [val,loc] = max(discriminantScore(i,:));
    decision(i) = loc;
end

confusion_matrix = zeros(3,3);
% Confusion_matrix r as row c as column
% That the row is the actual class column is the decision class
confusion_matrix(1,1) = length(find(decision==1&L==1));
confusion_matrix(1,2) = length(find(decision==2&L==1));
confusion_matrix(1,3) = length(find(decision==3&L==1));
confusion_matrix(2,1) = length(find(decision==1&L==2));
confusion_matrix(2,2) = length(find(decision==2&L==2));
confusion_matrix(2,3) = length(find(decision==3&L==2));
confusion_matrix(3,1) = length(find(decision==1&L==3));
confusion_matrix(3,2) = length(find(decision==2&L==3));
confusion_matrix(3,3) = length(find(decision==3&L==3));

total_number_hit = confusion_matrix(1,1) + confusion_matrix(2,2) + confusion_matrix(3,3);
total_number_miss = N - total_number_hit;

error = (total_number_miss/N*100);

figure(2),
plot(x(1,find(decision==1&L==1)),x(2,find(decision==1&L==1)),'og'); hold on,
plot(x(1,find(decision==2&L==2)),x(2,find(decision==2&L==2)),'xg'); hold on,
plot(x(1,find(decision==3&L==3)),x(2,find(decision==3&L==3)),'+g'); hold on,

plot(x(1,find(decision==1&L==2)),x(2,find(decision==1&L==2)),'xr'); hold on,
plot(x(1,find(decision==1&L==3)),x(2,find(decision==1&L==3)),'+r'); hold on,
plot(x(1,find(decision==2&L==1)),x(2,find(decision==2&L==1)),'or'); hold on,
plot(x(1,find(decision==2&L==3)),x(2,find(decision==2&L==3)),'+r'); hold on,
plot(x(1,find(decision==3&L==1)),x(2,find(decision==3&L==1)),'or'); hold on,
plot(x(1,find(decision==3&L==2)),x(2,find(decision==3&L==2)),'xr'); hold on,


legend('Correct decision of class 1','Correct decision of class 2','Correct decision of class 3','Incorrect choosing 1 of actual 2','Incorrect choosing 1 of actual 3','Incorrect choosing 2 of actual 1','Incorrect choosing 2 of actual 3','Incorrect choosing 3 of actual 1','Incorrect choosing 3 of actual 2');


function g = evalGaussian(x,mu,Sigma)
% Evaluates the Gaussian pdf N(mu,Sigma) at each coumn of X
[n,N] = size(x);
C = ((2*pi)^n * det(Sigma))^(-1/2);
E = -0.5*sum((x-repmat(mu,1,N)).*(inv(Sigma)*(x-repmat(mu,1,N))),1);
g = C*exp(E);
end

