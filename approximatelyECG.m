%%%%%%%%%%%%%%%%%%%% Exercise for Internet of things technology course %%%%%%%%%%%%

% In this exercise approximately sparse ECG signal is sampled using compressive sensing
% Author: Gajraj Kuldeep  
% Date: 18/9/2020
close all; clear all; clc;

%% Define parameters

N=512; % signal length


%% finding the K value of an approximately sparse signal

load mit200
x=ecgsig(1:N,1);

% psi=dctmtx(N); % sparsitying transform for ECG signals 
  psi = wmpdictionary(N,'lstcpt',{{'sym4',4}})';
x_transform=psi*x;

plot(x_transform); % observe the number of significant number of nonzeros
legend('DCT transform of ECG signal')
% Observe the signal in transform domain and specify K value
K=length(find(abs(x_transform)>.25));

%  K=50; % sparsity of signal


%  M=6*K; % the number of measurements 
 M=200;
% M=170;

%% Sensing matrix construction

phi=randn(M,N);

%% Sensing using CS 

y=phi*x;


%% l1-recovery using linear program
phi_rec=phi*psi';

% transfering l1 minimization into linear program
Vec_ones = ones([2 * N, 1]);
Vec_low = zeros([2 * N, 1]);
Vec_high = inf([2 * N, 1]);

ssOpt=optimoptions('linprog', 'Algorithm', 'interior-point');
tic
z_hat=linprog(Vec_ones,[],[], [phi_rec -phi_rec], y, Vec_low, Vec_high,ssOpt);
toc
xp_hat=z_hat(1:N)-z_hat(1+N:end);

x_hat=psi'*xp_hat;
figure;
plot(x);
hold on;
plot((x_hat), 'r.');
legend('Original', 'Recovered');

disp("Mean square error is")
mse(x,x_hat)