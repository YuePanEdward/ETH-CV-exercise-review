The following files need to be modified:

1: Line fitting with RANSAC

line_fitting\main_ransacLine.m
line_fitting\ransacLine.m

2: Fundamental matrix

epipolar_geometry\main_fMatrix.m
epipolar_geometry\fundamentalMatrix.m
epipolar_geometry\normalizePoints2d.m

3: Feature extraction and matching

epipolar_geometry\main_ransac8pF.m

4: 8-Point RANSAC

epipolar_geometry\main_ransac8pF.m
epipolar_geometry\ransac8pF.m
epipolar_geometry\distPointsLines.m
