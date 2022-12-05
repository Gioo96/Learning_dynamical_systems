clear all;
close all;
load('bike.mat')

% Input & Output plotting
figure(1);
t = 1:1:size(u);
subplot(1,2,1);
plot(t, u);
title("Input data");
xlabel('time [hours]');
ylabel('count rental bikes');
subplot(1,2,2);
plot(t, y);
title("Output data");
xlabel('time [hours]');
ylabel('windspeed [Km/h]');

%% Data detrend

% Creation of an iddata object for the output and input data 
data = iddata(y,u);

% Compute the means of the data and store them in mu.InputOffset and
% mu.OutputOffset
mu = getTrend(data,0);

% Perform the data detrend
data_d = detrend(data,mu);

%% Model structures
orders_bj = [1 1 1 1 1;
             2 2 2 1 1;
             4 4 4 3 1;
             6 6 6 5 1];
         
model_bj1 = bj(data_d,orders_bj(1,:));
model_bj2 = bj(data_d,orders_bj(2,:));
model_bj3 = bj(data_d,orders_bj(3,:));
model_bj4 = bj(data_d,orders_bj(4,:));

%% Model structure determination

% Residual Analysis: Autocorrelation test & Cross-correlation test

figure(2);
subplot(2,2,1);
resid(model_bj1, data_d, 'corr');
title('Model 1');
subplot(2,2,2);
resid(model_bj2, data_d, 'corr');
title('Model 2');
subplot(2,2,3);
resid(model_bj3, data_d, 'corr');
title('Model 3');
subplot(2,2,4);
resid(model_bj4, data_d, 'corr');
title('Model 4');

% Zero-Pole cancellation analysis

figure(3);
subplot(2,2,1);
iopzplot(model_bj1);
title('Model 1');
subplot(2,2,2);
iopzplot(model_bj2);
title('Model 2');
subplot(2,2,3);
iopzplot(model_bj3);
title('Model 3');
subplot(2,2,4);
iopzplot(model_bj4);
title('Model 4');

% Criteria with complexity terms 
% SURE
Jsure1 = sure(model_bj1);
Jsure2 = sure(model_bj2);
Jsure3 = sure(model_bj3);
Jsure4 = sure(model_bj4);
fprintf("SURE: \n Jsure1 = " + Jsure1 + "\n Jsure2 = " + Jsure2 + " \n Jsure3 = " + Jsure3 + "\n Jsure4 = " + Jsure4 + "\n \n");

% AIC
Jaic1 = aic(model_bj1);
Jaic2 = aic(model_bj2);
Jaic3 = aic(model_bj3);
Jaic4 = aic(model_bj4);
fprintf("AIC: \n Jaic1 = " + Jaic1 + "\n Jaic2 = " + Jaic2 + " \n Jaic3 = " + Jaic3 + "\n Jaic4 = " + Jaic4 + "\n \n");

% BIC
Jbic1 = bic(model_bj1);
Jbic2 = bic(model_bj2);
Jbic3 = bic(model_bj3);
Jbic4 = bic(model_bj4);
fprintf("BIC: \n Jbic1 = " + Jbic1 + "\n Jbic2 = " + Jbic2 + " \n Jbic3 = " + Jbic3 + "\n Jbic4 = " + Jbic4 + "\n \n");
%%
% Hold-out cross validation
% Training dataset
u_t = data_d.u(1:round(size(u)/2));
y_t = data_d.y(1:round(size(y)/2));

% Validation dataset
u_v = data_d.u(size(u_t)+1:size(u));
y_v = data_d.y(size(y_t)+1:size(y));

data_t = iddata(y_t,u_t);
data_v = iddata(y_v,u_v);

% Training 
model_cv1 = bj(data_t,orders_bj(1,:));
model_cv2 = bj(data_t,orders_bj(2,:));
model_cv3 = bj(data_t,orders_bj(3,:));
model_cv4 = bj(data_t,orders_bj(4,:));

% Validation
k = 1; 
opt = compareOptions('InitialCondition','z');
figure(4);
subplot(2,2,1);
compare(data_v, model_cv1, k, opt);
subplot(2,2,2);
compare(data_v, model_cv2, k, opt);
subplot(2,2,3);
compare(data_v, model_cv3, k, opt);
subplot(2,2,4);
compare(data_v, model_cv4, k, opt);