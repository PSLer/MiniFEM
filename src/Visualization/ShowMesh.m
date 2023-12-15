function hd = ShowMesh()
	global eleType_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global boundaryFaceNodMat_;
	global diameterList_;
	figure;
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		patchs2show.vertices = nodeCoords_;
		patchs2show.faces = boundaryFaceNodMat_;
		hd = patch(patchs2show); hold('on');
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'k');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		view(3); 
		camproj('perspective');
		lighting('gouraud');
		material('dull'); %%shiny; dull; metal	
		camlight('headlight','infinite');
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		patchs2show.faces = eNodMat_;
		patchs2show.vertices = nodeCoords_;	
		hd = patch(patchs2show); hold('on');
		xlabel('X'); ylabel('Y');
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'k');
	elseif strcmp(eleType_.eleName, 'Truss123') || strcmp(eleType_.eleName, 'Beam123')
		[gridX, gridY, gridZ, gridC] = Extend3DMeshEdges2Tubes(nodeCoords_, eNodMat_, diameterList_);
		hd = surf(gridX, gridY, gridZ, gridC);
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		view(3); 
		camproj('perspective');
		lighting('gouraud');
		material('dull'); %%shiny; dull; metal	
		camlight('headlight','infinite');		
	elseif strcmp(eleType_.eleName, 'Truss122') || strcmp(eleType_.eleName, 'Beam122')
		hd = patch('vertices', nodeCoords_, 'faces', eNodMat_);
		set(hd, 'FaceColor', 'None', 'EdgeColor', DelightfulColors('Default'), 'LineWidth', 2);
	else
		patchs2show.faces = eNodMat_;
		patchs2show.vertices = nodeCoords_;	
		hd = patch(patchs2show); hold('on');
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'k');
		xlabel('X'); ylabel('Y'); zlabel('Z');		
		view(3); 
		camproj('perspective');
		lighting('gouraud');
		material('dull'); %%shiny; dull; metal	
		camlight('headlight','infinite');		
	end
	
	axis('equal'); axis('tight'); axis('on');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);	
end