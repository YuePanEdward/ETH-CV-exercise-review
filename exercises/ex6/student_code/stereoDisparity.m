function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked

img1 = double(img1);
img2 = double(img2);

box_size = 15;

%create filter
average_filter = fspecial('average',box_size); % average filter

% initialization
smallest_dif=realmax;
cur_dis_img=ones(size(img1))*realmax;

for shift_d = dispRange  
    %Shift image by d and calculate image difference (SSD) 
    %img_dif = (img1 - shiftImage(img2,shift_d)).^2; 
    
    %Or calculate image difference (SAD) 
    img_dif = abs(img1 - shiftImage(img2,shift_d)); 
    
    %Apply box average filter
    cur_diff = conv2(img_dif,average_filter,'same');
    
    %Remember best disparity for each pixel
    win_mat = cur_diff < smallest_dif;
    lose_mat = cur_diff >= smallest_dif;
        
    % losing pixels keep the original disparity
    % wining pixels get new disparity as current shifting distance
    cur_dis_img = shift_d.*win_mat + cur_dis_img.*lose_mat; 
    % Also update the smallest difference up to now
    smallest_dif = cur_diff.*win_mat + smallest_dif.*lose_mat;
    
end

disp = cur_dis_img;

end