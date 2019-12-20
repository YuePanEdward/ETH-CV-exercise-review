function hist = color_histogram(xMin,yMin,xMax,yMax,frame,num_hist_bin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%cut the bbx if the bbx go out of the image
xMin = round(max(1,xMin));
yMin = round(max(1,yMin));
xMax = round(min(xMax,size(frame,2)));
yMax = round(min(yMax,size(frame,1)));

%divide rgb channel seperately
frame_r = frame(yMin:yMax, xMin:xMax, 1 );
frame_g = frame(yMin:yMax, xMin:xMax, 2 );
frame_b = frame(yMin:yMax, xMin:xMax, 3 );

%generate histogram
hist_r = imhist(frame_r,num_hist_bin) ;
hist_g = imhist(frame_g,num_hist_bin) ;
hist_b = imhist(frame_b,num_hist_bin) ;

hist = [hist_r ; hist_g ; hist_b] ;
% noramlization so that the bbx is cutted the histogram would still in the
% same sacle
hist = hist/sum(hist);

end


