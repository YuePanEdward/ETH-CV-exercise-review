function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(0,nBins*nCellsW*nCellsH); % one histogram for each of the 16 cells
    patches = zeros(0,pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x)); 
    
    for i = 1:size(vPoints,1) % for all local feature points
        x=1 ;
        for j = -2:1
            for k = -2:1
                patch_orientation = Gdir( (vPoints(i,2)+k*h):(vPoints(i,2)+(k+1)*h-1),(vPoints(i,1)+j*w):(vPoints(i,1)+(j+1)*w-1));
                descriptors(i,x:x+7) = histcounts(patch_orientation,nBins,'BinLimits',[-pi,pi]);                                                        
                x = x+8 ;
            end
        end
        patch0=img((vPoints(i,2)-2*h):(vPoints(i,2)+ 2*h-1),(vPoints(i,1)-2 *w):(vPoints(i,1)+2*w-1));
        dimen=4*4*w*h;
        patches(i,:)=reshape(patch0,1,dimen);
    end % for all local feature points
    
end
