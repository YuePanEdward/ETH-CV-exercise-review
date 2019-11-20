%exercise1_bak.m
% Exervice 1
%
% clear all;
% close all;

IMG_NAME = 'images/image001.jpg';


%This function displays the calibration image and allows the user to click
%in the image to get the input points. Left click on the chessboard corners
%and type the 3D coordinates of the clicked points in to the input box that
%appears after the click. You can also zoom in to the image to get more
%precise coordinates. To finish use the right mouse button for the last
%point.
%You don't have to do this all the time, just store the resulting xy and
%XYZ matrices and use them as input for your algorithms.
%[xy XYZ] = getpoints(IMG_NAME);

% === Task 1 Data normalization ===
% [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

% === Task 2 DLT algorithm ===
% With normalization 
[P_dlt, K_dlt, R_dlt, t_dlt, error_dlt] = runDLT(xy, XYZ);
% Without normalization (for comparison)
%[P_dlt, K_dlt, R_dlt, t_dlt, error_dlt] = runDLTwithoutnormalization(xy, XYZ);

%visualization_reprojected_points(xy, XYZ, P_dlt, IMG_NAME);

% === Task 3 Gold Standard algorithm ===
[P_gold, K_gold, R_gold, t_gold, error_gold] = runGoldStandard(xy, XYZ);

%visualization_reprojected_points(xy, XYZ, P_gold, IMG_NAME);

% Visualize result togther
visualization_reprojected_points_compare(xy, XYZ, P_dlt, P_gold, IMG_NAME);
