clear all
close all
clc

% F_theta0
Fnum = [0 2.99 -0.2];
Fden = [1 -0.96 0.97];

% G_theta0
Gnum = [1 0 0];
Gden = [1 -0.96 0.97];

% theta0
theta0 = [-0.96 0.97 2.99 -0.2];

% Sampling time
Ts = 1;

% Noise variance sigma0^2 of e0 = sigma_0*en0
noiseVar = 4.6 * 4.6;

% Actual model M_0
m0 = idpoly([],Fnum,Gnum,Gden,Fden,noiseVar,Ts);

N_values = [200, 8000];
for i = 1:size(N_values)+1
    
    % Length of the data
    N = N_values(i);

    % Input
    alpha1 = 1/8;
    alpha2 = 3;
    k_sin = 5;
    u = 4 * idinput(N,'sine',[alpha1 alpha2],[],k_sin);

    % Normalized WGN noise
    en0 = idinput(N,'rgs'); 

    % Creation of the iddata object where we store only the input data u
    u = iddata([],u,Ts); 

    % Creation of the iddata object where we store only the normalized noise data en0
    en0 = iddata([],en0,Ts);

    % Generation of the output data given model, input and noise
    y = sim(m0, [u en0]);

    % Creation of an iddata object for the output and input data 
    data = iddata(y,u);

    %% PEM method

    % Estimation of an ARX model
    % Orders of the ARX model
    % orders_arx(1) = nA
    % orders_arx(2) = nB
    % orders_arx(3) = nk
    orders_arx = [2 2 1]; 

    % ARX model estimation
    m_arx = arx(data,orders_arx);

    % Estimation of an ARMAX model
    % Orders of the ARMAX model
    % orders_armax(1) = nA
    % orders_armax(2) = nB
    % orders_armax(3) = nC
    % orders_armax(4) = nk
    orders_armax = [2 2 1 1];

    % ARMAX model estimation
    m_armax = armax(data,orders_armax);

    % Estimation of an OE model
    % Orders of the OE model
    % orders_oe(1) = nB
    % orders_oe(2) = nF
    % orders_oe(3) = nk
    orders_oe = [3 3 1]; 

    % OE model estimation
    m_oe = oe(data,orders_oe);

    % Estimation of a Box-Jenkins model
    % Coefficients of the BJ model
    % orders_bj(1) = nB
    % orders_bj(2) = nC
    % orders_bj(3) = nD
    % orders_bj(4) = nF
    % orders_bj(5) = nk
    orders_bj = [2 1 1 2 1];

    % BJ model generation
    m_bj = bj(data,orders_bj);

    % Bode Plot
    models = [m_arx,m_armax,m_oe,m_bj];
    models_name = ["arx", "armax", "oe", "bj"];
    figure(i);
    for j=1:4
        subplot(2,2,j);
        bodeplot(m0,models(j));
        legend('m0', models_name(j));
        title("m0 vs " + models_name(j));
    end
    sgtitle("N = " + N);
    
    %% Confidence Intervals
    Pn_hat = P_hat(m_arx.NoiseVariance, N, data, m_arx);
    theta_arx = [m_arx.A(2) m_arx.A(3) m_arx.B(2) m_arx.B(3)];

    extremes = zeros(m_arx.na + m_arx.nb + m_arx.nc + m_arx.nd,1);
    approx_errors = zeros(m_arx.na + m_arx.nb + m_arx.nc + m_arx.nd,1);
    isIn = 1;
    for j=1:size(extremes)
        extremes(j) = 1.96 * sqrt(Pn_hat(j,j)/N);
        approx_errors(j) = abs(theta_arx(j)-theta0(j));
        if approx_errors(j) > extremes(j)
            isIn = 0;
        end
    end
   
    disp("N = " + N);
    fprintf("Approximation errors on: \n a1 = " + approx_errors(1) + "\n a2 = " + approx_errors(2) + " \n b0 = " + approx_errors(3) + "\n b1 = " + approx_errors(4) + "\n \n");
    fprintf("Upper bounds on: \n a1 = " + extremes(1) + "\n a2 = " + extremes(2) + " \n b0 = " + extremes(3) + "\n b1 = " + extremes(4) + "\n \n");
    if (isIn == 0)
        disp("theta0 does NOT belong to the confidence interval")
    else
        disp("theta0 does belong to the confidence interval")
    end
    fprintf("\n \n");

end


function Pn_hat = P_hat(sigma2_hat, N, data, model)
    sum = zeros(model.na + model.nb + model.nc + model.nd);
    for t = 3:N
        vec = transpose([-data.y(t-1) -data.y(t-2) data.u(t-1) data.u(t-2)]);
        sum = sum + vec * transpose(vec);
    end
    Pn_hat = sigma2_hat * inv(sum/N);
end