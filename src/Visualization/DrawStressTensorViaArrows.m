function DrawStressTensorViaArrows(locationList, cartesianStressList)
	global eleType_;
	global boundingBox_;
	global nodeCoords_;
	global boundaryFaceNodMat_;
	if ~(strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188'))
		return;
	end
	eleSize_ = min(boundingBox_(2,:) - boundingBox_(1,:))/20;
	if isempty(locationList), return; end
	principalStressList = ComputePrincipalStress(cartesianStressList);
	
	%%2. Initialize Tensor Arrows
	userLW = 0.25;
	lineWidth = userLW * eleSize_;
	head_frac = 0.6; radii = lineWidth/3; radii2 = 2*radii; arrowLength = 5*lineWidth;
	arrowsMajor_X = []; arrowsMajor_Y = []; arrowsMajor_Z = [];
	arrowsMedium_X = []; arrowsMedium_Y = []; arrowsMedium_Z = [];	
	arrowsMinor_X = []; arrowsMinor_Y = []; arrowsMinor_Z = [];
	for jj=1:size(locationList,1)
		iTensor = principalStressList(jj,:);
		iCtr = locationList(jj,:);
		iAmp = abs(iTensor([1 5 9]));
		iAmp = iAmp/max(iAmp); iAmp(iAmp<0.3) = 0.3;
		
		dirVecMajor = iTensor([10 11 12]); dirVecMajor = iAmp(3)*dirVecMajor*arrowLength;
		XYZ = iCtr + dirVecMajor;
		arrowsMajor_X(end+1,1) = iCtr(1); arrowsMajor_X(end,2) = XYZ(1);
		arrowsMajor_Y(end+1,1) = iCtr(2); arrowsMajor_Y(end,2) = XYZ(2); 
		arrowsMajor_Z(end+1,1) = iCtr(3); arrowsMajor_Z(end,2) = XYZ(3); 			
		XYZ = iCtr - dirVecMajor;
		arrowsMajor_X(end+1,1) = iCtr(1); arrowsMajor_X(end,2) = XYZ(1);
		arrowsMajor_Y(end+1,1) = iCtr(2); arrowsMajor_Y(end,2) = XYZ(2); 
		arrowsMajor_Z(end+1,1) = iCtr(3); arrowsMajor_Z(end,2) = XYZ(3);
		
		dirVecMedium = iTensor([6 7 8]); dirVecMedium = iAmp(2)*dirVecMedium*arrowLength;
		XYZ = iCtr + dirVecMedium;
		arrowsMedium_X(end+1,1) = iCtr(1); arrowsMedium_X(end,2) = XYZ(1);
		arrowsMedium_Y(end+1,1) = iCtr(2); arrowsMedium_Y(end,2) = XYZ(2); 
		arrowsMedium_Z(end+1,1) = iCtr(3); arrowsMedium_Z(end,2) = XYZ(3); 			
		XYZ = iCtr - dirVecMedium;
		arrowsMedium_X(end+1,1) = iCtr(1); arrowsMedium_X(end,2) = XYZ(1);
		arrowsMedium_Y(end+1,1) = iCtr(2); arrowsMedium_Y(end,2) = XYZ(2); 
		arrowsMedium_Z(end+1,1) = iCtr(3); arrowsMedium_Z(end,2) = XYZ(3); 

		dirVecMinor = iTensor([2 3 4]); dirVecMinor = iAmp(1)*dirVecMinor*arrowLength;
		XYZ = iCtr + dirVecMinor;
		arrowsMinor_X(end+1,1) = iCtr(1); arrowsMinor_X(end,2) = XYZ(1);
		arrowsMinor_Y(end+1,1) = iCtr(2); arrowsMinor_Y(end,2) = XYZ(2); 
		arrowsMinor_Z(end+1,1) = iCtr(3); arrowsMinor_Z(end,2) = XYZ(3); 			
		XYZ = iCtr - dirVecMinor;
		arrowsMinor_X(end+1,1) = iCtr(1); arrowsMinor_X(end,2) = XYZ(1);
		arrowsMinor_Y(end+1,1) = iCtr(2); arrowsMinor_Y(end,2) = XYZ(2); 
		arrowsMinor_Z(end+1,1) = iCtr(3); arrowsMinor_Z(end,2) = XYZ(3);		
	end
	
	%%3. Initialize Location Spheres
	seedRadius = 0.15*arrowLength;
	numSeedPoints = size(locationList,1);
	[sphereX,sphereY,sphereZ] = sphere(50);
	sphereX = seedRadius*sphereX;
	sphereY = seedRadius*sphereY;
	sphereZ = seedRadius*sphereZ;
	nn = size(sphereX,1);
	sphere_patchX = sphereX; ctrX = locationList(:,1);
	sphere_patchX = repmat(sphere_patchX, numSeedPoints, 1); ctrX = repmat(ctrX, 1, nn); ctrX = reshape(ctrX', numel(ctrX), 1);
	sphere_patchX = ctrX + sphere_patchX;
	sphere_patchY = sphereY; ctrY = locationList(:,2);
	sphere_patchY = repmat(sphere_patchY, numSeedPoints, 1); ctrY = repmat(ctrY, 1, nn); ctrY = reshape(ctrY', numel(ctrY), 1);
	sphere_patchY = ctrY + sphere_patchY;	
	sphere_patchZ = sphereZ; ctrZ = locationList(:,3);
	sphere_patchZ = repmat(sphere_patchZ, numSeedPoints, 1); ctrZ = repmat(ctrZ, 1, nn); ctrZ = reshape(ctrZ', numel(ctrZ), 1);
	sphere_patchZ = ctrZ + sphere_patchZ;
	
	%%4. Initialize Silhouette
	silhouettePatch.vertices = nodeCoords_;
	silhouettePatch.faces = boundaryFaceNodMat_;		

	%%5. Draw
	hArrowHeadMajor = DrawArrowHeads3D(arrowsMajor_X, arrowsMajor_Y, arrowsMajor_Z, head_frac, radii, radii2); hold('on');
	hArrowHeadMedium = DrawArrowHeads3D(arrowsMedium_X, arrowsMedium_Y, arrowsMedium_Z, head_frac, radii, radii2); hold('on');
	hArrowHeadMinor = DrawArrowHeads3D(arrowsMinor_X, arrowsMinor_Y, arrowsMinor_Z, head_frac, radii, radii2); hold('on');
	hSphereLocations = surf(sphere_patchX, sphere_patchY, sphere_patchZ);
	hdSilhouette = patch(silhouettePatch);
	set(hArrowHeadMajor, 'FaceColor', [252 141 98]/255, 'EdgeColor', 'none'); % [252 141 98]/255
	set(hArrowHeadMedium, 'FaceColor', [141 160 203]/255, 'EdgeColor', 'none'); % [141 160 203]/255
	set(hArrowHeadMinor, 'FaceColor', [102 194 165]/255, 'EdgeColor', 'none'); % [102 194 165]/255
	set(hSphereLocations, 'FaceColor', [0.0 0.0 1.0], 'EdgeColor', 'none');
	set(hdSilhouette, 'FaceColor', [0.5 0.5 0.5], 'FaceAlpha', 0.1, 'EdgeColor', 'none');
	lighting('gouraud');
	material('shiny');
	camlight('headlight','infinite');
	axis('equal'); axis('tight'); axis('off');
	axis('off'); xlabel('X'); ylabel('Y'); zlabel('Z');
	% set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
end

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
	
	sphere_patchX = []; sphere_patchY = []; sphere_patchZ = [];
	for ii=1:numArrowHead
		[X1, Y1, Z1] = arrow3d(coordX(ii,:),coordY(ii,:),coordZ(ii,:),head_frac,radii,radii2);
		dim1 = size(X1);
		sphere_patchX(end+1:end+dim1(1),:) = X1;
		sphere_patchY(end+1:end+dim1(1),:) = Y1;
		sphere_patchZ(end+1:end+dim1(1),:) = Z1;	
	end
	h=surf(sphere_patchX,sphere_patchY,sphere_patchZ,'edgecolor','none');
end

function [X1, Y1, Z1] = arrow3d(x,y,z,head_frac,radii,radii2)
	%
	% The function plotting 3-dimensional arrow
	%
	% h=arrow3d(x,y,z,head_frac,radii,radii2,colr)
	%
	% The inputs are:
	%       x,y,z =  vectors of the starting point and the ending point of the
	%           arrow, e.g.:  x=[x_start, x_end]; y=[y_start, y_end];z=[z_start,z_end];
	%       head_frac = fraction of the arrow length where the head should  start
	%       radii = radius of the arrow
	%       radii2 = radius of the arrow head (defult = radii*2)
	%       colr =   color of the arrow, can be string of the color name, or RGB vector  (default='blue')
	%
	% The output is the handle of the surfaceplot graphics object.
	% The settings of the plot can changed using: set(h, 'PropertyName', PropertyValue)
	%
	% example #1:
	%        arrow3d([0 0],[0 0],[0 6],.5,3,4,[1 0 .5]);
	% example #2:
	%        arrow3d([2 0],[5 0],[0 -6],.2,3,5,'r');
	% example #3:
	%        h = arrow3d([1 0],[0 1],[-2 3],.8,3);
	%        set(h,'facecolor',[1 0 0])
	% 
	% Written by Moshe Lindner , Bar-Ilan University, Israel.
	% July 2010 (C)
	
	if nargin==5
		radii2=radii*2;
		colr='blue';
	elseif nargin==6
		colr='blue';
	end
	if size(x,1)==2
		x=x';
		y=y';
		z=z';
	end
	
	x(3)=x(2);
	x(2)=x(1)+head_frac*(x(3)-x(1));
	y(3)=y(2);
	y(2)=y(1)+head_frac*(y(3)-y(1));
	z(3)=z(2);
	z(2)=z(1)+head_frac*(z(3)-z(1));
	r=[x(1:2)',y(1:2)',z(1:2)'];
	
	N=50;
	dr=diff(r);
	dr(end+1,:)=dr(end,:);
	origin_shift=(ones(size(r))*(1+max(abs(r(:))))+[dr(:,1) 2*dr(:,2) -dr(:,3)]);
	r=r+origin_shift;
	
	normdr=(sqrt((dr(:,1).^2)+(dr(:,2).^2)+(dr(:,3).^2)));
	normdr=[normdr,normdr,normdr];
	dr=dr./normdr;
	Pc=r;
	n1=cross(dr,Pc);
	normn1=(sqrt((n1(:,1).^2)+(n1(:,2).^2)+(n1(:,3).^2)));
	normn1=[normn1,normn1,normn1];
	n1=n1./normn1;
	P1=n1+Pc;
	
	X1=[];Y1=[];Z1=[];
	j=1;
	for theta=([0:N])*2*pi./(N)
		R1=Pc+radii*cos(theta).*(P1-Pc) + radii*sin(theta).*cross(dr,(P1-Pc)) -origin_shift;
		X1(2:3,j)=R1(:,1);
		Y1(2:3,j)=R1(:,2);
		Z1(2:3,j)=R1(:,3);
		j=j+1;
	end
	
	r=[x(2:3)',y(2:3)',z(2:3)'];
	
	dr=diff(r);
	dr(end+1,:)=dr(end,:);
	origin_shift=(ones(size(r))*(1+max(abs(r(:))))+[dr(:,1) 2*dr(:,2) -dr(:,3)]);
	r=r+origin_shift;
	
	normdr=(sqrt((dr(:,1).^2)+(dr(:,2).^2)+(dr(:,3).^2)));
	normdr=[normdr,normdr,normdr];
	dr=dr./normdr;
	Pc=r;
	n1=cross(dr,Pc);
	normn1=(sqrt((n1(:,1).^2)+(n1(:,2).^2)+(n1(:,3).^2)));
	normn1=[normn1,normn1,normn1];
	n1=n1./normn1;
	P1=n1+Pc;
	
	j=1;
	for theta=([0:N])*2*pi./(N)
		R1=Pc+radii2*cos(theta).*(P1-Pc) + radii2*sin(theta).*cross(dr,(P1-Pc)) -origin_shift;
		X1(4:5,j)=R1(:,1);
		Y1(4:5,j)=R1(:,2);
		Z1(4:5,j)=R1(:,3);
		j=j+1;
	end
	
	X1(1,:)=X1(1,:)*0 + x(1);
	Y1(1,:)=Y1(1,:)*0 + y(1);
	Z1(1,:)=Z1(1,:)*0 + z(1);
	X1(5,:)=X1(5,:)*0 + x(3);
	Y1(5,:)=Y1(5,:)*0 + y(3);
	Z1(5,:)=Z1(5,:)*0 + z(3);

	% h=surf(X1,Y1,Z1,'facecolor',colr,'edgecolor','none');
	% camlight
	% lighting phong
end
