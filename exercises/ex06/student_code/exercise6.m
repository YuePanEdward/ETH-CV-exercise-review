%% 
% Before starting, you should include the VLfeat (http://www.vlfeat.org/)
% and GCMex packages (https://github.com/shaibagon/GCMex) in your path:
% - for vlfeat under VLF_ROOT/vlfeat-0.9.21/toolbox/ you run vl_setup, 
% which does the job for you,
% - for GCMex under GCM_ROOT/ you run compile_gc, and then do 
% addpath('GCM_ROOT').
% Should you have any problems compiling them under Linux, Windows, Mac, 
% please refer to the corresponding websites for further instructions.

%%
% Rectify images
imgNameL = 'images/0018.png';
imgNameR = 'images/0019.png';
camNameL = 'images/0018.camera';
camNameR = 'images/0019.camera';

scale = 0.5^2; % try this scale first
%scale = 0.5^3; % if it takes too long for GraphCut, switch to this one

imgL = imresize(imread(imgNameL), scale);
imgR = imresize(imread(imgNameR), scale);

figure(1);
subplot(121); imshow(imgL);
subplot(122); imshow(imgR);

[K R C] = readCamera(camNameL);
PL = K * [R, -R*C];
[K R C] = readCamera(camNameR);
PR = K * [R, -R*C];

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);

figure(2);
subplot(121); imshow(imgRectL);
subplot(122); imshow(imgRectR);
close all;

se = strel('square', 15);
maskL = imerode(maskL, se);
maskR = imerode(maskR, se);
%%
% Set disparity range
% (exercise 5.3)
% you may use the following two lines
% [x1s, x2s] = getClickedPoints(imgRectL, imgRectR); 
% close all;
% to get a good guess

% Original one
dispRange = -40:40;

% Manually determined one
dispRange = -15:15;

% Automatic determined one
img1=single(rgb2gray(imgRectL));
img2=single(rgb2gray(imgRectR));

% For higher inlier ratio of correspondences
[fa, da] = vl_sift(img1,'PeakThresh',0.01);
[fb, db] = vl_sift(img2,'PeakThresh',0.01);
[matches, scores] = vl_ubcmatch(da, db, 2);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];
%showFeatureMatches(imgRectL, x1s(1:2,:), imgRectR, x2s(1:2,:), 1);

% Apply Adaptive RANSAC 
ransac_threshold = 2;
[inliers, F] = ransac8pF_adaptive_iter(x1s, x2s, ransac_threshold);
x1s=x1s(1:2, inliers);
x2s=x2s(1:2, inliers);
showFeatureMatches(imgRectL, x1s, imgRectR, x2s, 1);

% Further filter outliers
x1sf=[];
x2sf=[];
x1s_check=[];
x2s_check=[];

thre_y=1;
for i=1:size(x1s,2)
  if abs(x1s(2,i)-x2s(2,i))<thre_y
    x1sf=[x1sf x1s(:,i)];
    x2sf=[x2sf x2s(:,i)];
  end
end
[min_disp, min_index] =min(x2sf(1,:)-x1sf(1,:));
[max_disp, max_index] =max(x2sf(1,:)-x1sf(1,:));
min_disp
max_disp
showFeatureMatches(imgRectL, x1sf(1:2,:), imgRectR, x2sf(1:2,:), 1);
%showFeatureMatches(imgRectL, x1sf(1:2,[min_index max_index]), imgRectR, x2sf(1:2,[min_index max_index]), 1);

% Automatic determination
range_size=ceil(max(abs(min_disp),abs(max_disp)))
dispRange = -range_size:range_size;

%%
%Compute disparities, winner-takes-all
%(exercise 5.1)
dispStereoL = ...
    stereoDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRange);
dispStereoR = ...
    stereoDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRange);

figure(1);
subplot(121); imshow(dispStereoL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispStereoR, [dispRange(1) dispRange(end)]);

thresh = 8;

maskLRcheck = leftRightCheck(dispStereoL, dispStereoR, thresh);
maskRLcheck = leftRightCheck(dispStereoR, dispStereoL, thresh);

maskStereoL = double(maskL).*maskLRcheck;
maskStereoR = double(maskR).*maskRLcheck;

figure(2);
subplot(121); imshow(maskStereoL);
subplot(122); imshow(maskStereoR);
%close all;

%%
%Compute disparities using graphcut
%(exercise 5.2)
Labels = ...
    gcDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRange);
dispsGCL = double(Labels + dispRange(1));
Labels = ...
    gcDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRange);
dispsGCR = double(Labels + dispRange(1));

figure(3);
subplot(121); imshow(dispsGCL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispsGCR, [dispRange(1) dispRange(end)]);

thresh = 8;

maskLRcheck = leftRightCheck(dispsGCL, dispsGCR, thresh);
maskRLcheck = leftRightCheck(dispsGCR, dispsGCL, thresh);

maskGCL = double(maskL).*maskLRcheck;
maskGCR = double(maskR).*maskRLcheck;

figure(4);
subplot(121); imshow(maskGCL);
subplot(122); imshow(maskGCR);
%close all;

%%
% Using the following code, visualize your results from 5.1 and 5.2 and 
% include them in your report 
dispStereoL = double(dispStereoL);
dispStereoR = double(dispStereoR);
dispsGCL = double(dispsGCL);
dispsGCR = double(dispsGCR);

S = [scale 0 0; 0 scale 0; 0 0 1];

% For each pixel (x,y), compute the corresponding 3D point 
% use S for computing the rescaled points with the projection 
% matrices PL PR
[coords ~] = ...
    generatePointCloudFromDisps(dispsGCL, Hleft, Hright, S*PL, S*PR);
% ... same for other winner-takes-all
[coords2 ~] = ...
    generatePointCloudFromDisps(dispStereoL, Hleft, Hright, S*PL, S*PR);

imwrite(imgRectL, 'imgRectL.png');
imwrite(imgRectR, 'imgRectR.png');

% Use meshlab to open generated textured model, i.e. modelGC.obj
generateObjFile('modelGC', 'imgRectL.png', ...
    coords, maskGCL.*maskGCR);
% ... same for other winner-takes-all, i.e. modelStereo.obj
generateObjFile('modelStereo', 'imgRectL.png', ...
    coords2, maskStereoL.*maskStereoR);
