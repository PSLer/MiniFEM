function ShowLoadingConditionBy3Darrowheads(nodeForces, colorOpt, shiftingOpt, radiusScalingFac, varargin)
	%%1. initialize arguments
	global eleType_;
	global boundingBox_;
	global nodeCoords_;
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		warning('This function only works for 3D!'); return; 
	end
	samplingSpace = 1;
	if 5==nargin, samplingSpace = max(1, round(varargin{1})); end
	numVecs = size(nodeForces,1);

	arrowLength = min(boundingBox_(2,:)-boundingBox_(1,:))/4;
	lineWidth = arrowLength/10*radiusScalingFac;
	head_frac = 0.6; radii = lineWidth/2; radii2 = 2*radii;
	
	%%2. Initialize info for arrow head
	nodeForces(:,2:4) = nodeForces(:,2:4) ./ vecnorm(nodeForces(:,2:4),2,2);
	arrows_X = []; arrows_Y = []; arrows_Z = [];
	for jj=1:samplingSpace:numVecs
		iForce = nodeForces(jj,:);
		iDir = iForce(2:end)*arrowLength;	
		startPots = nodeCoords_(iForce(1),:);	
		if shiftingOpt
			startPots = startPots - iDir;
		end
		XYZ = startPots + iDir;	
		arrows_X(end+1,1) = startPots(1); arrows_X(end,2) = XYZ(1);
		arrows_Y(end+1,1) = startPots(2); arrows_Y(end,2) = XYZ(2); 
		arrows_Z(end+1,1) = startPots(3); arrows_Z(end,2) = XYZ(3); 					
	end
	
	%% draw arrow heads
	hold on;
	hArrowHead = DrawArrowHeads3D(arrows_X, arrows_Y, arrows_Z, head_frac, radii, radii2);
	set(hArrowHead, 'FaceColor', colorOpt, 'EdgeColor', 'none');
end