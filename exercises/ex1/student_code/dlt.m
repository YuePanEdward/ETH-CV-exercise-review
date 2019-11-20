%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function
corres_num=size(xyn,2);
A=zeros(2*corres_num,12); % A: 2k*12
% 1. For each correspondence xi <-> Xi, computes matrix Ai
for i=1:corres_num
   A(2*i-1,1:4)=XYZn(:,i);
   A(2*i-1,9:12)=-xyn(1,i)*XYZn(:,i);
   A(2*i,5:8)=XYZn(:,i);
   A(2*i,9:12)=-xyn(2,i)*XYZn(:,i); 
end
A
% 2. Compute the Singular Value Decomposition of A
[U,D,V] = svd(A);

% 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)
P_normalized_list=V(:,size(V,2)); 
P_normalized=zeros(3,4);
P_normalized(1,:)=P_normalized_list(1:4);
P_normalized(2,:)=P_normalized_list(5:8);
P_normalized(3,:)=P_normalized_list(9:12);

end
