%%%%%%%%%%%%%%%%%%%% Exercise for Internet of things technology course %%%%%%%%%%%%

% In this exercise approximately sparse audio signal is sampled using compressive sensing
% Author: Gajraj Kuldeep  
% Date: 18/9/2020

close all; clear all; clc;

%% Define parameters

N=512; % signal length


%% finding the K value of an approximately sparse signal
load handel.mat  %% sound signal is loaded into y variable 
L=round(length(y)/N)-1;
audioSignal=y(1:L*N);
 sound(audioSignal,Fs); % for listening the sound 


psi=dctmtx(N); % sparsitying transform for ECG signals 

x_transform=psi*audioSignal(1:N,1);

%% Find out the minimum value of K
% K=60; % sparsity of signal
K=length(find(abs(x_transform)>.05));

M=6*K; % the number of measurements 

%% Sensing matrix construction

phi=randn(M,N);

%% Sensing using CS 
for i=1:L
x=audioSignal(1+(i-1)*N:N*i,1); %% taking a block of signal 
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

x_hat(:,i)=psi'*xp_hat;
end
x_hat=x_hat(:);
sound(x_hat,Fs);
figure;
plot(audioSignal);
hold on;
plot((x_hat), 'r.');
legend('Original', 'Recovered');
disp("Mean square error is")
mse(audioSignal,x_hat)
