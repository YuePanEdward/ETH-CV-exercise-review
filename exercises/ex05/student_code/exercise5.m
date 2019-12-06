function run_ex5()

% load image
% img = imread('zebra_b.jpg');
img = imread('cow.jpg');
% img = imresize(img, 0.5);

% for faster debugging you might want to decrease the size of your image
% (use imresize)
% (especially for the mean-shift part!)

figure, imshow(img,[]), title('original image')

% smooth image (6.1a)
% (replace the following line with your code for the smoothing of the image)
sigma = 5.0;
size = 5;
filter = fspecial('gaussian',size,sigma);
imgSmoothed = imfilter(img,filter);
figure, imshow(imgSmoothed, []), title('smoothed image')

% convert to L*a*b* image (6.1b)
% (replace the following line with your code to convert the image to lab
% space
lab_cform = makecform('srgb2lab');
imglab = applycform(imgSmoothed,lab_cform);
figure, imshow(imglab, []), title('l*a*b* image')

% (6.2)
[mapMS peak] = meanshiftSeg(imglab);
visualizeSegmentationResults (mapMS,peak);

% (6.3)
% [mapEM cluster] = EM(imglab);
% visualizeSegmentationResults (mapEM,cluster);

end