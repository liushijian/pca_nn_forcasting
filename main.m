function [ ] = ffn( n )
%FFN Summary of this function goes here
%   Detailed explanation goes here
load test
load train
[x_train,ps1] = mapminmax(x_train);
%[x_min, x_d] = nom(x_train);
%x_train = (x_train - repmat(x_min,1,size(x_train,2)))./repmat(x_d,1,size(x_train,2));
%[COEFF, SCORE, LATENT] = pca(x_train');
%x_train = [(x_train')*COEFF(:,1) (x_train')*COEFF(:,2) (x_train')*COEFF(:,3)]';

[t_train,ps2] = mapminmax(t_train);
%[t_min, t_d] = nom(t_train);
%t_train = (t_train - repmat(t_min,1,size(t_train,2)))./repmat(t_d,1,size(t_train,2));

x_test = mapminmax('apply',x_test,ps1);
%x_test = (x_test - repmat(x_min,1,size(x_test,2)))./repmat(x_d,1,size(x_test,2));
%x_test = [(x_test')*COEFF(:,1) (x_test')*COEFF(:,2) (x_test')*COEFF(:,3)]';

%t_test = mapminmax('apply',t_test,ps2);
%t_test = (t_test - repmat(t_min,1,size(t_test,2)))./repmat(t_d,1,size(t_test,2));

net = feedforwardnet(n); % hidden layer size = n and Levenberg-Marquardt algorithm
net = train(net,x_train,t_train);
%view(net)
%y1 = net(x_test);
y2 = net(x_train);

y2 = mapminmax('reverse',y2,ps2);
t_train = mapminmax('reverse',t_train,ps2);
%y2 = y2.*repmat(t_d,1,size(t_test,2)) + repmat(t_min,1,size(t_test,2));
%perf = mse(net,t_test,y1)
perf1 = mse(net,t_train,y2)
perf2 = mae(net,t_train,y2)
perf3 = mean(abs(t_train - y2)./t_train) * 100
%num = 1:size(t_test,2);
%plot(num,t_test,'-b',num,y1,'-r')
end

