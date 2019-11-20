close all;

%%

% 1 - Feature detection

IMG_NAME1 = 'images/blocks.jpg';
IMG_NAME2 = 'images/house.jpg';

% Read images.
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

% Extract Harris corners.
sigma = 2;       % suggested values: .5, 1, 2
k = 4e-2;        % [4e-2, 6e-2]
thresh = 1e-5;   % [1e-6, 1e-4]
[corners1, C1] = extractHarris(img1, sigma, k, thresh);
[corners2, C2] = extractHarris(img2, sigma, k, thresh);

% Plot images with Harris corners.
plotImageWithKeypoints(img1, corners1, 10);
plotImageWithKeypoints(img2, corners2, 11);

%%
% 2 - Feature description and matching

IMG_NAME1 = 'images/I1.jpg';
IMG_NAME2 = 'images/I2.jpg';

% Read images.
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

% Convert to grayscale.
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

% Extract Harris corners.
% Parameters setting
% sigma = 1;
% k = 5e-2;
% thresh = 1e-5;

[corners1, C1] = extractHarris(img1, sigma, k, thresh);
[corners2, C2] = extractHarris(img2, sigma, k, thresh);

% Plot images with Harris corners.
plotImageWithKeypoints(img1, corners1, 20);
plotImageWithKeypoints(img2, corners2, 21);

% Extract descriptors.
[corners1, descr1] = extractDescriptors(img1, corners1);
[corners2, descr2] = extractDescriptors(img2, corners2);

% Match the descriptors - one way nearest neighbors.
matches_ow = matchDescriptors(descr1, descr2, 'one-way');

% Plot the matches.
plotMatches(img1, corners1(:, matches_ow(1, :)), img2, corners2(:, matches_ow(2, :)), 22);

% Match the descriptors - mutual nearest neighbors.
matches_mutual = matchDescriptors(descr1, descr2, 'mutual');

% Plot the matches.
plotMatches(img1, corners1(:, matches_mutual(1, :)), img2, corners2(:, matches_mutual(2, :)), 23);

% Match the descriptors - ratio test.
matches_ratio = matchDescriptors(descr1, descr2, 'ratio');

% Plot the matches.
plotMatches(img1, corners1(:, matches_ratio(1, :)), img2, corners2(:, matches_ratio(2, :)), 24);
