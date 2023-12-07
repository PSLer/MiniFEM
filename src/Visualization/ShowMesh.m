function hd = ShowMesh()
	global eleType_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global boundaryFaceNodMat_
	figure;
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		patchs2show.vertices = nodeCoords_;
		patchs2show.faces = boundaryFaceNodMat_;
		hd = patch(patchs2show); hold('on');
		camproj('perspective');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		[az, el] = view(3);
		lighting('gouraud');
		camlight(az,el);		
		% camlight('headlight','infinite');
		% %camlight('right','infinite');
		% camlight('left','infinite');
        material('dull'); %% dull, shiny, metal		
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		patchs2show.faces = eNodMat_;
		patchs2show.vertices = nodeCoords_;	
		hd = patch(patchs2show); hold('on');
		xlabel('X'); ylabel('Y');
	else
		patchs2show.faces = eNodMat_;
		patchs2show.vertices = nodeCoords_;	
		hd = patch(patchs2show); hold('on');
		camproj('perspective');
		xlabel('X'); ylabel('Y'); zlabel('Z');
		[az, el] = view(3);
		lighting gouraud;
		camlight(az,el);
        material('dull'); %% dull, shiny, metal			
	end
	set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'k');
	axis('equal'); axis('tight'); axis('on');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);	
end