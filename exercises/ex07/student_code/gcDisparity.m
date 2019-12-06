function L = gcDisparity(imgL, imgR, dispRange)
    % minimize energy function (data cost + smooth cost)
    % data cost: for each pixel, the data cost is the square of distance
    % between gray value of the pixel and the shifted pixel (by disparity)
    % in another image.
    % smooth cost: for each neighbor pixel pair, if their label (disparity)
    % is different, then add the penalty. If their label is the same, then
    % this term for this pixel pair should be zero.
    
    imgL = im2single(imgL);
    imgR = im2single(imgR);

    % find data costs
    %% <<< ----------
    Dc = diffsGC(imgL, imgR, dispRange);

    k = size(Dc,3);
    Sc = ones(k) - eye(k);

    % spatial variation cost. You may tune the size and sigma of filter to
    % improve performance
    filter_kernel_size=15;
    [Hc Vc] = gradient(imfilter(imgL,fspecial('gauss',[filter_kernel_size filter_kernel_size]),'symmetric'));

    gch = GraphCut('open', 1000*Dc, 5*Sc, exp(-Vc*5), exp(-Hc*5));

    [gch L] = GraphCut('expand',gch);
    gch = GraphCut('close', gch);
end
