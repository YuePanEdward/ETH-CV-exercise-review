%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
% Decompose P into K, R and t using QR decomposition

% M =K R 
% inv(M) = inv(R) Inv(K£©= Q R
          
% Compute R, K with QR decomposition such M=K*R 
M=P(:,1:3);

[R,K]=qr(inv(M));

R=inv(R);
K=inv(K);

% Compute camera center C=(cx,cy,cz) such P*C=0 
[U,D,V]=svd(P);

C=V(:,size(V,2));
C=C/C(4);
C=C(1:3)

% normalize K such K(3,3)=1

K=K/K(3,3)

% Adjust matrices R and Q so that the diagonal elements of K = intrinsic matrix are non-negative values and R = rotation matrix = orthogonal has det(R)=1

% Compute translation t=-R*C
t=-R*C

end