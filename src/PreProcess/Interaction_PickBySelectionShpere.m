function Interaction_PickBySelectionShpere(axHandle, sphereCtr, sphereRad)
	global surfMesh_;
	global pickedNodeCache_;
	global hdPickedNode_;
	
	nodesWithinSelectionSphere = find(vecnorm(sphereCtr-surfMesh_(1).nodeCoords,2,2)<=sphereRad);
	
	% nodesWithinSelectionSphere = find(cP1(1)<=surfMesh_(1).nodeCoords(:,1));
	% nodesWithinSelectionSphere = nodesWithinSelectionSphere(find(cP2(1)>=surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,1)));
	% nodesWithinSelectionSphere = nodesWithinSelectionSphere(find(cP1(2)<=surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,2)));
	% nodesWithinSelectionSphere = nodesWithinSelectionSphere(find(cP2(2)>=surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,2)));
	% nodesWithinSelectionSphere = nodesWithinSelectionSphere(find(cP1(3)<=surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,3)));
	% nodesWithinSelectionSphere = nodesWithinSelectionSphere(find(cP2(3)>=surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,3)));
	% nodesWithinSelectionSphere = setdiff(nodesWithinSelectionSphere, pickedNodeCache_);
	
	numNewlyPickedNodes = numel(nodesWithinSelectionSphere);	
	if numNewlyPickedNodes>0
		hold(axHandle, 'on');
		if isempty(hdPickedNode_)
			hdPickedNode_ = plot3(axHandle, surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,1), ...
				surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,2), ...
					surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,3), 'xr', 'LineWidth', 2, 'MarkerSize', 6);
		else
			hdPickedNode_(end+1) = plot3(axHandle, surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,1), ...
				surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,2), ...
					surfMesh_(1).nodeCoords(nodesWithinSelectionSphere,3), 'xr', 'LineWidth', 2, 'MarkerSize', 6);		
		end
		pickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesWithinSelectionSphere;
	end
end