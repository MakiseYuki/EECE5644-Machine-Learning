% clear all, close all,
% 
plotData = 1;
% n = 2; Ntrain = 1000; Ntest = 10000; K = 10;
% alpha = [0.33,0.34,0.33]; % must add to 1.0
% meanVectors = [-18 0 18;-8 0 8];
% covEvalues = [3.2^2 0;0 0.6^2];
% covEvectors(:,:,1) = [1 -1;1 1]/sqrt(2);
% covEvectors(:,:,2) = [1 0;0 1];
% covEvectors(:,:,3) = [1 -1;1 1]/sqrt(2);
% 
% t = rand(1,Ntrain);
% ind1 = find(0 <= t & t <= alpha(1));
% ind2 = find(alpha(1) < t & t <= alpha(1)+alpha(2));
% ind3 = find(alpha(1)+alpha(2) <= t & t <= 1);
% Xtrain = zeros(n,Ntrain);
% Xtrain(:,ind1) = covEvectors(:,:,1)*covEvalues^(1/2)*randn(n,length(ind1))+meanVectors(:,1);
% Xtrain(:,ind2) = covEvectors(:,:,2)*covEvalues^(1/2)*randn(n,length(ind2))+meanVectors(:,2);
% Xtrain(:,ind3) = covEvectors(:,:,3)*covEvalues^(1/2)*randn(n,length(ind3))+meanVectors(:,3);
% 
% Xlabel = zeros(1,Ntrain);
% Xlabel(:,ind1) = 1;
% Xlabel(:,ind2) = 2;
% Xlabel(:,ind3) = 3;
% 
% t = rand(1,Ntest);
% ind1 = find(0 <= t & t <= alpha(1));
% ind2 = find(alpha(1) < t & t <= alpha(1)+alpha(2));
% ind3 = find(alpha(1)+alpha(2) <= t & t <= 1);
% Xtest = zeros(n,Ntrain);
% Xtest(:,ind1) = covEvectors(:,:,1)*covEvalues^(1/2)*randn(n,length(ind1))+meanVectors(:,1);
% Xtest(:,ind2) = covEvectors(:,:,2)*covEvalues^(1/2)*randn(n,length(ind2))+meanVectors(:,2);
% Xtest(:,ind3) = covEvectors(:,:,3)*covEvalues^(1/2)*randn(n,length(ind3))+meanVectors(:,3);
% 
% save('DataSets.mat','Xtrain','Xtest');

% dummy = ceil(linspace(0,Ntrain,K+1));
% for k = 1:K
%     indPartitionLimits(k,:) = [dummy(k)+1,dummy(k+1)]; 
% end
% 
% for k = 1:K
%     
%         indValidate = [indPartitionLimits(k,1):indPartitionLimits(k,2)];
%         xValidate = Xtrain(:,indValidate); % Using folk k as validation set
%         lValidate = Xlabel(indValidate);
%         if k == 1
%             indTrain = [indPartitionLimits(k,2)+1:Ntrain];
%         elseif k == K
%             indTrain = [1:indPartitionLimits(k,1)-1];
%         else
%             indTrain = cat(2,[1:indPartitionLimits(k,1)-1],[indPartitionLimits(k,2)+1:Ntrain]);
%         end
%         % using all other folds as training set
%         sep_Xtrain = Xtrain(1,indTrain); sep_Ttrain = Xtrain(2,indTrain);
%         
%         % create the network with 1 layer
%         net = feedforwardnet(10);
%         net.performParam.regularization = 0.01;
%         net.performFcn = 'mse';
%         net.layers{1}.transferFcn = 'logsig';
%         trainedNet = train(net, sep_Xtrain, sep_Ttrain);
%         y = trainedNet(sep_Xtrain);
%         perf(k) = perform(trainedNet, sep_Ttrain, y);
%                    
% end 
% 
if plotData == 1
    figure(1), subplot(1,2,1),
    plot(Xtrain(1,:),Xtrain(2,:),'.')
    title('Training Data'), axis equal,
    subplot(1,2,2),
    plot(Xtest(1,:),Xtest(2,:),'.')
    title('Testing Data'), axis equal,
end

