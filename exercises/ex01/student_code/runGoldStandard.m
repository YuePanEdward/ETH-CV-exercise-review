%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)
corres_num=size(xy,2);

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end
P_normalized = [pn(1:4);pn(5:8);pn(9:12)];

%denormalize projection matrix
P=inv(T)*P_normalized*U;

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