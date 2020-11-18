%%%%%%%%%%%%%%%%%%%% Exercise for Internet of things technology course %%%%%%%%%%%%

% Data gathering using CS 
% Author: Gajraj Kuldeep  
% Date: 18/9/2020
close all; clear all; clc;

%Let A, B, and C are devices

% Requirements of the  device A
K_A=10;  % Number of reading send in each time 
N_A=90; % Total number of sensors at A
% Requirements of the  device B
K_B=4;  % Number of reading send in each time 
N_B=40; % Total number of sensors at A

% Requirements of the  device C
K_C=6;  % Number of reading send in each time 
N_C=50; % Total number of sensors at A
% final sparsity 

K=K_A+K_B+K_C;

%% Define parameters

N=N_A+N_B+N_C; % signal length  


M=5*K; % the number of measurements 

A = randn(N);
phi = orth(A')';
phi=phi(1:M,:);

% sensing matrix at A
phi_A=phi(:,1:N_A);

% sensing matrix at B
phi_B=phi(:,N_A+1:N_A+N_B);

% sensing matrix at C
phi_C=phi(:,N_A+N_B+1:N_A+N_B+N_C);


%% Sensing at the device A
x_A=zeros(N_A,1); 

x_A(randperm(N_A,K_A))=randn(K_A,1);

y_A=phi_A*x_A;

sigTX_A=y_A;

%% Sensing at the device B
x_B=zeros(N_B,1); 

x_B(randperm(N_B,K_B))=randn(K_B,1);

y_B=phi_B*x_B;


sigTX_B=sigTX_A+y_B;

%% Sensing at the device C
x_C=zeros(N_C,1); 

x_C(randperm(N_C,K_C))=randn(K_C,1);

y_C=phi_C*x_C;

sigTX_C=sigTX_B+y_C;

disp('Done.');



%% Reconstruction at  cloud 
% l1-recovery using linear program

sigRX=sigTX_C;
% transfering l1 minimization into linear program
Vec_ones = ones([2 * N, 1]);
Vec_low = zeros([2 * N, 1]);
Vec_high = inf([2 * N, 1]);

ssOpt=optimoptions('linprog', 'Algorithm', 'interior-point');
tic
x_hat=linprog(Vec_ones,[],[], [phi -phi], sigRX, Vec_low, Vec_high,ssOpt);
toc
x_hat=x_hat(1:N)-x_hat(1+N:end);



%%  Displaying reconstructed signals for A, B, and C

subplot(3,1,1);
plot(x_A); hold on; plot(x_hat(1:N_A), 'r.');legend('Original signal at A', 'Recovered');
subplot(3,1,2);
plot(x_B); hold on; plot(x_hat(N_A+1:N_A+N_B), 'r.');legend('Original signal at B', 'Recovered');
subplot(3,1,3);
plot(x_C); hold on; plot(x_hat(N_A+N_B+1:N_A+N_B+N_C), 'r.');legend('Original signal at C', 'Recovered');


