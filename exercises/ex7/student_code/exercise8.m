% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)
startup;
clear;

% thresholds
background_filter_top_row_num=120;
initial_match_threshold = 1.4;
thresh_F_ransac = 0.001;
thresh_DLT_ransac = 0.08;


%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[f1, d1] = vl_sift(img1);
[f2, d2] = vl_sift(img2);

%don't take features at the top of the image - only background
[f1, d1] = filter_background(f1,d1,background_filter_top_row_num);
[f2, d2] = filter_background(f2,d2,background_filter_top_row_num);

[matches_12, scores] = vl_ubcmatch(d1, d2, initial_match_threshold);

showFeatureMatches(img1, f1(1:2, matches_12(1,:)), img2, f2(1:2, matches_12(2,:)), 20);

x1_h = makehomogeneous(f1(1:2, matches_12(1,:)));
x2_h = makehomogeneous(f2(1:2, matches_12(2,:)));

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

[F, inliers_12] = ransacfitfundmatrix(x1_h, x2_h, thresh_F_ransac);
%[inliers_12, F] = ransac8pF_adaptive_iter(x1_h, x2_h, thresh_F_ransac);

initial_match_count_12=size(matches_12,2);
outliers_12 = setdiff(1:initial_match_count_12,inliers_12);
x1_in_h = x1_h(:,inliers_12);
x2_in_h = x2_h(:,inliers_12);
x1_out_h = x1_h(:,outliers_12);
x2_out_h = x2_h(:,outliers_12);
showFeatureMatches_inlier_outlier(img1,x1_in_h(1:2,:),x1_out_h(1:2,:),img2,x2_in_h(1:2,:),x2_out_h(1:2,:),23);

%compute essential matrix
E = K'*F*K;

% draw epipolar lines and epipoles in img 1 
figure(24);
imshow(img1, []); hold on, plot(x1_in_h(1,:), x1_in_h(2,:), '*r');
for k = 1:size(x1_in_h,2)
    drawEpipolarLines(F'*x2_in_h(:,k), img1); hold on;
end

% draw epipolar lines and epipoles in img 2
figure(25);
imshow(img2, []); hold on, plot(x2_in_h(1,:), x2_in_h(2,:), '*r');
for k = 1:size(x2_in_h,2)
    drawEpipolarLines(F*x1_in_h(:,k), img2); hold on;
end

x1_calibrated_in = K^(-1)* x1_in_h;
x2_calibrated_in = K^(-1)* x2_in_h;

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated_in, x2_calibrated_in);

%triangulate the inlier matches with the computed projection matrix

[X12, ~] = linearTriangulation(Ps{1}, x1_calibrated_in, Ps{2}, x2_calibrated_in);

%% Add an addtional view of the scene 
% add view 3
imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[f3, d3] = vl_sift(img3);

[f3, d3] = filter_background(f3,d3,background_filter_top_row_num);

f1_w = f1(:,matches_12(1,inliers_12)); % feature points that used to generate world points 
d1_w = d1(:,matches_12(1,inliers_12));

%match against the features from image 1 that where triangulated
[matches_13,~] = vl_ubcmatch(d1_w, d3, initial_match_threshold);
x1_w_h = makehomogeneous(f1_w(1:2, matches_13(1,:)));
x3_h = makehomogeneous(f3(1:2, matches_13(2,:)));
x3_calibrated = K^(-1) * x3_h; 

%run 6-point ransac (DLT)
% [Proj3, inliers_13] = ransacfitprojmatrix(x3_h, X12(:,matches_13(1,:)), thresh_DLT_ransac);
% T_3w=K^(-1)*Proj3(1:3,1:4);
% 
% Ps{3}(1:3,1:3)=T_3w(1:3,1:3)';
% Ps{3}(1:3,4)=-T_3w(1:3,4);
% Ps{3}(4,:)=[0 0 0 1];

[Ps{3}, inliers_13] = ransacfitprojmatrix(x3_calibrated, X12(:,matches_13(1,:)), thresh_DLT_ransac);

% check pose
if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end

initial_match_count_13=size(matches_13,2);
outliers_13 = setdiff(1:initial_match_count_13,inliers_13);

x1_w_in_h=x1_w_h(:,inliers_13);
x3_in_h = x3_h(:,inliers_13);
x1_w_out_h=x1_w_h(:,outliers_13);
x3_out_h = x3_h(:,outliers_13);

% Plot inliers and outliers
show_dlt_ransac_inliers_outliers(img1,x1_w_in_h(1:2,:),x1_w_out_h(1:2,:),...
                    img3,x3_in_h(1:2,:),x3_out_h(1:2,:),30)

%triangulate the inlier matches with the computed projection matrix
x1_w_calibrated_in = K^(-1) * x1_w_in_h;                   
x3_calibrated_in = K^(-1) * x3_in_h;  

[X13, ~] = linearTriangulation(Ps{1}, x1_w_calibrated_in, Ps{3}, x3_calibrated_in);

%% Add more views...
% add view 4
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[f4, d4] = vl_sift(img4);

[f4, d4] = filter_background(f4,d4,background_filter_top_row_num);

%match against the features from image 1 that where triangulated
[matches_14,~] = vl_ubcmatch(d1_w, d4, initial_match_threshold);
x1_w_h = makehomogeneous(f1_w(1:2, matches_14(1,:)));
x4_h = makehomogeneous(f4(1:2, matches_14(2,:)));
x4_calibrated = K^(-1) * x4_h; 

%run 6-point ransac (DLT)

[Ps{4}, inliers_14] = ransacfitprojmatrix(x4_calibrated, X12(:,matches_14(1,:)), thresh_DLT_ransac);

% check pose
if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end

