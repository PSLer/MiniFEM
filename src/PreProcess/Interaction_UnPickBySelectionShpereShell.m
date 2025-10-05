function Interaction_UnPickBySelectionShpereShell(axHandle, sphereCtr, sphereRad)
	global simMesh_;
	global pickedNodeCache_;
	global hdPickedNode_;
	
	if isempty(pickedNodeCache_), return; end
	nodesWithinSelectionSphere = find(vecnorm(sphereCtr-simMesh_(1).nodeCoords,2,2)<=sphereRad);

	if isempty(nodesWithinSelectionSphere), return; end
	
	set(hdPickedNode_, 'visible', 'off');
	pickedNodeCache_ = setdiff(pickedNodeCache_, nodesWithinSelectionSphere);
	hold(axHandle, 'on');
	if isempty(pickedNodeCache_), return; end
	hdPickedNode_(end+1) = plot3(axHandle, simMesh_(1).nodeCoords(pickedNodeCache_,1), ...
		simMesh_(1).nodeCoords(pickedNodeCache_,2), ...
			simMesh_(1).nodeCoords(pickedNodeCache_,3), 'xr', 'LineWidth', 2, 'MarkerSize', 6);
end