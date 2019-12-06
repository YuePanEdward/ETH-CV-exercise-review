close all;

%%

% 1 - Feature detection

IMG_NAME1 = 'images/blocks.jpg';
IMG_NAME2 = 'images/house.jpg';

% Read images.
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

% Extract Harris corners.
sigma = [0.5 1 2];                    % suggested values: .5, 1, 2
k=linspace(4e-2,6e-2,3);      % [4e-2, 6e-2]
thresh = [1e-6 1e-5 1e-4];                % [1e-6, 1e-4]

%{
figure(1)
% subplot(4,7,1)  
% imshow(img1);
% title('Original Image','fontname','Times New Roman','FontSize',8);

for x=1:size(sigma,2)
    for y=1:size(k,2)
        for z=1:size(thresh,2)
            [corners1, C1] = extractHarris(img1, sigma(x), k(y), thresh(z));
            subplot(3,9,(x-1)*9+(y-1)*3+z)  
            imshow(img1);
            hold on;
            plot(corners1(2, :), corners1(1, :), '+r','MarkerSize',5);
            hold off;
            title({['\sigma=',num2str(sigma(x))],['k=',num2str(k(y))],['t=',num2str(thresh(z))]},'fontname','Times New Roman','FontSize',8);
        end
    end
end

figure(2)
% subplot(4,7,1)  
% imshow(img2);
% title('Original Image','fontname','Times New Roman','FontSize',8);

for x=1:size(sigma,2)
    for y=1:size(k,2)
        for z=1:size(thresh,2)
            [corners2, C2] = extractHarris(img2, sigma(x), k(y), thresh(z));
            subplot(3,9,(x-1)*9+(y-1)*3+z)  
            imshow(img2);
            hold on;
            plot(corners2(2, :), corners2(1, :), '+r','MarkerSize',5);
            hold off;
            title({['\sigma=',num2str(sigma(x))],['k=',num2str(k(y))],['t=',num2str(thresh(z))]},'fontname','Times New Roman','FontSize',8);
        end
    end
end


% for i=1:size(k)
%     [corners2, C2] = extractHarris(img2, sigma, k(i), thresh);
%     subplot(5,2,i)
%     plotImageWithKeypoints(img2, corners2, 11);
% end

% Plot images with Harris corners.
% plotImageWithKeypoints(img1, corners1, 10);
% plotImageWithKeypoints(img2, corners2, 11);
%}
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
sigma = 2;
k = 4e-2;
thresh = 1e-5;

[corners1, C1] = extractHarris(img1, sigma, k, thresh);
[corners2, C2] = extractHarris(img2, sigma, k, thresh);

% Plot images with Harris corners.
plotImageWithKeypoints(img1, corners1, 20);
plotImageWithKeypoints(img2, corners2, 21);

% Extract descriptors.
[corners1_f, descr1] = extractDescriptors(img1, corners1);
[corners2_f, descr2] = extractDescriptors(img2, corners2);

% Plot images with filtered Harris corners.
plotImageWithKeypoints(img1, corners1_f, 25);
plotImageWithKeypoints(img2, corners2_f, 26);

% Match the descriptors - one way nearest neighbors.
matches_ow = matchDescriptors(descr1, descr2, 'one-way');

% Plot the matches.
plotMatches(img1, corners1_f(:, matches_ow(1, :)), img2, corners2_f(:, matches_ow(2, :)), 22);

% Match the descriptors - mutual nearest neighbors.
matches_mutual = matchDescriptors(descr1, descr2, 'mutual');

% Plot the matches.
plotMatches(img1, corners1_f(:, matches_mutual(1, :)), img2, corners2_f(:, matches_mutual(2, :)), 23);

% Match the descriptors - ratio test.
matches_ratio = matchDescriptors(descr1, descr2, 'ratio');

% Plot the matches.
plotMatches(img1, corners1_f(:, matches_ratio(1, :)), img2, corners2_f(:, matches_ratio(2, :)), 24);

