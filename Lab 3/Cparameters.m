function out = Cparameters(in)
%CPARAMETERS computes the paramters of the compensator given the estimated
%model
%

%% Get the input variable
theta=in; % \hat theta_t

%% Modify the code ONLY here
tr = 0.1;
O  = 0.3;
Ts = 0.001;

epsilon = abs(log(O))/sqrt(pi^2 + log(O)^2);
wn      = 1.8/tr;

p       = exp((-epsilon*wn+1i*wn*sqrt(1-epsilon^2))*Ts);

Dstar   = [1 -2*real(p) real(p)^2+imag(p)^2 0 0];
[Dc_p, Nc] = diophantine([1 theta(1)-2 1-2*theta(1) theta(1)], [theta(2) theta(3)], Dstar);
Dc = [Dc_p(1) Dc_p(2)-Dc_p(1) -Dc_p(2)];

%% Construct the outuput
out=[Nc Dc];


end






