%% Mutual coherence 
N=64; M=32;
phi=randn(M,N);
% psi=eye(N);
%  psi=dctmtx(N);
%  psi = wmpdictionary(N,'lstcpt',{{'sym4',4}});
% psi = wmpdictionary(N,'lstcpt',{{'db4',4}});
%  psi = wmpdictionary(N,'lstcpt',{{'coif4',4}});
%f=5; g=8; % choose random columns
for f=1:M
    for g=1:N

Coherence(f,g)=abs(phi(f,:)*psi(:,g))/(norm(phi(f,:))*norm(psi(:,g)));
    end
end

max(Coherence(:))

 