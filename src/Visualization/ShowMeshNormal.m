function ShowMeshNormal()
	global eleType_;
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global boundaryNodes_;
	global boundingBox_;
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		warning('Only Work with 3D meshes!'); return;
	end
	figure;
	normalFeatureSize = min(boundingBox_(2,:)-boundingBox_(1,:))/20;
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		tmp = zeros(numNodes_,1); tmp(boundaryNodes_) = 1;
		if strcmp(eleType_.eleName, 'Solid144')
			patchIndices = eNodMat_(:, [1 2 3  1 2 4  2 3 4  3 1 4])'; %% need to be verified
			patchIndices = reshape(patchIndices(:), 3, 4*numEles_);				
			tmp = tmp(patchIndices); tmp = sum(tmp,1);
			boundaryEleFaces = patchIndices(:,find(3==tmp));
			xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(boundaryEleFaces);
			yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(boundaryEleFaces);
			zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(boundaryEleFaces);	
			ACs = [xPatchs(1,:)-xPatchs(2,:); yPatchs(1,:)-yPatchs(2,:); zPatchs(1,:)-zPatchs(2,:)];
			BDs = [xPatchs(1,:)-xPatchs(3,:); yPatchs(1,:)-yPatchs(3,:); zPatchs(1,:)-zPatchs(3,:)];
			iACxBD = cross(ACs',BDs'); 
			aveNormal = iACxBD ./ vecnorm(iACxBD,2,2) * normalFeatureSize;
			ctrCoords = [sum(xPatchs,1); sum(yPatchs,1); sum(zPatchs,1)]' / 3;					
		else
			patchIndices = eNodMat_(:, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
			patchIndices = reshape(patchIndices(:), 4, 6*numEles_);
			tmp = tmp(patchIndices); tmp = sum(tmp,1);
			boundaryEleFaces = patchIndices(:,find(4==tmp));
			xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(boundaryEleFaces);
			yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(boundaryEleFaces);
			zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(boundaryEleFaces);	
			ACs = [xPatchs(1,:)-xPatchs(3,:); yPatchs(1,:)-yPatchs(3,:); zPatchs(1,:)-zPatchs(3,:)];
			BDs = [xPatchs(2,:)-xPatchs(4,:); yPatchs(2,:)-yPatchs(4,:); zPatchs(2,:)-zPatchs(4,:)];
			iACxBD = cross(ACs',BDs'); 
			aveNormal = iACxBD ./ vecnorm(iACxBD,2,2) * normalFeatureSize;
			ctrCoords = [sum(xPatchs,1); sum(yPatchs,1); sum(zPatchs,1)]' / 4;
		end
		cPatchs = zeros(size(xPatchs));	
		hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on;
		hdNormal = quiver3(ctrCoords(:,1), ctrCoords(:,2), ctrCoords(:,3), aveNormal(:,1), aveNormal(:,2), aveNormal(:,3));	
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(eNodMat_');
		yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(eNodMat_');
		zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(eNodMat_');
		if strcmp(eleType_.eleName, 'Shell133')
			ACs = [xPatchs(1,:)-xPatchs(2,:); yPatchs(1,:)-yPatchs(2,:); zPatchs(1,:)-zPatchs(2,:)];
			BDs = [xPatchs(1,:)-xPatchs(3,:); yPatchs(1,:)-yPatchs(3,:); zPatchs(1,:)-zPatchs(3,:)];
			iACxBD = cross(ACs',BDs'); 
			aveNormal = iACxBD ./ vecnorm(iACxBD,2,2) * normalFeatureSize;
			ctrCoords = [sum(xPatchs,1); sum(yPatchs,1); sum(zPatchs,1)]' / 3;				
		else
			ACs = [xPatchs(1,:)-xPatchs(3,:); yPatchs(1,:)-yPatchs(3,:); zPatchs(1,:)-zPatchs(3,:)];
			BDs = [xPatchs(2,:)-xPatchs(4,:); yPatchs(2,:)-yPatchs(4,:); zPatchs(2,:)-zPatchs(4,:)];
			iACxBD = cross(ACs',BDs'); 
			aveNormal = iACxBD ./ vecnorm(iACxBD,2,2) * normalFeatureSize;
			ctrCoords = [sum(xPatchs,1); sum(yPatchs,1); sum(zPatchs,1)]' / 4;		
		end	
		cPatchs = zeros(size(yPatchs));
		hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on;
		hdNormal = quiver3(ctrCoords(:,1), ctrCoords(:,2), ctrCoords(:,3), aveNormal(:,1), aveNormal(:,2), aveNormal(:,3));	
	end
	camproj('perspective');
	[az, el] = view(3);
	lighting gouraud;
	camlight(az,el);
	% camlight('headlight','infinite');
	% %camlight('right','infinite');
	% camlight('left','infinite');
    material dull; %% dull, shiny, metal		
	xlabel('X'); ylabel('Y'); zlabel('Z');
	set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'k');
	set(hdNormal, 'LineWidth', 0.5, 'Color', 'r', 'MaxHeadSize', 0.5);
	axis equal; axis tight; axis on;
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);	
end