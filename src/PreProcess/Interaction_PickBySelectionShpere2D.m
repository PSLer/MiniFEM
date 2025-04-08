function Interaction_PickBySelectionShpere2D(axHandle, sphereCtr, sphereRad)
	global surfMesh_;
	global pickedNodeCache_;
	global hdPickedNode_;
	
	nodesWithinSelectionSphere = find(vecnorm(sphereCtr-surfMesh_(1).nodeCoords,2,2)<=sphereRad);
	
	numNewlyPickedNodes = numel(nodesWithinSelectionSphere);	
	if numNewlyPickedNodes>0
		hold(axHandle, 'on');
		if isempty(hdPickedNode_)
			hdPickedNode_ = plot(axHandle, surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,1), ...
				surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,2), 'xr', 'LineWidth', 2, 'MarkerSize', 6);
		else
			hdPickedNode_(end+1) = plot(axHandle, surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,1), ...
				surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,2), 'xr', 'LineWidth', 2, 'MarkerSize', 6);		
		end
		pickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesWithinSelectionSphere;
	end
end