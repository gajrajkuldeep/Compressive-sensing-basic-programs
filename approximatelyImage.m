%%%%%%%%%%%%%%%%%%%% Exercise for Internet of things technology course %%%%%%%%%%%%
% In this exercise approximately sparse image signal is sampled using compressive sensing
% Author: Gajraj Kuldeep  
% Date: 18/9/2020

close all; clear all; clc;

%% Define parameters

 % signal length

L=32; % image resize
img = double(imresize(imread('cameraman.tif'),[L L]));
[N1,N2]=size(img);
N=N1*N2;

psi=dctmtx(N);
% find K and optimize the value of M
x_transform=psi*img(:);
K=length(find(abs(x_transform)>45));
M=6*K; % the number of measurements 


x=img(:);

%% Sensing matrix construction

phi=randn(M,N);

%% Sensing using CS 

y=phi*x;


%% partial knowledge of sensing matrix 


phi_rec=phi*psi';

%% l1-recovery using linear program


% transfering l1 minimization into linear program
Vec_ones = ones([2 * N, 1]);
Vec_low = zeros([2 * N, 1]);
Vec_high = inf([2 * N, 1]);

ssOpt=optimoptions('linprog', 'Algorithm', 'interior-point');
tic
z_hat=linprog(Vec_ones,[],[], [phi_rec -phi_rec], y, Vec_low, Vec_high,ssOpt);
toc
xp_hat=z_hat(1:N)-z_hat(1+N:end);
xp_hat=psi'*xp_hat;
x_hat=vec2mat(xp_hat,N1)';
figure;
imshow(uint8(img));

figure;
imshow(uint8(x_hat));

