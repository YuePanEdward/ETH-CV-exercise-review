% show feature matches between two images
%
% Input:
%   img1        - n x m color image 
%   corner1     - 2 x k matrix, holding keypoint coordinates of first image
%   img2        - n x m color image 
%   corner1     - 2 x k matrix, holding keypoint coordinates of second image
%   fig         - figure id
function showFeatureMatches_inlier_outlier(img1, corner1_in, corner1_out, img2, corner2_in,corner2_out, fig)
    [sx, sy, sz] = size(img1);
    img = [img1, img2];
    
    corner2_in = corner2_in + repmat([sy, 0]', [1, size(corner2_in, 2)]);
    corner2_out = corner2_out + repmat([sy, 0]', [1, size(corner2_out, 2)]);
    
    figure(fig), imshow(img, []);    
    hold on, plot(corner1_in(1,:), corner1_in(2,:), '+b');
    hold on, plot(corner1_out(1,:), corner1_out(2,:), '+b');
    hold on, plot(corner2_in(1,:), corner2_in(2,:), '+b');
    hold on, plot(corner2_out(1,:), corner2_out(2,:), '+b');    
    hold on, plot([corner1_in(1,:); corner2_in(1,:)], [corner1_in(2,:); corner2_in(2,:)], 'g');    
    hold on, plot([corner1_out(1,:); corner2_out(1,:)], [corner1_out(2,:); corner2_out(2,:)], 'r'); 
end