function [ feature_pts,descriptor ] = filter_background( feature_pts, descriptor, filter_top_row_num  )
%FILTER_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here

filter = feature_pts(2,:) > filter_top_row_num;
feature_pts= feature_pts(:,find(filter));
descriptor = descriptor(:,find(filter));

end

