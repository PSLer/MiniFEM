function hd = ShowSilhouette()
	global eleType_;
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global boundaryNodes_;
	global meshType_;
	global nelx_; global nely_; global nelz_;
	global boundingBox_;
	global carNodMapBack_;
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		if strcmp(meshType_, 'Cartesian')
			xSeed = boundingBox_(1,1):(boundingBox_(2,1)-boundingBox_(1,1))/nelx_:boundingBox_(2,1);
			ySeed = boundingBox_(2,2):(boundingBox_(1,2)-boundingBox_(2,2))/nely_:boundingBox_(1,2);	
			zSeed = boundingBox_(1,3):(boundingBox_(2,3)-boundingBox_(1,3))/nelz_:boundingBox_(2,3);		
			nodPosX = reshape(repmat(xSeed,nely_+1,1), (nelx_+1)*(nely_+1), 1); nodPosX = repmat(nodPosX, (nelz_+1), 1);
			nodPosX = reshape(nodPosX, nely_+1, nelx_+1, nelz_+1);
			nodPosY = repmat(repmat(ySeed,1,nelx_+1 )', (nelz_+1), 1);
			nodPosY = reshape(nodPosY, nely_+1, nelx_+1, nelz_+1);
			nodPosZ = reshape(repmat(zSeed,(nelx_+1)*(nely_+1),1), (nelx_+1)*(nely_+1)*(nelz_+1), 1);
			nodPosZ = reshape(nodPosZ, nely_+1, nelx_+1, nelz_+1);
			valForExtctBoundary = zeros((nelx_+1)*(nely_+1)*(nelz_+1),1); valForExtctBoundary(carNodMapBack_) = 1;
			valForExtctBoundary = reshape(valForExtctBoundary, nely_+1, nelx_+1, nelz_+1);
			hd(1) = patch(isosurface(nodPosX, nodPosY, nodPosZ, valForExtctBoundary, 0)); hold on
			hd(2) = patch(isocaps(nodPosX, nodPosY, nodPosZ, valForExtctBoundary, 0)); hold on			
		else
			if strcmp(eleType_.eleName, 'Solid144')
				patchIndices = eNodMat_(:, [1 2 3  1 2 4  2 3 4  3 1 4])'; %% need to be verified
				patchIndices = reshape(patchIndices(:), 3, 4*numEles_);		
				numNodsEleFace = 3;
			else
				patchIndices = eNodMat_(:, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
				patchIndices = reshape(patchIndices(:), 4, 6*numEles_);
				numNodsEleFace = 4;
			end
			tmp = zeros(numNodes_,1); tmp(boundaryNodes_) = 1;
			tmp = tmp(patchIndices); tmp = sum(tmp,1);
			boundaryEleFaces = patchIndices(:,find(numNodsEleFace==tmp));
			xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(boundaryEleFaces);
			yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(boundaryEleFaces);
			zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(boundaryEleFaces);
			cPatchs = zeros(size(xPatchs));				
			hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on;			
		end
		camproj('perspective');
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 0.3, 'EdgeColor', 'None');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		view(3);
		lighting gouraud;
		camlight('headlight','infinite');
		% %camlight('right','infinite');
		% camlight('left','infinite');
        material dull; %% dull, shiny, metal		
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		if strcmp(eleType_.eleName, 'Plane133')
			edgeIndices = eNodMat_(:, [1 2 2 1  2 3 3 2  3 1 1 3])';
			edgeIndices = reshape(edgeIndices(:), 4, 3*numEles_);			
		else
			edgeIndices = eNodMat_(:, [1 2 2 1  2 3 3 2  3 4 4 3  4 1 1 4])';
			edgeIndices = reshape(edgeIndices(:), 4, 4*numEles_);		
		end
		tmp = zeros(size(nodeCoords_,1),1); tmp(boundaryNodes_) = 1;
		tmp = tmp(edgeIndices); tmp = sum(tmp,1);
		boundaryEleEdges = edgeIndices(:,find(4==tmp));
		xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(boundaryEleEdges);
		yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(boundaryEleEdges);		
		cPatchs = zeros(size(yPatchs));
		hd = patch(xPatchs, yPatchs, cPatchs); hold on;
		set(hd, 'FaceColor', 'None', 'EdgeColor', DelightfulColors('Default'), 'LineWidth', 2);
		xlabel('X'); ylabel('Y');
	else
		xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(eNodMat_');
		yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(eNodMat_');
		zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(eNodMat_');
		cPatchs = zeros(size(yPatchs));
		hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on;	
		camproj('perspective');
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 0.3, 'EdgeColor', 'None');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		[az, el] = view(3);
		lighting gouraud;
		camlight(az,el);
		% camlight('headlight','infinite');
		% %camlight('right','infinite');
		% camlight('left','infinite');
        material dull; %% dull, shiny, metal			
	end
	axis equal; axis tight; axis on;
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);	
end