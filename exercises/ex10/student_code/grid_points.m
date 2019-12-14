function vPoints = grid_points(img,nPointsX,nPointsY,border)
    
    [n , m] = size(img) ;
    
    X = int32( linspace (1+border, m-border, nPointsX));
    Y = int32( linspace (1+border, n-border, nPointsY));
    
    [gridX,gridY] = meshgrid(X,Y) ;
    gridX = reshape(gridX,nPointsX*nPointsY,1) ;
    gridY = reshape(gridY,nPointsY*nPointsX,1) ;
    
    vPoints = [gridX, gridY] ; 
   

end
