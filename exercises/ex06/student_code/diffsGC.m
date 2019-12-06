function diffs = diffsGC(img1, img2, dispRange)

% diffs should be image_size * disp_range_size
% get data costs for graph cut
box_size = 20;
diffs = zeros(size(img1,1),size(img1,2),length(dispRange));

%create average filter
average_filter = fspecial('average',box_size);

for d=dispRange
    %Shift image by d and compute image difference (SSD)
    cur_diff_img = (img1 - shiftImage(img2,d)).^2; 
    
    %Apply average filter
    diffs(:,:,d-dispRange(1)+1) = conv2(cur_diff_img,average_filter,'same');
end

end