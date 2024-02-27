function ShowDualMaterial()
	global eleType_;
	global nodeCoords_;
	global eNodMat_;
	global materialIndicatorField_;
	
	if ~strcmp(eleType_.eleName, 'Plane144'), return; end
	if 1==max(materialIndicatorField_)
		warning('Only a single material is involved!');
		return;
	end
	patchRebar.vertices = nodeCoords_;
	patchRebar.faces = eNodMat_(2==materialIndicatorField_,:);
	patchMatrix.vertices = nodeCoords_;
	patchMatrix.faces = eNodMat_(1==materialIndicatorField_,:);
	figure;
	hdRebar = patch(patchRebar); hold('on');
	hdMatrix = patch(patchMatrix);
	set(hdMatrix, 'FaceColor', [255 127 0]/255, 'FaceAlpha', 1, 'EdgeColor', 'None');
	set(hdRebar, 'FaceColor', [65 174 118]/255, 'FaceAlpha', 1, 'EdgeColor', 'None');
	axis('equal'); axis('tight'); axis('off');	
end