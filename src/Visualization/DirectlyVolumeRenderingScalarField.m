function handleVolume = DirectlyVolumeRenderingScalarField(inVar)	
	global domainType_;
	global nodeCoords_;
	global numNodes_; 
	global patchIndices_;
	global vtxUpperBound_; global vtxLowerBound_;
	if 0==numel(patchIndices_), InitializeQuadPatchs4Rendering(); end
	if strcmp(inVar.scalingFac, 'default')
		minFeaterSize = min(vtxUpperBound_-vtxLowerBound_); selfFac = 10;
		inVar.scalingFac = minFeaterSize/selfFac/max(inVar.shiftingTerm);
	else
		if ~isscalar(inVar.scalingFac), error('Wrong scaling factor type for rendering!'); end
	end
	
	deformation = inVar.shiftingTerm * inVar.scalingFac;
	switch(domainType_)
		case '2D'
			if strcmp(inVar.eleList, 'default')
				patchsList = patchIndices_;
			elseif isnumeric(inVar.eleList)
				patchsList = patchIndices_(:,inVar.eleList(:)');
			else
				error('Failed to get the to-be-rendered volume!');
			end
			deformation = reshape(deformation, 2, numNodes_)';
			deformedCartesianGrid = nodeCoords_ + deformation;
			xPatchs = deformedCartesianGrid(:,1); xPatchs = xPatchs(patchsList);
			yPatchs = deformedCartesianGrid(:,2); yPatchs = yPatchs(patchsList);
			cPatchs = inVar.scalarFiled(patchsList);
			handleVolume = patch(xPatchs, yPatchs, cPatchs); hold on
		case '3D'
			if strcmp(inVar.eleList, 'default')
				patchsList = patchIndices_;
			elseif isnumeric(inVar.eleList)
				tmp = repmat(6*inVar.eleList(:), 1, 6) - (5:-1:0);
				tmp = reshape(tmp', numel(tmp), 1)';
				patchsList = patchIndices_(:,tmp);
			else
				error('Failed to get the to-be-rendered volume!');
			end		
			deformation = reshape(deformation, 3, numNodes_)';
			deformedCartesianGrid = nodeCoords_ + deformation;
			xPatchs = deformedCartesianGrid(:,1); xPatchs = xPatchs(patchsList);
			yPatchs = deformedCartesianGrid(:,2); yPatchs = yPatchs(patchsList);
			zPatchs = deformedCartesianGrid(:,3); zPatchs = zPatchs(patchsList);
			cPatchs = inVar.scalarFiled(patchsList);
			handleVolume = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on
			camproj('perspective'); view(inVar.viewAngle); 
	end
	
	switch inVar.dispOpt
		case 'default'
			colorbarIntervals = 7;
			colormap('jet');
			set(handleVolume, 'FaceColor', 'interp', 'FaceAlpha', 1, 'EdgeColor', 'none');
			h = colorbar; t=get(h,'Limits'); 
			set(h,'Ticks',linspace(t(1),t(2),colorbarIntervals),'AxisLocation','out');	
			L=cellfun(@(x)sprintf('%.2e',x),num2cell(linspace(t(1),t(2),colorbarIntervals)),'Un',0); 
			set(h,'xticklabel',L);			
		case 'meshWise'
			set(handleVolume, 'FaceColor',[65 174 118]/255, 'FaceAlpha', 1, 'EdgeColor', 'k');
		otherwise
			error('Wrong disp option in volume rendering!');
	end
	axis equal; axis off
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20)		
end