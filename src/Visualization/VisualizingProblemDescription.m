function VisualizingProblemDescription(visType)
	global domainType_;
	switch domainType_
		case '2D'
			VisualizingProblemDescription2D(visType);
		case '3D'
			VisualizingProblemDescription3D(visType);
	end	
end

function VisualizingProblemDescription2D(visType)
	global nodeCoords_; 
	global vtxLowerBound_; global vtxUpperBound_;
	global nodeLoadVec_;
	global fixedNodes_;
	global freeNodes_;
	
	%%1. draw object
	switch visType
		case 'EleVis'		
			handlePatchs = VisualizeMeshes();
			%set(handlePatchs, 'FaceColor', [0.5 0.5 0.5], 'FaceAlpha', 1, 'EdgeColor', 'k');
		case 'NodVis'
			plot(nodeCoords_(freeNodes_,1), nodeCoords_(freeNodes_,2), ...
				'.', 'Color', [65 174 118]/255); hold on	
		case 'outlineVis'
			global nodesOutline_; 
			global numEles_;
			global eNodMat_;
			edgeIndex = zeros(4,4*numEles_);
			mapEdge2patch = [1 2 2 1; 2 3 3 2; 3 4 4 3; 4 1 1 4;]';
			for ii=1:1:numEles_
				index = (ii-1)*4;
				iEleVtx = eNodMat_(ii,:)';
				edgeIndex(:,index+1:index+4) = iEleVtx(mapEdge2patch);
			end
			tmp = zeros(size(nodeCoords_,1),1); tmp(nodesOutline_) = 1;
			tmp = tmp(edgeIndex');
			tmp = sum(tmp,2);
			BoundaryEleEdge = edgeIndex(:,find(4==tmp)');	
			xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(BoundaryEleEdge);
			yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(BoundaryEleEdge);
			cPatchs = zeros(size(xPatchs));				
			handlePatchs = patch(xPatchs, yPatchs, cPatchs); hold on
			set(handlePatchs, 'FaceColor', 'None', 'EdgeColor', [0.5 0.5 0.5], 'LineWidth', 2);
	end

	%%2. draw fixed nodes
	if ~isempty(fixedNodes_)
		plot(nodeCoords_(fixedNodes_,1), nodeCoords_(fixedNodes_,2), 'x', 'Color', ...
			[0.0 0.0 0.0], 'LineWidth', 2, 'MarkerSize', 6); hold on
	end
	
	%%3. draw force			
	if ~isempty(nodeLoadVec_)
		coordLoadedNodes = nodeCoords_(nodeLoadVec_(:,1),:); 
		amplitudesF = min(vtxUpperBound_-vtxLowerBound_)/5*nodeLoadVec_(:,2:3)./...
			vecnorm(nodeLoadVec_(:,2:3), 2, 2);
		quiver(coordLoadedNodes(:,1), coordLoadedNodes(:,2), amplitudesF(:,1), amplitudesF(:,2), 0, ...
			'Color', [1.0 0.0 0.0], 'LineWidth', 2, 'MaxHeadSize', 1); hold on
	end
	
	%%4. formulated output
	axis on; axis equal; axis tight; axis off;
	xlabel('X'); ylabel('Y');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20)
end

function VisualizingProblemDescription3D(visType)
	global nodeCoords_;
	global nelx_; global nely_; global nelz_; 
	global vtxLowerBound_; global vtxUpperBound_;
	global nodeLoadVec_;
	global fixedNodes_; 
	global freeNodes_;
	global originalValidNodeIndex_;
	global nodesOutline_;
	global modelSource_;
	
	%%1. draw object
	switch visType
		case 'EleVis'							
			handlePatchs = VisualizeMeshes();
			%set(handlePatchs, 'FaceColor', [65 174 118]/255, 'FaceAlpha', 0.05, 'EdgeColor', 'None');
			lighting gouraud
			camlight('headlight','infinite');
			%camlight('right','infinite');
			%camlight('left','infinite');				
		case 'NodVis'			
			% plot3(nodeCoords_(nodesOutline_,1), nodeCoords_(nodesOutline_,2), ...
				% nodeCoords_(nodesOutline_,3), '.', 'Color', [0.5 0.5 0.5]); hold on
			global patchIndices_;
			if 0==numel(patchIndices_), InitializeQuadPatchs4Rendering(); end
			tmp = zeros(size(nodeCoords_,1),1); tmp(nodesOutline_) = 1;
			tmp = tmp(patchIndices_');
			tmp = sum(tmp,2);
			BoundaryEleFace = patchIndices_(:,find(4==tmp)');
			xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(BoundaryEleFace);
			yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(BoundaryEleFace);
			zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(BoundaryEleFace);
			cPatchs = zeros(size(xPatchs));				
			handlePatchs = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on	
			
			set(handlePatchs, 'FaceColor', [224 223 219]/255, 'FaceAlpha', 1, 'EdgeColor', 'k'); 
			view(-1.960848849982980e+02, 1.313055949258412e+01);
			lighting gouraud
			% camlight('headlight','infinite');
			% camlight('right','infinite');
			camlight('left','infinite');
            material dull; %% dull, shiny, metal			
		case 'outlineVis'
			if strcmp(modelSource_, 'ExtMesh')
			%if 1
				global patchIndices_;
				if 0==numel(patchIndices_), InitializeQuadPatchs4Rendering(); end
				tmp = zeros(size(nodeCoords_,1),1); tmp(nodesOutline_) = 1;
				tmp = tmp(patchIndices_');
				tmp = sum(tmp,2);
				BoundaryEleFace = patchIndices_(:,find(4==tmp)');
				xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(BoundaryEleFace);
				yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(BoundaryEleFace);
				zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(BoundaryEleFace);
				cPatchs = zeros(size(xPatchs));				
				handlePatchs = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on
			else
				[nodPosX nodPosY nodPosZ] = NodalizeDesignDomain([nelx_ nely_ nelz_], ...
					[vtxLowerBound_; vtxUpperBound_], 'inGrid');	
				valForExtctBoundary = zeros((nelx_+1)*(nely_+1)*(nelz_+1),1);
				valForExtctBoundary(originalValidNodeIndex_) = 1;
				valForExtctBoundary = reshape(valForExtctBoundary, nely_+1, nelx_+1, nelz_+1);
				handlePatchs(1) = patch(isosurface(nodPosX, nodPosY, nodPosZ, ...
					valForExtctBoundary, 0)); hold on
				handlePatchs(2) = patch(isocaps(nodPosX, nodPosY, nodPosZ, ...
					valForExtctBoundary, 0)); hold on
			end		
			%% default RGB --- [65 174 118]
			%% concrete RGB --- [206 205 203]
			%% stainless steel RGB --- [224 223 219]			
			set(handlePatchs, 'FaceColor', [224 223 219]/255, 'FaceAlpha', 1, 'EdgeColor', 'None'); 
			% view(6.87e-01, 1.13e+01); %%kitten
			% view(-1.96e+02, 1.31e+01); %%bunny
			view(1.92e+02, 2.46e+01); %%parts
			lighting gouraud
			% camlight('headlight','infinite');
			% camlight('right','infinite');
			camlight('left','infinite');
            material dull; %% dull, shiny, metal
	end
	
	%%2. draw fixed nodes
	if ~isempty(fixedNodes_)
		plot3(nodeCoords_(fixedNodes_,1), nodeCoords_(fixedNodes_,2), nodeCoords_(fixedNodes_,3), ...
			'x', 'Color', [0.0 0.0 0.0], 'LineWidth', 2, 'MarkerSize', 6); hold on
	end
	
	%%3. draw force			
	if ~isempty(nodeLoadVec_)
		coordLoadedNodes = nodeCoords_(nodeLoadVec_(:,1),:);
		amplitudesF = min(vtxUpperBound_-vtxLowerBound_)/5*nodeLoadVec_(:,2:4)./vecnorm(nodeLoadVec_(:,2:4), 2, 2);
		quiver3(coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), ...
			amplitudesF(:,1), amplitudesF(:,2), amplitudesF(:,3), 0, 'Color', ...
				[1.0 0.0 0.0], 'LineWidth', 2, 'MaxHeadSize', 1); hold on	
	end
	%%4. formulated output
	axis on; axis equal; axis tight; axis off
	xlabel('X'); ylabel('Y'); zlabel('Z')
	% view(3); 
	camproj('perspective')
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20)  
end