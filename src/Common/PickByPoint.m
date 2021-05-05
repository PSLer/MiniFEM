function PickByPoint(varargin)
	%% Syntax: 
	%% PickByPoint(); 
	%% PickByLine(handInputCoordinate); 
	global eleType_;
	global nodeCoords_;
	global boundaryNodes_;	
	global pickedNodeCache_;
	global hdPickedNode_;
	if 0==nargin
		dcm_obj = datacursormode;
		info_struct = getCursorInfo(dcm_obj);
		if isempty(info_struct)
			warning('No Cursor Mode Available!'); return;
		end
		tarNode = info_struct.Position;
	elseif 1==nargin
		tarNode = varargin{1};
	else
		error('Wrong Input!');		
	end
	hold on; 
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		hdPickedNode_(end+1) = plot(tarNode(1), tarNode(2), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	else
		hdPickedNode_(end+1) = plot3(tarNode(1), tarNode(2), tarNode(3), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	end
	if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		[~,newlyPickedNode] = min(vecnorm(tarNode-nodeCoords_,2,2));		
	else
		boundaryNodeCoords = nodeCoords_(boundaryNodes_,:);
		[~,newlyPickedNode] = min(vecnorm(tarNode-boundaryNodeCoords,2,2));		
	end
	pickedNodeCache_(end+1,1) = newlyPickedNode;
end