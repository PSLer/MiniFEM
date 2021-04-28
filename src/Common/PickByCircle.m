function PickByCircle()
	global eleType_;
	global nodeCoords_;
	global boundaryNodes_;
	global PickedNodeCache_;
	global hdPickedNode_;
	if size(PickedNodeCache_, 1) < 2, 
		warning('There MUST be at lease TWO Picked Nodes Available!'); return;
	end
	if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		boundaryNodeCoords = nodeCoords_;
	else
		boundaryNodeCoords = nodeCoords_(boundaryNodes_,:);
	end
	ctr = boundaryNodeCoords(PickedNodeCache_(end-1),:);
	radi = norm(ctr-boundaryNodeCoords(PickedNodeCache_(end),:));
	nodesWithinCircle = find(vecnorm(ctr-boundaryNodeCoords,2,2)<=radi);
	nodesWithinCircle = setdiff(nodesWithinCircle, PickedNodeCache_(end-1:end));
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		hdPickedNode_(end+1) = plot(boundaryNodeCoords(nodesWithinCircle,1), ...
			boundaryNodeCoords(nodesWithinCircle,2), 'xr', 'LineWidth', 2, 'MarkerSize', 8);	
	else
		hdPickedNode_(end+1) = plot3(boundaryNodeCoords(nodesWithinCircle,1), boundaryNodeCoords(nodesWithinCircle,2), ...
			boundaryNodeCoords(nodesWithinCircle,3), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	end
	numNewlyPickedNodes = length(nodesWithinCircle);
	PickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesWithinCircle;
end