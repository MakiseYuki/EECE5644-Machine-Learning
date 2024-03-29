
close all; clearvars -except trainData trueLabel

n = 3; Nsample = 100; Ntest = 10000; 
alpha = [0.15,0.35,0.2,0.3]; % must add to 1.0
meanVectors = [5 -5 -5 5;5 5 -5 -5;5 5 5 5];
covEvalues = [1.3^2 0 0;0 1.2^2 0;0 0 1.4^2];
covEvectors(:,:,1) =  0.8*[5 1 2;1 5 0;2 0 3]/sqrt(2);
covEvectors(:,:,2) =  0.8*[5 1 2;1 5 0;2 0 3]/sqrt(2);
covEvectors(:,:,3) =  0.8*[5 1 2;1 5 0;2 0 3]/sqrt(2);
covEvectors(:,:,4) =  0.8*[5 1 2;1 5 0;2 0 3]/sqrt(2);

t = rand(1,Nsample);
ind1 = find(0 <= t & t <= alpha(1));
ind2 = find(alpha(1) < t & t <= alpha(1)+alpha(2));
ind3 = find(alpha(1)+alpha(2) < t & t <= alpha(1)+alpha(2)+alpha(3));
ind4 = find(alpha(1)+alpha(2)+alpha(3) < t & t <= 1);
xSample = zeros(n,Nsample);
xSample(:,ind1) = covEvectors(:,:,1)*covEvalues^(1/2)*randn(n,length(ind1))+ meanVectors(:,1);
xSample(:,ind2) = covEvectors(:,:,2)*covEvalues^(1/2)*randn(n,length(ind2))+ meanVectors(:,2);
xSample(:,ind3) = covEvectors(:,:,3)*covEvalues^(1/2)*randn(n,length(ind3))+ meanVectors(:,3);
xSample(:,ind4) = covEvectors(:,:,4)*covEvalues^(1/2)*randn(n,length(ind4))+ meanVectors(:,4);

trueLabel = zeros(1,Nsample);
trueLabel(:,ind1) = 1;
trueLabel(:,ind2) = 2;
trueLabel(:,ind3) = 3;
trueLabel(:,ind4) = 4;


inputs = xSample;
outputs = trueLabel;

net = network(1,2,[1;0],[1;0],[0,0;1,0],[0 1]);
net.layers{1}.size = 5;

net.layers{1}.transferFcn = 'logsig';

net = configure(net,inputs,outputs);
initial_output = net(inputs);

net.trainFcn = 'trainlm';
net = train(net,inputs,outputs);
final_output = net(inputs);

% delta = 1e-5; % tolerance for EM stopping criterion
% regWeight = 1e-10; % regularization parameter for covariance estimates
% 
% N = 100;
% [d,M] = size(meanVectors); % determine dimensionality of samples and number of GMM components
% 
% % Initialize the GMM to randomly selected samples
% alpha = ones(1,M)/M;
% shuffledIndices = randperm(N);
% mu = xSample(:,shuffledIndices(1:M)); % pick M random samples as initial mean estimates
% [~,assignedCentroidLabels] = min(pdist2(mu',xSample'),[],1); % assign each sample to the nearest mean
% for m = 1:M % use sample covariances of initial assignments as initial covariance estimates
%     covEvectors(:,:,m) = cov(xSample(:,find(assignedCentroidLabels==m))') + regWeight*eye(d,d);
% end
% t = 0; %displayProgress(t,x,alpha,mu,Sigma);
% 
% Converged = 0; % Not converged at the beginning
% while ~Converged
%     for l = 1:M
%         temp(l,:) = repmat(alpha(l),1,N).*evalGaussian(xSample,mu(:,l),covEvectors(:,:,l));
%     end
%     plgivenx = temp./sum(temp,1);
%     alphaNew = mean(plgivenx,2);
%     w = plgivenx./repmat(sum(plgivenx,2),1,N);
%     muNew = xSample*w';
%     for l = 1:M
%         v = xSample-repmat(muNew(:,l),1,N);
%         u = repmat(w(l,:),d,1).*v;
%         SigmaNew(:,:,l) = u*v' + regWeight*eye(d,d); % adding a small regularization term
%     end
%     Dalpha = sum(abs(alphaNew-alpha'));
%     Dmu = sum(sum(abs(muNew-mu)));
%     DSigma = sum(sum(abs(abs(SigmaNew-covEvectors))));
%     Converged = ((Dalpha+Dmu+DSigma)<delta); % Check if converged
%     alpha = alphaNew; mu = muNew; covEvectors = SigmaNew;
%     t = t+1; 
%     %displayProgress(t,x,alpha,mu,Sigma);
% end