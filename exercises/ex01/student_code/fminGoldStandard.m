%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)
corres_num=size(xy_normalized,2);

%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];

%compute reprojection error 
xy_tran=P*XYZ_normalized;
xy_tran_homo=xy_tran;
error_vec=zeros(1,corres_num);
for i=1:corres_num
xy_tran_homo(:,i)=xy_tran(:,i)./xy_tran(3,i);
error_vec(i)=norm(xy_tran_homo(1:2,i)-xy_normalized(1:2,i));
end

%compute cost function value
f=0;
for i=1:corres_num
    f=f+error_vec(i)*error_vec(i);
end
%f
end