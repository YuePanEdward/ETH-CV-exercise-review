% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points 3*n
% Outputs:
%           nxs = normalized points 3*n
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)

% data normalization
points_num=size(xs,2);
xs=xs(1:2,:);

% 1. compute centroid
xs_cent=(mean(xs'))';

% 2. shift the input points so that the centroid is at the origin
for i=1:points_num
    xs_shift(:,i)=xs(:,i)-xs_cent;
end

% 3. compute scale
xs_norm_sum=0;
for i=1:points_num
    xs_norm_sum=xs_norm_sum+norm(xs_shift(:,i),2);
end
scale_xs=sqrt(2)/(xs_norm_sum/points_num);

% 4. create T and U transformation matrices (similarity transformation)
T=eye(3);
T(1:2,3)=scale_xs*(-xs_cent);
T(1,1)=scale_xs;
T(2,2)=scale_xs;

% 5. normalize the points according to the transformations
nxs=T*[xs; ones(1,points_num)];

end
