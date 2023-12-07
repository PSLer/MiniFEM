function hd = ShowSilhouette()
	global eleType_;
	global nodeCoords_;
	global eNodMat_;
	global boundaryFaceNodMat_;
	global boundaryEdgeNodMat_;
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		patchs2show.vertices = nodeCoords_;
		patchs2show.faces = boundaryFaceNodMat_;
		hd = patch(patchs2show); hold('on');
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
		patchs2show.faces = [boundaryEdgeNodMat_ boundaryEdgeNodMat_(:,[2 1])] ;
		patchs2show.vertices = nodeCoords_;	
		hd = patch(patchs2show); hold('on');
		set(hd, 'EdgeColor', DelightfulColors('Default'), 'LineWidth', 2);
		xlabel('X'); ylabel('Y');
	else
		patchs2show.faces = eNodMat_;
		patchs2show.vertices = nodeCoords_;	
		hd = patch(patchs2show); hold('on');
		camproj('perspective');
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 0.3, 'EdgeColor', 'None');		
		xlabel('X'); ylabel('Y'); zlabel('Z');
		[az, el] = view(3);
		lighting('gouraud');
		camlight(az,el);
        material('dull'); %% dull, shiny, metal			
	end
	axis('equal'); axis('tight'); axis('on');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
end