initial_match_count_14=size(matches_14,2);
outliers_14 = setdiff(1:initial_match_count_14,inliers_14);

x1_w_in_h=x1_w_h(:,inliers_14);
x4_in_h = x4_h(:,inliers_14);
x1_w_out_h=x1_w_h(:,outliers_14);
x4_out_h = x4_h(:,outliers_14);

% Plot inliers and outliers
show_dlt_ransac_inliers_outliers(img1,x1_w_in_h(1:2,:),x1_w_out_h(1:2,:),...
                    img4,x4_in_h(1:2,:),x4_out_h(1:2,:),40)

%triangulate the inlier matches with the computed projection matrix
x1_w_calibrated_in = K^(-1) * x1_w_in_h;                   
x4_calibrated_in = K^(-1) * x4_in_h;  

[X14, ~] = linearTriangulation(Ps{1}, x1_w_calibrated_in, Ps{4}, x4_calibrated_in);

% add view 5
imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[f5, d5] = vl_sift(img5);

[f5, d5] = filter_background(f5,d5,background_filter_top_row_num);

%match against the features from image 1 that where triangulated
[matches_15,~] = vl_ubcmatch(d1_w, d5, initial_match_threshold);
x1_w_h = makehomogeneous(f1_w(1:2, matches_15(1,:)));
x5_h = makehomogeneous(f5(1:2, matches_15(2,:)));
x5_calibrated = K^(-1) * x5_h; 

%run 6-point ransac (DLT)
[Ps{5}, inliers_15] = ransacfitprojmatrix(x5_calibrated, X12(:,matches_15(1,:)), thresh_DLT_ransac);

% check pose
if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
    Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
end

initial_match_count_15=size(matches_15,2);
outliers_15 = setdiff(1:initial_match_count_15,inliers_15);

x1_w_in_h=x1_w_h(:,inliers_15);
x5_in_h = x5_h(:,inliers_15);
x1_w_out_h=x1_w_h(:,outliers_15);
x5_out_h = x5_h(:,outliers_15);

% Plot inliers and outliers
show_dlt_ransac_inliers_outliers(img1,x1_w_in_h(1:2,:),x1_w_out_h(1:2,:),...
                    img5,x5_in_h(1:2,:),x5_out_h(1:2,:),50)

%triangulate the inlier matches with the computed projection matrix
x1_w_calibrated_in = K^(-1) * x1_w_in_h;                   
x5_calibrated_in = K^(-1) * x5_in_h;  

[X15, ~] = linearTriangulation(Ps{1}, x1_w_calibrated_in, Ps{5}, x5_calibrated_in);

%% Plot stuff

fig = 1;
figure(fig);

%use plot3 to plot the triangulated 3D points
plot3(X12(1,:),X12(2,:),X12(3,:),'r.'); hold on;
plot3(X13(1,:),X13(2,:),X13(3,:),'g.'); hold on;
plot3(X14(1,:),X14(2,:),X14(3,:),'b.'); hold on;
plot3(X15(1,:),X15(2,:),X15(3,:),'y.'); hold on;

%draw cameras
drawCameras(Ps, fig);

%% Dense model (for example, img 1 and img 2)
% - for GCMex under GCM_ROOT/ you run compile_gc, and then do 
% addpath('GCM_ROOT').

% Taking the following image pair as an example

% Rectify images
imgNameL = '../data/house.000.pgm';
imgNameR = '../data/house.001.pgm';

scale = 1;
%scale = 0.5^2; % try this scale first
%scale = 0.5^3; % if it takes too long for GraphCut, switch to this one

imgL = imresize(single(imread(imgNameL)), scale);
imgR = imresize(single(imread(imgNameR)), scale);

figure(61);
subplot(121); imshow(imgL,[]);
subplot(122); imshow(imgR,[]);

K=[ 670.0000 0 393.000
    0 670.0000 275.000
    0    0    1];

Pose1=Ps{1};
PL = K * Pose1(1:3,:);
Pose2=Ps{3};
PR = K * Pose2(1:3,:);

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);

figure(62);
subplot(121); imshow(imgRectL,[]);
subplot(122); imshow(imgRectR,[]);

% Set disparity range
% you may use the following two lines
% [x1s, x2s] = getClickedPoints(imgRectL, imgRectR); 
% close all;
% to get a good guess

% Automatic determined one
imgL_single=single(imgRectL);
imgR_single=single(imgRectR);

% For higher inlier ratio of correspondences
[fa, da] = vl_sift(imgL_single,'PeakThresh',0.01);
[fb, db] = vl_sift(imgR_single,'PeakThresh',0.01);
[matches, scores] = vl_ubcmatch(da, db, 2.5);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];
%showFeatureMatches(imgRectL, x1s(1:2,:), imgRectR, x2s(1:2,:), 1);

% Apply Adaptive RANSAC 
ransac_threshold = 3;
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

% Automatic determination
range_size=ceil(max(abs(min_disp),abs(max_disp)))
dispRange = -range_size:range_size;

%Compute disparities using graphcut
%(exercise 5.2)
Labels = ...
    gcDisparity(imgRectL, imgRectR, dispRange);
dispsGCL = double(Labels + dispRange(1));
Labels = ...
    gcDisparity(imgRectR, imgRectL, dispRange);
dispsGCR = double(Labels + dispRange(1));

figure(63);
subplot(121); imshow(dispsGCL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispsGCR, [dispRange(1) dispRange(end)]);

% Calculate deepth image from disparity map
baseline_length=norm(Pose1(:,4)-Pose2(:,4));
focus_length=K(1,1);
depthGCL=baseline_length*focus_length./dispsGCL;
imgRectLRGB=cat(3, imgRectL, imgRectL, imgRectL);
% Get 3D model
create3DModel(depthGCL,imgRectLRGB,64);




