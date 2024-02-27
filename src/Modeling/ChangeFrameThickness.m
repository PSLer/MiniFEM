function ChangeFrameThickness(scalingCurrentDiameter)
	global eleType_;
	global boundingBox_;
	global numEles_;
	global eNodMat_;
	global numNodes_;
	global nodeCoords_;
	global numNodsAroundEleVec_;
	global diameterList_;
	global eleCrossSecAreaList_;
	
	if strcmp(eleType_.eleName, 'Truss123') || strcmp(eleType_.eleName, 'Beam123')
		diameterList_ = scalingCurrentDiameter * diameterList_;
		eleLengthList_ = vecnorm(nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,1),:),2,2);
		eleCrossSecAreaList_ = pi/2 * (diameterList_/2).^2;
		iSphereVolume = 4/3*pi*(sum(diameterList_)/numEles_/2)^3/2;
		frameVolume = pi/4 * (eleLengthList_(:)' * diameterList_.^2) - (sum(numNodsAroundEleVec_)-numNodes_)*iSphereVolume;
		disp(['Frame Volume: ', sprintf('%.6f', frameVolume)]);
		
		%%Vis.
		figure;
		[gridX, gridY, gridZ, gridC] = Extend3DMeshEdges2Tubes(nodeCoords_, eNodMat_, diameterList_);
		hd = surf(gridX, gridY, gridZ, gridC);
		axis('equal'); axis('tight'); axis('on');
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		view(3); 
		camproj('perspective');
		lighting('gouraud');
		material('dull'); %%shiny; dull; metal	
		camlight('headlight','infinite');		
	elseif strcmp(eleType_.eleName, 'Truss122') || strcmp(eleType_.eleName, 'Beam122')
	
	end		
end