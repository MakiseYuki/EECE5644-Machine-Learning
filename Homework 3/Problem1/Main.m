clear all;
close all;

[label_10,data_10] = generateTrueGMM(10); %might cause to error that not enough data from chooseing the label
[label_100,data_100] = generateTrueGMM(100);
[label_1000,data_1000] = generateTrueGMM(1000);
[label_10000,data_10000] = generateTrueGMM(10000);

figure(1),
subplot(2,2,1)
plot(data_10(1,:),data_10(2,:),'g.');
title('True data of 10 samples');
axis equal,
subplot(2,2,2)
plot(data_100(1,:),data_100(2,:),'b.');
title('True data of 100 samples');
axis equal,
subplot(2,2,3)
plot(data_1000(1,:),data_1000(2,:),'r.');
title('True data of 1000 samples');
axis equal,
subplot(2,2,4)
plot(data_10000(1,:),data_10000(2,:),'k.');
title('True data of 10000 samples');
axis equal,

K = 10;
meanSquared_error = zeros(2,6,3);
for s = 1:3

if s == 1
selected_data = data_100;
selected_label = label_100;
elseif s == 2
selected_data = data_1000;
selected_label = label_1000;
elseif s == 3
selected_data = data_10000;
selected_label = label_10000;
end

for componentGauss = 1:6
%     selected_data = data_1000; % adjust the sample from the resource
%     selected_label = label_1000;
   
   
    meanSquared_error_train = 0;
    meanSquared_error_validation = 0;
    N = size(selected_data,2); 
    
    Seperation = ceil(linspace(0,N,K+1));
    fold_initial_terminal = zeros(K,2);
    for k = 1:K
        fold_initial_terminal(k,:) = [Seperation(k)+1,Seperation(k+1)]; % create indice for each blod of folded data
    end
    
    for k = 1:10
        [trainedData,trainedLabel,dataValidation,labelValidation] = KFoldCrossValidation(fold_initial_terminal,K,k,selected_data,selected_label);
        [Mu_estim,Sigma_estim,Alpha_estim,bad_choise] = my_EMforGMM(componentGauss,trainedData);
        label_trian_estim = GetLabel(Alpha_estim,Mu_estim,Sigma_estim,trainedData,componentGauss);
        label_validation_estim = GetLabel(Alpha_estim,Mu_estim,Sigma_estim,dataValidation,componentGauss);
        
        meanSquared_error_train = meanSquared_error_train + calculateMSE(trainedLabel,label_trian_estim);
        meanSquared_error_validation = meanSquared_error_train + calculateMSE(labelValidation,label_validation_estim);
    end
    meanSquared_error(:,componentGauss,s)=[meanSquared_error_train./10;meanSquared_error_validation./10];
end
 
end

for s = 1:3
    
if s == 1
    str = "100";
elseif s == 2
    str = "1000";
elseif s == 3
    str = "10000";
end
    
figure(2), subplot(2,2,s)
semilogy(meanSquared_error(1,:,s),'r+'); hold on; semilogy(meanSquared_error(2,:,s),'b*'); hold on;
xlabel('Number of Gaussian Component'); ylabel(strcat('Mean Squared Error estimate with ',num2str(K),'-fold cross-validation'));
title("With" + str + " samples")
legend('Training Mean Squared Error','Validation Mean Squared Error');
end



% As 10 sample is not enough for the 10 fold estimation when order > 2, it
% is not avaiable for the estimation for the GMM, might only avaiable for
% order 1
% 
% for i = 1:6
%     [Mu_estim,Sigma_estim,Alpha_estim,bad_choise] = my_EMforGMM(i,data_10);
% end



