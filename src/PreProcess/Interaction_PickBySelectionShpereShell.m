function Interaction_PickBySelectionShpereShell(axHandle, sphereCtr, sphereRad)
	global simMesh_;
	global pickedNodeCache_;
	global hdPickedNode_;
	
	nodesWithinSelectionSphere = find(vecnorm(sphereCtr-simMesh_(1).nodeCoords,2,2)<=sphereRad);
	
	numNewlyPickedNodes = numel(nodesWithinSelectionSphere);	
	if numNewlyPickedNodes>0
		hold(axHandle, 'on');
		if isempty(hdPickedNode_)
			hdPickedNode_ = plot3(axHandle, simMesh_(1).nodeCoords(nodesWithinSelectionSphere,1), ...
				simMesh_(1).nodeCoords(nodesWithinSelectionSphere,2), ...
					simMesh_(1).nodeCoords(nodesWithinSelectionSphere,3), 'xr', 'LineWidth', 2, 'MarkerSize', 6);
		else
			hdPickedNode_(end+1) = plot3(axHandle, simMesh_(1).nodeCoords(nodesWithinSelectionSphere,1), ...
				simMesh_(1).nodeCoords(nodesWithinSelectionSphere,2), ...
					simMesh_(1).nodeCoords(nodesWithinSelectionSphere,3), 'xr', 'LineWidth', 2, 'MarkerSize', 6);		
		end
		pickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesWithinSelectionSphere;
	end
end