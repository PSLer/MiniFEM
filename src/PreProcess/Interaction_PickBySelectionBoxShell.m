function Interaction_PickBySelectionBoxShell(axHandle, cP1, cP2)
	global simMesh_;
	global pickedNodeCache_;
	global hdPickedNode_;

	for ii=1:3
		if cP1(ii)>cP2(ii), tmp = cP1(ii); cP1(ii) = cP2(ii); cP2(ii) = tmp; end
    end
	nodesWithinSelectionBox = find(cP1(1)<=simMesh_(1).nodeCoords(:,1));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP2(1)>=simMesh_(1).nodeCoords(nodesWithinSelectionBox,1)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP1(2)<=simMesh_(1).nodeCoords(nodesWithinSelectionBox,2)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP2(2)>=simMesh_(1).nodeCoords(nodesWithinSelectionBox,2)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP1(3)<=simMesh_(1).nodeCoords(nodesWithinSelectionBox,3)));
	nodesWithinSelectionBox = nodesWithinSelectionBox(find(cP2(3)>=simMesh_(1).nodeCoords(nodesWithinSelectionBox,3)));
	nodesWithinSelectionBox = setdiff(nodesWithinSelectionBox, pickedNodeCache_);
	
	numNewlyPickedNodes = numel(nodesWithinSelectionBox);
	if numNewlyPickedNodes>0
		hold(axHandle, 'on');
		if isempty(hdPickedNode_)
			hdPickedNode_ = plot3(axHandle, simMesh_(1).nodeCoords(nodesWithinSelectionBox,1), ...
				simMesh_(1).nodeCoords(nodesWithinSelectionBox,2), ...
					simMesh_(1).nodeCoords(nodesWithinSelectionBox,3), 'xr', 'LineWidth', 2, 'MarkerSize', 6);
		else
			hdPickedNode_(end+1) = plot3(axHandle, simMesh_(1).nodeCoords(nodesWithinSelectionBox,1), ...
				simMesh_(1).nodeCoords(nodesWithinSelectionBox,2), ...
					simMesh_(1).nodeCoords(nodesWithinSelectionBox,3), 'xr', 'LineWidth', 2, 'MarkerSize', 6);		
		end
		pickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesWithinSelectionBox;
	end
end