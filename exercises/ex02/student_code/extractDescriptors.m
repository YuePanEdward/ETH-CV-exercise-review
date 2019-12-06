% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)
% 2.1 Local descriptors
% filter out the keypoints that are too close to the image boundaries
boundary_thre=(9+1)/2; 
keypoints_filtered=[];
for i=1:size(keypoints,2)
   if (keypoints(1,i)>= boundary_thre && keypoints(1,i)<= size(img,1)-boundary_thre ...,
    && keypoints(2,i)>= boundary_thre && keypoints(2,i)<= size(img,2)-boundary_thre)
        keypoints_filtered=[keypoints_filtered keypoints(:,i)];
   end
end
keypoints=keypoints_filtered;

descriptors = extractPatches(img, keypoints, 9);

end