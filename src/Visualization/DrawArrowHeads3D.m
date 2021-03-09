function h = DrawArrowHeads3D(coordX, coordY, coordZ, head_frac, radii, radii2)
%
% The function plotting 3-dimensional arrow
%
% h=arrow3d(x,y,z,head_frac,radii,radii2,colr)
%
% The inputs are:
%       coordX,coordY,coordZ =  vectors of the starting point and the ending point of the
%           arrow, e.g.:  x=[x_start, x_end]; y=[y_start, y_end];z=[z_start,z_end];
%       head_frac = fraction of the arrow length where the head should  start
%       radii = radius of the arrow
%       radii2 = radius of the arrow head (defult = radii*2)
%       colr =   color of the arrow, can be string of the color name, or RGB vector  (default='blue')
%
% The output is the handle of the surfaceplot graphics object.
% The settings of the plot can changed using: set(h, 'PropertyName', PropertyValue)
%
  
% Originally written by Moshe Lindner , Bar-Ilan University, Israel.
% July 2010 (C)


if nargin==3, radii2=radii*2; end
numArrowHead = size(coordX,1);

patchX = []; patchY = []; patchZ = [];
for ii=1:1:numArrowHead
	[X1 Y1 Z1] = arrow3d(coordX(ii,:),coordY(ii,:),coordZ(ii,:),head_frac,radii,radii2);
	dim1 = size(X1);
	patchX(end+1:end+dim1(1),:) = X1;
	patchY(end+1:end+dim1(1),:) = Y1;
	patchZ(end+1:end+dim1(1),:) = Z1;	
end
h=surf(patchX,patchY,patchZ,'edgecolor','none');
% camlight
% lighting phong