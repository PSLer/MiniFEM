function PickBySurface(constantDir)
	global eleType_;
	global nodeCoords_;
	global boundaryNodes_;
	global PickedNodeCache_;
	global hdPickedNode_;
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		warning('Only Work with non-2D Mesh!');
	end
	dcm_obj = datacursormode;
	info_struct = getCursorInfo(dcm_obj);
	if isempty(info_struct)
		warning('No Cursor Mode Available!'); return;
	end
	tarNode = info_struct.Position;

	if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		boundaryNodeCoords = nodeCoords_;
	else
		boundaryNodeCoords = nodeCoords_(boundaryNodes_,:);
	end
	numPickedNode = size(PickedNodeCache_,1);
	hold on; 
	if 1~=length(constantDir), error('Wrongly Defined Line Direction!'); end
	switch constantDir
		case 'X'
			nodesOnLine = find(boundaryNodeCoords(:,1)==tarNode(1));
		case 'Y'
			nodesOnLine = find(boundaryNodeCoords(:,2)==tarNode(2));
		case 'Z'
			nodesOnLine = find(boundaryNodeCoords(:,3)==tarNode(3));				
		otherwise
			error('Wrongly Defined Line Direction!');
	end
	hdPickedNode_(end+1) = plot3(boundaryNodeCoords(nodesOnLine,1), boundaryNodeCoords(nodesOnLine,2), ...
		boundaryNodeCoords(nodesOnLine,3), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	numNewlyPickedNodes = length(nodesOnLine);
	PickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesOnLine;
end