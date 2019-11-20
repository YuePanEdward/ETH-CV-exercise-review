% =========================================================================
% Feature extraction and matching
% =========================================================================
clear
addpath helpers

%don't forget to initialize VLFeat
% Run startup.m
startup;

%Load images
% dataset = 0;   % Your pictures
dataset = 1; % ladybug (ok)
% dataset = 2; % rect (ok)
% dataset = 3; % pumpkin (ok)

% image names
if(dataset==0)
    imgName1 = ''; % Add your own images here if you want
    imgName2 = '';
elseif(dataset==1)
    imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
    imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';
elseif(dataset==2)
    imgName1 = 'images/rect1.jpg';
    imgName2 = 'images/rect2.jpg';
elseif(dataset==3)
    imgName1 = 'images/pumpkin1.jpg';
    imgName2 = 'images/pumpkin2.jpg';
end

img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
% [fa, da] = vl_sift(img1);
% [fb, db] = vl_sift(img2);
% [matches, scores] = vl_ubcmatch(da, db);

% For higher inlier ratio of correspondences
[fa, da] = vl_sift(img1,'PeakThresh',0.01);
[fb, db] = vl_sift(img2,'PeakThresh',0.01);
[matches, scores] = vl_ubcmatch(da, db, 2);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];

%show matches
clf
showFeatureMatches(img1, x1s(1:2,:), img2, x2s(1:2,:), 1);


%%
% =========================================================================
% 8-point RANSAC
% =========================================================================

threshold = 5;

% TODO: implement ransac8pF
% Simple RANSAC
%[inliers, F] = ransac8pF(x1s, x2s, threshold);

% Adaptive RANSAC
%[inliers, F] = ransac8pF_adaptive_iter(x1s, x2s, threshold);
[inliers, F] = adaptive_ransac8pF(x1s, x2s, threshold);

showFeatureMatches(img1, x1s(1:2, inliers), img2, x2s(1:2, inliers), 1);

% =========================================================================

%% Draw epipolar lines
x1s_in=x1s(:,inliers);
x2s_in=x2s(:,inliers);

x1s_out=x1s;
x2s_out=x2s;
x1s_out(:,inliers)=[];
x2s_out(:,inliers)=[];

% FF is the fundamental matrix we wish to draw epipolar lines for
FF = F

%verify_result=x2s'*FF*x1s;
verify_result=kron(x1s_in',x2s_in')*FF(:);

% show clicked points
figure(3),clf, imshow(img1, []); hold on, plot(x1s_in(1,:), x1s_in(2,:), '*r');
figure(4),clf, imshow(img2, []); hold on, plot(x2s_in(1,:), x2s_in(2,:), '*r');

figure(3),plot(x1s_out(1,:), x1s_out(2,:), '.c');
figure(4),plot(x2s_out(1,:), x2s_out(2,:), '.c');

% draw epipolar lines in img 1
figure(3)
for k = 1:size(x1s_in,2)
    drawEpipolarLines(FF'*x2s_in(:,k), img1);
end
% draw epipolar lines in img 2
figure(4)
for k = 1:size(x2s_in,2)
    drawEpipolarLines(FF*x1s_in(:,k), img2);
end

% calculate epipole 
[U,D,V]=svd(FF);
e1=V(:,size(V,2));
e1=e1/e1(3);
figure(3)
plot(e1(1), e1(2), '+y')

[U,D,V]=svd(FF');
e2=V(:,size(V,2));
e2=e2/e2(3);
figure(4)
plot(e2(1), e2(2), '+y')