%% K-means Segmentation (option: K Number of Segments)
% Alireza Asvadi
% http://www.a-asvadi.ir
% 2012
% Questions regarding the code may be directed to alireza.asvadi@gmail.com
%% initialize
clc
clear all
close all
%% Load Image
I = im2double(imread('EECE5644_2019Fall_Homework4Questions_42049_colorBird.jpg'));                    % Load Image
F = reshape(I,size(I,1)*size(I,2),3);                 % Color Features
%% K-means
K     = 5;                                            % Cluster Numbers
CENTS = F( ceil(rand(K,1)*size(F,1)) ,:);             % Cluster Centers
DAL   = zeros(size(F,1),K+2);                         % Distances and Labels
KMI   = 10;                                           % K-means Iteration
for n = 1:KMI
   for i = 1:size(F,1)
      for j = 1:K  
        DAL(i,j) = norm(F(i,:) - CENTS(j,:));      
      end
      [Distance, CN] = min(DAL(i,1:K));               % 1:K are Distance from Cluster Centers 1:K 
      DAL(i,K+1) = CN;                                % K+1 is Cluster Label
      DAL(i,K+2) = Distance;                          % K+2 is Minimum Distance
   end
   for i = 1:K
      A = (DAL(:,K+1) == i);                          % Cluster K Points
      CENTS(i,:) = mean(F(A,:));                      % New Cluster Centers
      if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
         NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
end
X = zeros(size(F));
for i = 1:K
idx = find(DAL(:,K+1) == i);
X(idx,:) = repmat(CENTS(i,:),size(idx,1),1); 
end
T = reshape(X,size(I,1),size(I,2),3);
%% Show
figure()
subplot(121); imshow(I); title('original')
subplot(122); imshow(T); title('segmented')
disp('number of segments ='); disp(K)