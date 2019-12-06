clear;

data = load('dataset.mat');
objects = data.objects;

% Dataset Desciption
% 1-5 Heart
% 6-10 Fork
% 11-15 Watch

% examples
idx_template=2;
idx_target=1;

Point2D_template=objects(idx_template).X;
Point2D_target=objects(idx_target).X;
img_template=objects(idx_template).img;
img_target=objects(idx_target).img;

figure(8)
subplot(1,2,1)
imshow(img_template);
title('Template Image')
subplot(1,2,2)
imshow(img_target);
title('Target Image')

sample_num=1000;
Point2D_template_down=downsample(Point2D_template,sample_num);
Point2D_target_down=downsample(Point2D_target,sample_num);

display_or_not=1;
%matchingCost2=shape_matching_bak(Point2D_template_down,Point2D_target_down,display_or_not);
matchingCost=shape_matching(Point2D_template_down,Point2D_target_down,display_or_not);