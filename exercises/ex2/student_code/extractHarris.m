% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)
 
%   C   is calulated as landa1*landa2-k(landa1+landa2)^2

% 1.1 Image gradients
gradient_x=conv2(img,[-0.5 0 0.5]','same');
gradient_y=conv2(img,[-0.5 0 0.5],'same');

% 1.2 Local auto-correlation matrix & 1.3 Harris response function
C=zeros(size(img));

gradient_x2=gradient_x.*gradient_x;
gradient_y2=gradient_y.*gradient_y;
gradient_xy=gradient_x.*gradient_y;

gradient_x2_w=imgaussfilt(gradient_x2,sigma);
gradient_y2_w=imgaussfilt(gradient_y2,sigma);
gradient_xy_w=imgaussfilt(gradient_xy,sigma);

for i=2:size(img,1)-1
   for j=2:size(img,2)-1
       
       M_ij=[gradient_x2_w(i,j) gradient_xy_w(i,j); gradient_xy_w(i,j) gradient_y2_w(i,j)];
       
       %  Calculate Harris response
       C(i,j)=det(M_ij)-k*(trace(M_ij)^2);
   end
end

% 1.4 Detection criteria
% strength threshold
C_corner_candidate=C;
for i=1:size(C,1)
    for j=1:size(C,2)
        if C(i,j)<thresh
            C_corner_candidate(i,j)=0;
        end
    end
end

% local maximality
C_corner_non_max_sup=imregionalmax(C_corner_candidate);

[corners_row, corners_col]=find(C_corner_non_max_sup);

corners = [corners_row'; corners_col'];
end