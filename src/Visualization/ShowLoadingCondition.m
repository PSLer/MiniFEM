function ShowLoadingCondition(varargin)
	global eleType_;
	global nodeCoords_;
	global loadingCond_;
	global boundingBox_;
	if 0==nargin
		loadingCondToBeShow = loadingCond_;
	else
		loadingCondToBeShow = varargin{1};
    end
	if strcmp(eleType_.eleName, 'Beam123')
		loadingCondToBeShow(:,5:end) = [];
	elseif strcmp(eleType_.eleName, 'Beam122')
		loadingCondToBeShow(:,4:end) = [];
	end
    if isempty(loadingCondToBeShow), return; end
    lB = 0.2;
    uB = 1.0;
    amps = vecnorm(loadingCondToBeShow(:,2:end),2,2);
    maxAmp = max(amps);
    minAmp = min(amps);
    if abs(minAmp-maxAmp)/(minAmp+maxAmp)<0.1
        scalingFac = 1;
    else
        if minAmp/maxAmp>lB/uB, lB = minAmp/maxAmp; end
        scalingFac = lB + (uB-lB)*(amps-minAmp)/(maxAmp-minAmp);
    end
    loadingDirVec = loadingCondToBeShow(:,2:end)./amps.*scalingFac;
    coordLoadedNodes = nodeCoords_(loadingCondToBeShow(:,1),:);
    amplitudesF = mean(boundingBox_(2,:)-boundingBox_(1,:))/5 * loadingDirVec;
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188') || ...
			strcmp(eleType_.eleName, 'Truss123') ||  strcmp(eleType_.eleName, 'Beam123')
		hold('on'); quiver3(coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), amplitudesF(:,1), ...
			amplitudesF(:,2), amplitudesF(:,3), 0, 'Color', [255 127 0.0]/255, 'LineWidth', 2, 'MaxHeadSize', 1, 'MaxHeadSize', 1); 	
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144') || ...
			strcmp(eleType_.eleName, 'Truss122') ||  strcmp(eleType_.eleName, 'Beam122')
		hold('on'); quiver(coordLoadedNodes(:,1), coordLoadedNodes(:,2), amplitudesF(:,1), ...
			amplitudesF(:,2), 0, 'Color', [255 127 0.0]/255, 'LineWidth', 2, 'MaxHeadSize', 1, 'MaxHeadSize', 1); 	
	else
		%% Need to figure out a way to show torque
		hold('on'); quiver3(coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), amplitudesF(:,1), ...
			amplitudesF(:,2), amplitudesF(:,3), 0, 'Color', [255 127 0.0]/255, 'LineWidth', 2, 'MaxHeadSize', 1, 'MaxHeadSize', 1); 			
	end
end