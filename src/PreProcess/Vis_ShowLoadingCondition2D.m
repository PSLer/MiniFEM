function hd = Vis_ShowLoadingCondition2D(axHandle, iLoadingVec)
	global surfMesh_;
	global boundingBox_;

	if isempty(iLoadingVec), hd = []; return; end
	lB = 0.2;
	uB = 1.0;
	scalingFac = 1;
	amps = vecnorm(iLoadingVec(:,2:end),2,2)';
	maxAmp = max(amps);
	minAmp = min(amps);
	if abs(minAmp-maxAmp)/(minAmp+maxAmp)>0.1
		if minAmp/maxAmp>lB/uB, lB = minAmp/maxAmp; end
		scalingFac = lB + (uB-lB)*(amps-minAmp)/(maxAmp-minAmp);
	end	 
	loadingDirVec = iLoadingVec(:,2:end)./amps(:) .* scalingFac(:);
	coordLoadedNodes = surfMesh_(1).nodeCoords(iLoadingVec(:,1),:);
	amplitudesF = mean(boundingBox_(2,:)-boundingBox_(1,:))/5 * loadingDirVec;
	hold(axHandle, 'on'); 
	hd = quiver(axHandle, coordLoadedNodes(:,1), coordLoadedNodes(:,2), amplitudesF(:,1), ...
		amplitudesF(:,2), 0, 'Color', [255 127 0.0]/255, 'LineWidth', 2, 'MaxHeadSize', 1, 'MaxHeadSize', 1);	
end