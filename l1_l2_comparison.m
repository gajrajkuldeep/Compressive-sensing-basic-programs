%%%%%%%%%%%%%%%%%%%% Exercise for Internet of things technology course %%%%%%%%%%%%

% This program empirically demonstrates that the l2 norm minimization gives
% a non-sparse solution whereas l1 minimization gives a sparse solution.
% Author: Gajraj Kuldeep  
% Date: 18/9/2020

close all; clear all; clc;

%% Here we are formulating ill-conditioned linear equation using  y=Ax 
%  A=[1/2 1/2]; y=2 ;

A=[1/3 1/3 1/3; 1 -1 -1]; y=[2 ;0];
% A=[1/3 1/3 1/3, 1; 1 -1 -1 1; 1 0 -1 0]; y=[2 ;0;2];

% A=[8,7,6,6,6,6,9,6;3,1,5,4,1,9,7,8;8,6,6,10,9,10,8,10;1,3,5,9,0,1,4,7]; y=[1;5;8;19];
 
% [M N]=size(A);


%% Observe for random A and y
 M=5 ; N=8 ;
 A=randn(M,N); y=randn(M,1);


%% l2 norm minimization 
x_l2norm = lsqminnorm(A,y);


%% l1 norm minimization using linear program
Vec_ones = ones([2 * N, 1]);
Vec_low = zeros([2 * N, 1]);
Vec_high = inf([2 * N, 1]);

ssOpt=optimoptions('linprog', 'Algorithm', 'interior-point');
tic
z_hat=linprog(Vec_ones,[],[], [A -A], y, Vec_low, Vec_high,ssOpt);
toc

x_l1norm=z_hat(1:N)-z_hat(1+N:end);

disp("The l2 solution is:")
x_l2norm
disp("The l1 solution is:")
x_l1norm