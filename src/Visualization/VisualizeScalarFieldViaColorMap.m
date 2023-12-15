function VisualizeScalarFieldViaColorMap(srcField, varargin)
	global eleType_;
	global numNodes_;
	global nodeCoords_;
	global eNodMat_;
	global U_;
	global diameterList_;
	global boundingBox_;
	global boundaryFaceNodMat_;
	if 2==nargin
		scalingFac = varargin{1};
	else
		minFeaterSize = min(boundingBox_(2,:)-boundingBox_(1,:)); selfFac = 10;
		scalingFac = minFeaterSize/selfFac/max(abs(U_));
	end
	exaggeratedDispDeviation = scalingFac*U_;
	exaggeratedDispDeviation = reshape(exaggeratedDispDeviation, eleType_.nEleNodeDOFs, numNodes_)';
	figure;
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		meshCoords = exaggeratedDispDeviation + nodeCoords_;
		xPatchs = meshCoords(:,1); xPatchs = xPatchs(boundaryFaceNodMat_');
		yPatchs = meshCoords(:,2); yPatchs = yPatchs(boundaryFaceNodMat_');
		zPatchs = meshCoords(:,3); zPatchs = zPatchs(boundaryFaceNodMat_');	
		cPatchs = srcField(boundaryFaceNodMat_');				
		hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold('on');
		view(3); camproj('perspective');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		lighting('gouraud');
		camlight('headlight','infinite');
        material('dull'); %% dull, shiny, metal		
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		meshCoords = exaggeratedDispDeviation + nodeCoords_;
		xPatchs = meshCoords(:,1); xPatchs = xPatchs(eNodMat_');
		yPatchs = meshCoords(:,2); yPatchs = yPatchs(eNodMat_');
		cPatchs = srcField(eNodMat_');
		hd = patch(xPatchs, yPatchs, cPatchs); hold('on');
		xlabel('X'); ylabel('Y');
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		meshCoords = exaggeratedDispDeviation(:,[1 2 3]) + nodeCoords_;
		xPatchs = meshCoords(:,1); xPatchs = xPatchs(eNodMat_');
		yPatchs = meshCoords(:,2); yPatchs = yPatchs(eNodMat_');
		zPatchs = meshCoords(:,3); zPatchs = zPatchs(eNodMat_');
		cPatchs = srcField(eNodMat_');
		hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold('on');
		view(3); camproj('perspective');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		lighting('gouraud');
		camlight('headlight','infinite');
        material('dull'); %% dull, shiny, metal	
	elseif strcmp(eleType_.eleName, 'Truss122') || strcmp(eleType_.eleName, 'Beam122')
		if strcmp(eleType_.eleName, 'Beam122')
			exaggeratedDispDeviation = exaggeratedDispDeviation(:,[1 2]);		
		end
		meshCoords = exaggeratedDispDeviation + nodeCoords_;
		xPatchs = meshCoords(:,1); xPatchs = xPatchs(eNodMat_');
		yPatchs = meshCoords(:,2); yPatchs = yPatchs(eNodMat_');
		cPatchs = srcField(eNodMat_');
		hd = patch(xPatchs, yPatchs, cPatchs); hold('on');
		xlabel('X'); ylabel('Y');		
	elseif strcmp(eleType_.eleName, 'Truss123') || strcmp(eleType_.eleName, 'Beam123')
		if strcmp(eleType_.eleName, 'Beam123')
			exaggeratedDispDeviation = exaggeratedDispDeviation(:,[1 2 3]);
		end
		meshCoords = exaggeratedDispDeviation + nodeCoords_;
		[gridX, gridY, gridZ, gridC] = Extend3DMeshEdges2Tubes(meshCoords, eNodMat_, diameterList_, srcField);
		hd = surf(gridX, gridY, gridZ, gridC);
		view(3); camproj('perspective');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		lighting('gouraud');
		camlight('headlight','infinite');
        material('dull'); %% dull, shiny, metal			
	end
	colormap('jet')
	if strcmp(eleType_.eleName, 'Truss122') || strcmp(eleType_.eleName, 'Beam122')
		set(hd, 'FaceColor', 'None', 'EdgeColor', 'Interp');
	else
		set(hd, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
	end
	h = colorbar; t=get(h,'Limits'); 
	colorbarIntervals = 7;
	set(h,'Ticks',linspace(t(1),t(2),colorbarIntervals),'AxisLocation','out');	
	L=cellfun(@(x)sprintf('%.2e',x),num2cell(linspace(t(1),t(2),colorbarIntervals)),'Un',0); 
	set(h,'xticklabel',L);		
	axis('equal'); axis('tight'); axis('off');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);	
end