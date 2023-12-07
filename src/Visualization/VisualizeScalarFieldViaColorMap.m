function VisualizeScalarFieldViaColorMap(srcField, varargin)
	global eleType_;
	global numNodes_;
	global nodeCoords_;
	global eNodMat_;
	global U_;
	global boundingBox_;
	global boundaryFaceNodMat_;
	if 2==nargin
		scalingFac = varargin{1};
	else
		minFeaterSize = min(boundingBox_(2,:)-boundingBox_(1,:)); selfFac = 10;
		scalingFac = minFeaterSize/selfFac/max(abs(U_));
	end
	meshCoords = scalingFac*U_;
	figure;
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		meshCoords = reshape(meshCoords, 3, numNodes_)' + nodeCoords_;
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
		meshCoords = reshape(meshCoords, 2, numNodes_)' + nodeCoords_;
		xPatchs = meshCoords(:,1); xPatchs = xPatchs(eNodMat_');
		yPatchs = meshCoords(:,2); yPatchs = yPatchs(eNodMat_');
		cPatchs = srcField(eNodMat_');
		hd = patch(xPatchs, yPatchs, cPatchs); hold('on');
		xlabel('X'); ylabel('Y');
	else
		meshCoords = reshape(meshCoords, 3, numNodes_)' + nodeCoords_;
		xPatchs = meshCoords(:,1); xPatchs = xPatchs(eNodMat_');
		yPatchs = meshCoords(:,2); yPatchs = yPatchs(eNodMat_');
		zPatchs = meshCoords(:,3); zPatchs = zPatchs(eNodMat_');
		cPatchs = srcField(eNodMat_');
		hd = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold('on');
		view(3); camproj('perspective');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		lighting('gouraud');
		camlight('headlight','infinite');
		% %camlight('right','infinite');
		% camlight('left','infinite');
        material('dull'); %% dull, shiny, metal			
	end
	colormap('jet')
	set(hd, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
	h = colorbar; t=get(h,'Limits'); 
	colorbarIntervals = 7;
	set(h,'Ticks',linspace(t(1),t(2),colorbarIntervals),'AxisLocation','out');	
	L=cellfun(@(x)sprintf('%.2e',x),num2cell(linspace(t(1),t(2),colorbarIntervals)),'Un',0); 
	set(h,'xticklabel',L);		
	axis equal; axis tight; axis off;
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);	
end