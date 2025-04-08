function Interaction_UnPickBySelectionShpere2D(axHandle, sphereCtr, sphereRad)
	global surfMesh_;
	global pickedNodeCache_;
	global hdPickedNode_;
	
	if isempty(pickedNodeCache_), return; end
	nodesWithinSelectionSphere = find(vecnorm(sphereCtr-surfMesh_(1).nodeCoords,2,2)<=sphereRad);

	if isempty(nodesWithinSelectionSphere), return; end
	
	set(hdPickedNode_, 'visible', 'off');
	pickedNodeCache_ = setdiff(pickedNodeCache_, nodesWithinSelectionSphere);
	hold(axHandle, 'on');
	if isempty(pickedNodeCache_), return; end
	hdPickedNode_(end+1) = plot(axHandle, surfMesh_(1).nodeCoords(pickedNodeCache_,1), ...
		surfMesh_(1).nodeCoords(pickedNodeCache_,2), 'xr', 'LineWidth', 2, 'MarkerSize', 6);
end