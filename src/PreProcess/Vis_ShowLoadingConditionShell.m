function hd = Vis_ShowLoadingConditionShell(axHandle, iLoadingVec)
	global simMesh_;
	global boundingBox_;

	if isempty(iLoadingVec), hd = []; return; end
	lB = 0.2;
	uB = 1.0;
	scalingFac = 1;
	coordLoadedNodes = simMesh_(1).nodeCoords(iLoadingVec(:,1),:);
	amps = vecnorm(iLoadingVec(:,2:4),2,2)';
	hold(axHandle, 'on');
	if 0==max(amps) && 0==min(amps)
		hd = plot3(axHandle, coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), 'o', 'Color', [112 48 160]/255, 'LineWidth', 1, 'MarkerSize', 6);			
	else
		maxAmp = max(amps);
		minAmp = min(amps);
		if abs(minAmp-maxAmp)/(minAmp+maxAmp)>0.1
			if minAmp/maxAmp>lB/uB, lB = minAmp/maxAmp; end
			scalingFac = lB + (uB-lB)*(amps-minAmp)/(maxAmp-minAmp);
		end	 
		loadingDirVec = iLoadingVec(:,2:4)./amps(:) .* scalingFac(:);
		amplitudesF = mean(boundingBox_(2,:)-boundingBox_(1,:))/5 * loadingDirVec; 
		hd = quiver3(axHandle, coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), amplitudesF(:,1), ...
			amplitudesF(:,2), amplitudesF(:,3), 0, 'Color', [255 127 0.0]/255, 'LineWidth', 2, 'MaxHeadSize', 1, 'MaxHeadSize', 1);		
	end
end