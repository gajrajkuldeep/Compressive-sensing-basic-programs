%%%%%%%%%%%%%%%%%%%% Exercise for Internet of things technology course %%%%%%%%%%%%

%In this exercise K-sparse signal is sampled using compressive sensing
% Author: Gajraj Kuldeep  
% Date: 18/9/2020

close all; clear all; clc;

%% Define parameters

N=512; % signal length

K=20; % sparsity of signal

M=6*K; % the number of measurements 


%% Construction of K-sparse signal
x=zeros(N,1); 

x(randperm(N,K))=randn(K,1);

%% Sensing matrix construction

phi=randn(M,N);



%% Sensing using CS 

y=phi*x;


%% l1-recovery using linear program


% transfering l1 minimization into linear program
Vec_ones = ones([2 * N, 1]);
Vec_low = zeros([2 * N, 1]);
Vec_high = inf([2 * N, 1]);

ssOpt=optimoptions('linprog', 'Algorithm', 'interior-point');
tic
z_hat=linprog(Vec_ones,[],[], [phi -phi], y, Vec_low, Vec_high,ssOpt);
toc
x_hat=z_hat(1:N)-z_hat(1+N:end);

figure;
plot(x);
hold on;
plot((x_hat), 'r.');
legend('Original', 'Recovered');

disp("Mean square error is")
mse(x,x_hat)
