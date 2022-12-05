%% Loading parameters

close all;
load('manipulator.mat');

%% Data plotting

% Computation of the accelerations
u1dd = derivative2(u1d, Ts);
u2dd = derivative2(u2d, Ts);

% Input data
X1 = [u1, u1d, u1dd];
X2 = [u2, u2d, u2dd];

figure(1);
subplot(2,2,1);
plot(t,u1,'b');
hold on;
plot(t,u2,'r');
legend('u1', 'u2');

subplot(2,2,2);
plot(t,u1d,'b');
hold on;
plot(t,u2d,'r');
legend('u1d', 'u2d');

subplot(2,2,3);
plot(t,u1dd,'b');
hold on;
plot(t,u2dd,'r');
legend('u1dd', 'u2dd');

subplot(2,2,4);
plot(t,y1,'b');
hold on ;
plot(t,y2,'r');
legend('y1', 'y2');

%% CASES:
% CASE1: beta = 600, lambda = 2
% CASE2: beta = 600, lambda = 0.4
% CASE3: beta = 1, lambda = 2

% Error variance
sigma2 = 0.2;

beta = [600, 600, 1];

lambda = [2, 0.4, 2];

y1_hat = [];
y2_hat = [];
for i = 1:3
    y1_hat = g_hat(sigma2, lambda(i), beta(i), X1, y1, X1);
    y2_hat = g_hat(sigma2, lambda(i), beta(i), X1, y1, X2);
    
    figure(i+1);
    sgtitle("CASE " + i + ": \beta = " + beta(i) + ", \lambda = " + lambda(i));
    subplot(1,2,1);
    plot(t, y1, 'b');
    hold on;
    plot(t, y1_hat, 'r');
    legend('$\bf{y_1}$', '$\bf{\hat{g}_{ML}(X_1)}$', 'interpreter','latex');

    subplot(1,2,2);
    plot(t, y2, 'b');
    hold on;
    plot(t, y2_hat, 'r');
    legend('$\bf{y_2}$', '$\bf{\hat{g}_{ML}(X_2)}$', 'interpreter','latex');
    if (i == 3)
        Cauchy_kernel(X2,X1, beta(i))
    end
    y1_hat = [];
    y2_hat = [];
end

function Y_hat = g_hat(sigma2, lambda, beta, X_train, y_train, X)
    Y_hat = lambda*Cauchy_kernel(X,X_train, beta)*inv(lambda*Cauchy_kernel(X_train,X_train, beta)+sigma2*eye(size(X,1)))*y_train;
end