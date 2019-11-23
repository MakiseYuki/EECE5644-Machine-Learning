clear all, close all,

plotData = 1;
n = 3; Ntrain = 1000; Ntest = 10000; 
alpha = [0.1,0.2,0.3,0.4]; % must add to 1.0
meanVectors = [-18 0 18 36;-8 0 8 16;-6 0 6 12];
covEvalues = [3.2^2 0 0;0 1.2^2 0;0 0 0.6^2];
covEvectors(:,:,1) = [1 0 -1;-1 0 1;1 0 1]/sqrt(2);
covEvectors(:,:,2) = [1 0 0;0 1 0;0 0 1];
covEvectors(:,:,3) = [1 0 -1;-1 0 1;1 0 1]/sqrt(2);
covEvectors(:,:,4) = [1 0 0;0 1 0;0 0 1];

t = rand(1,Ntrain);
ind1 = find(0 <= t & t <= alpha(1));
ind2 = find(alpha(1) < t & t <= alpha(1)+alpha(2));
ind3 = find(alpha(1)+alpha(2) < t & t <= alpha(1)+alpha(2)+alpha(3));
ind4 = find(alpha(1)+alpha(2)+alpha(3) < t & t <= 1);
Xtrain = zeros(n,Ntrain);
Xtrain(:,ind1) = covEvectors(:,:,1)*covEvalues^(1/2)*randn(n,length(ind1))+meanVectors(:,1);
Xtrain(:,ind2) = covEvectors(:,:,2)*covEvalues^(1/2)*randn(n,length(ind2))+meanVectors(:,2);
Xtrain(:,ind3) = covEvectors(:,:,3)*covEvalues^(1/2)*randn(n,length(ind3))+meanVectors(:,3);
Xtrain(:,ind4) = covEvectors(:,:,4)*covEvalues^(1/2)*randn(n,length(ind4))+meanVectors(:,4);

t = rand(1,Ntest);
ind1 = find(0 <= t & t <= alpha(1));
ind2 = find(alpha(1) < t & t <= alpha(1)+alpha(2));
ind3 = find(alpha(1)+alpha(2) < t & t <= alpha(1)+alpha(2)+alpha(3));
ind4 = find(alpha(1)+alpha(2)+alpha(3) < t & t <= 1);
Xtest = zeros(n,Ntrain);
Xtest(:,ind1) = covEvectors(:,:,1)*covEvalues^(1/2)*randn(n,length(ind1))+meanVectors(:,1);
Xtest(:,ind2) = covEvectors(:,:,2)*covEvalues^(1/2)*randn(n,length(ind2))+meanVectors(:,2);
Xtest(:,ind3) = covEvectors(:,:,3)*covEvalues^(1/2)*randn(n,length(ind3))+meanVectors(:,3);
Xtest(:,ind4) = covEvectors(:,:,4)*covEvalues^(1/2)*randn(n,length(ind4))+meanVectors(:,4);

trueLabel = zeros(1,Ntest);
trueLabel(:,ind1) = 1;
trueLabel(:,ind2) = 2;
trueLabel(:,ind3) = 3;
trueLabel(:,ind4) = 4;

% if plotData == 1
%     figure(1), subplot(1,2,1),
%     plot(Xtrain(1,:),Xtrain(2,:),'.')
%     title('Training Data'), axis equal,
%     subplot(1,2,2),
%     plot(Xtest(1,:),Xtest(2,:),'.')
%     title('Testing Data'), axis equal,
% end