function PickBySurface(constantDir, opt, varargin)
	global eleType_;
	global nodeCoords_;
	global boundaryNodes_;
	global pickedNodeCache_;
	global hdPickedNode_;
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		warning('Only Work with non-2D Mesh!'); return;
	end
	if ~(1==opt || 0==opt || -1==opt), warning('Wrong Input!'); return; end
	if 0==opt
		if 2==nargin, surfRelaxFactor = 0; else, surfRelaxFactor = varargin{1}; end
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
	hold on; 
	if 1~=length(constantDir), error('Wrongly Defined Line Direction!'); end
	switch constantDir
		case 'X'
			refNodePool = boundaryNodeCoords(:,1);
			refPos = tarNode(1);	
		case 'Y'
			refNodePool = boundaryNodeCoords(:,2);
			refPos = tarNode(2);		
		case 'Z'
			refNodePool = boundaryNodeCoords(:,3);
			refPos = tarNode(3);			
		otherwise
			error('Wrongly Defined Line Direction!');
	end
	switch opt
		case 1
			nodesOnLine = find(refNodePool>=refPos);
		case 0
			nodesOnLine = find(abs(refNodePool-refPos)<=surfRelaxFactor);
		case -1
			nodesOnLine = find(refNodePool<=refPos);
	end
	hdPickedNode_(end+1) = plot3(boundaryNodeCoords(nodesOnLine,1), boundaryNodeCoords(nodesOnLine,2), ...
		boundaryNodeCoords(nodesOnLine,3), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	numNewlyPickedNodes = length(nodesOnLine);
	pickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesOnLine;
end