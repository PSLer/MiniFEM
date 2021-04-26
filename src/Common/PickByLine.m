function PickByLine(constantDir)
	global eleType_;
	global nodeCoords_;
	global boundaryNodes_;
	global PickedNodeCache_;
	global hdPickedNode_;
	
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
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		if 1~=length(constantDir), error('Wrongly Defined Line Direction!'); end
		switch constantDir
			case 'X'
				nodesOnLine = find(boundaryNodeCoords(:,1)==tarNode(1));
			case 'Y'
				nodesOnLine = find(boundaryNodeCoords(:,2)==tarNode(2));
			otherwise
				error('Wrongly Defined Line Direction!');
		end	
		hdPickedNode_(end+1) = plot(boundaryNodeCoords(nodesOnLine,1), ...
			boundaryNodeCoords(nodesOnLine,2), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	else
		if 2~=length(constantDir), error('Wrongly Defined Line Direction!'); end
		switch constantDir(1)
			case 'X'
				nodesOnLine1 = find(boundaryNodeCoords(:,1)==tarNode(1));
			case 'Y'
				nodesOnLine1 = find(boundaryNodeCoords(:,2)==tarNode(2));
			case 'Z'
				nodesOnLine1 = find(boundaryNodeCoords(:,3)==tarNode(3));				
			otherwise
				error('Wrongly Defined Line Direction!');
		end
		switch constantDir(2)
			case 'X'
				nodesOnLine = nodesOnLine1(find(boundaryNodeCoords(nodesOnLine1,1)==tarNode(1)));
			case 'Y'
				nodesOnLine = nodesOnLine1(find(boundaryNodeCoords(nodesOnLine1,2)==tarNode(2)));
			case 'Z'
				nodesOnLine = nodesOnLine1(find(boundaryNodeCoords(nodesOnLine1,3)==tarNode(3)));				
			otherwise
				error('Wrongly Defined Line Direction!');
		end		
		hdPickedNode_(end+1) = plot3(boundaryNodeCoords(nodesOnLine,1), boundaryNodeCoords(nodesOnLine,2), ...
			boundaryNodeCoords(nodesOnLine,3), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	end
	numNewlyPickedNodes = length(nodesOnLine);
	PickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesOnLine;
end