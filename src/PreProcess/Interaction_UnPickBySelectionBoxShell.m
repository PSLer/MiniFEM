function Interaction_UnPickBySelectionBoxShell(axHandle, cP1, cP2)
	global simMesh_;
	global pickedNodeCache_;
	global hdPickedNode_;
	
	if isempty(pickedNodeCache_), return; end
	for ii=1:3
		if cP1(ii)>cP2(ii), tmp = cP1(ii); cP1(ii) = cP2(ii); cP2(ii) = tmp; end
	end
	nodesWithinSelectionBox = pickedNodeCache_(find(cP1(1)<=simMesh_(1).nodeCoords(pickedNodeCache_,1)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP2(1)>=simMesh_(1).nodeCoords(nodesWithinSelectionBox,1)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP1(2)<=simMesh_(1).nodeCoords(nodesWithinSelectionBox,2)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP2(2)>=simMesh_(1).nodeCoords(nodesWithinSelectionBox,2)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP1(3)<=simMesh_(1).nodeCoords(nodesWithinSelectionBox,3)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP2(3)>=simMesh_(1).nodeCoords(nodesWithinSelectionBox,3)));
	if isempty(nodesWithinSelectionBox), return; end
    % nodesWithinSelectionBox = setdiff(nodesWithinSelectionBox, pickedNodeCache_);
	
	set(hdPickedNode_, 'visible', 'off');
	pickedNodeCache_ = setdiff(pickedNodeCache_, nodesWithinSelectionBox);
	hold(axHandle, 'on');
    if isempty(pickedNodeCache_), return; end
	hdPickedNode_(end+1) = plot3(axHandle, simMesh_(1).nodeCoords(pickedNodeCache_,1), ...
		simMesh_(1).nodeCoords(pickedNodeCache_,2), ...
			simMesh_(1).nodeCoords(pickedNodeCache_,3), 'xr', 'LineWidth', 2, 'MarkerSize', 6);
end