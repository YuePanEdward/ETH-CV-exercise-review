%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
% data normalization
corres_num=size(xy,2);

% 1. compute centroid
xy_cent=(mean(xy'))';
XYZ_cent=(mean(XYZ'))';

% 2. shift the input points so that the centroid is at the origin
xy_shift=xy;
XYZ_shift=XYZ;
for i=1:corres_num
  xy_shift(:,i)=xy(:,i)-xy_cent;
  XYZ_shift(:,i)=XYZ(:,i)-XYZ_cent;
end
% 3. compute scale
xy_norm_sum=0;
XYZ_norm_sum=0;
for i=1:corres_num
    xy_norm_sum=xy_norm_sum+norm(xy_shift(:,i),2);
    XYZ_norm_sum=XYZ_norm_sum+norm(XYZ_shift(:,i),2);
end
scale_xy=sqrt(2)/(xy_norm_sum/corres_num);
scale_XYZ=sqrt(3)/(XYZ_norm_sum/corres_num);

% 4. create T and U transformation matrices (similarity transformation)
T=eye(3);
U=eye(4);
T(1:2,3)=scale_xy*(-xy_cent);
U(1:3,4)=scale_XYZ*(-XYZ_cent);
T(1,1)=scale_xy;
T(2,2)=scale_xy;
U(1,1)=scale_XYZ;
U(2,2)=scale_XYZ;
U(3,3)=scale_XYZ;

% 5. normalize the points according to the transformations
% xy_normalized=homogenization(xy_shift*scale_xy)
% XYZ_normalized=homogenization(XYZ_shift*scale_XYZ)

xy_normalized=T*homogenization(xy);
XYZ_normalized=U*homogenization(XYZ);

end