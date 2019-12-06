%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)
corres_num=size(xy,2);

% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

%denormalize projection matrix
P=inv(T)*Pn*U;

%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

%compute average reprojection error
xy_tran=P*[XYZ;ones(1,corres_num)];
xy_tran_homo=xy_tran;
error_vec=zeros(1,corres_num);
for i=1:corres_num
  xy_tran_homo(:,i)=xy_tran(:,i)./xy_tran(3,i);
  error_vec(i)=norm(xy_tran_homo(1:2,i)-xy(:,i));
end
error=mean(error_vec);
end