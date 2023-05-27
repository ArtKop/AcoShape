function [net,E] = train_NN(layers,inputs,targets)
% set up the number of hidden layers and the NN 
net = fitnet(layers);

% set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 1;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;

% disable the pop-up NN window
net.trainParam.showWindow = 0;

% train the NN
[net,~] = train(net,inputs,targets);

% compute the MSE
outputs = net(inputs);
% E = mean((outputs-targets).^2);

E = sum((outputs-targets).^2);

end