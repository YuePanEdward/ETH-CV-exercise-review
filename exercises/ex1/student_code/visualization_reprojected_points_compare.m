function visualization_reprojected_points_compare (xy, XYZ, P_dlt,P_gold, IMG_NAME)

% Apply projection matrix P_dlt
XYZ_homogeneous=homogenization(XYZ);
xyz_projected_dlt=P_dlt*XYZ_homogeneous;

% Compute Inhomogeneous projected points 
NB_PTS=size(XYZ,2);
xy_projected_dlt=zeros(2,NB_PTS);
for i=1:NB_PTS
    xy_projected_dlt(1,i)=xyz_projected_dlt(1,i)./xyz_projected_dlt(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected_dlt(2,i)=xyz_projected_dlt(2,i)./xyz_projected_dlt(3,i); % compute inhomogeneous coordinates y=y/z 
end

% Apply projection matrix P_gold
XYZ_homogeneous=homogenization(XYZ);
xyz_projected_gold=P_gold*XYZ_homogeneous;

% Compute Inhomogeneous projected points 
NB_PTS=size(XYZ,2);
xy_projected_gold=zeros(2,NB_PTS);
for i=1:NB_PTS
    xy_projected_gold(1,i)=xyz_projected_gold(1,i)./xyz_projected_gold(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected_gold(2,i)=xyz_projected_gold(2,i)./xyz_projected_gold(3,i); % compute inhomogeneous coordinates y=y/z 
end

% Display on the calibration image
figure();
img = imread(IMG_NAME);
image(img);
hold on;
for n=1:NB_PTS
    plot(xy(1,n), xy(2,n), 'ro','linewidth',2, 'MarkerSize', 10) % clicked points 
    plot(xy_projected_dlt(1,n), xy_projected_dlt(2,n), 'gx','linewidth',2, 'MarkerSize', 10) % reprojected points (dlt)
    plot(xy_projected_gold(1,n), xy_projected_gold(2,n), 'b+','linewidth',2, 'MarkerSize', 10) % reprojected points (gold standard) 
end

hold off;
legend('Clicked points','Reprojected points (DLT)','Reprojected points (Gold Standard)')
end