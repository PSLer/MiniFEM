function hd = ShowElements(varargin)
	global eleType_;
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global boundaryNodes_;
	if 0==nargin, eleList = (1:numEles_)'; else, eleList = varargin{1}; eleList = eleList(:); end
	if isempty(eleList), warning('No Element to be Shown!'); return; end
	numEleToBeShown = length(eleList);
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		showAllMesh = 0;
		if strcmp(eleType_.eleName, 'Solid144')
			patchIndices = eNodMat_(eleList, [1 2 3  1 2 4  2 3 4  3 1 4])'; %% need to be verified
			patchIndices = reshape(patchIndices(:), 3, 4*numEleToBeShown);		
		else
			patchIndices = eNodMat_(eleList, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
			patchIndices = reshape(patchIndices(:), 4, 6*numEleToBeShown);
		end
		xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(patchIndices);
		yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(patchIndices);
		zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(patchIndices);
		cPatchs = zeros(size(xPatchs));				
		hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on;
		xlabel('X'); ylabel('Y'); zlabel('Z');
		[az, el] = view(3);
		lighting gouraud;
		camlight(az,el)
		% camlight('headlight','infinite');
		% %camlight('right','infinite');
		% camlight('left','infinite');
        material dull; %% dull, shiny, metal		
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(eNodMat_(eleList,:)');
		yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(eNodMat_(eleList,:)');
		cPatchs = zeros(size(yPatchs));
		hd = patch(xPatchs, yPatchs, cPatchs); hold on;
		xlabel('X'); ylabel('Y');
	else
		xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(eNodMat_(eleList,:)');
		yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(eNodMat_(eleList,:)');
		zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(eNodMat_(eleList,:)');
		cPatchs = zeros(size(yPatchs));
		hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on;
		xlabel('X'); ylabel('Y'); zlabel('Z');
		[az, el] = view(3);
		lighting gouraud;
		camlight(az,el)
		% camlight('headlight','infinite');
		% %camlight('right','infinite');
		% camlight('left','infinite');
        material dull; %% dull, shiny, metal			
	end
	set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'k');
	axis equal; axis tight; axis on;
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);	
end