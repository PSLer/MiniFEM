function PickByLine(constantDir, opt, varargin)
	global eleType_;
	global nodeCoords_;
	global boundaryNodes_;
	global pickedNodeCache_;
	global hdPickedNode_;
	
	if 2==nargin, lineRelaxFactor = 0; else, lineRelaxFactor = varargin{1}; end
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
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		if 1~=length(constantDir), error('Wrongly Defined Line Direction!'); end
		if ~(1==opt || 0==opt || -1==opt), warning('Wrong Input!'); return; end
		switch constantDir
			case 'X'
				% nodesOnLine = find(abs(boundaryNodeCoords(:,1)-tarNode(1))<=lineRelaxFactor);
				refNodePool = boundaryNodeCoords(:,1);
				refPos = tarNode(1);				
			case 'Y'
				% nodesOnLine = find(abs(boundaryNodeCoords(:,2)-tarNode(2))<=lineRelaxFactor);
				refNodePool = boundaryNodeCoords(:,2);
				refPos = tarNode(2);					
			otherwise
				error('Wrongly Defined Line Direction!');
		end
		switch opt
			case 1
				nodesOnLine = find(refNodePool>=refPos);
			case 0
				nodesOnLine = find(abs(refNodePool-refPos)<=lineRelaxFactor);
			case -1
				nodesOnLine = find(refNodePool<=refPos);
		end
		hdPickedNode_(end+1) = plot(boundaryNodeCoords(nodesOnLine,1), ...
			boundaryNodeCoords(nodesOnLine,2), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	else
		if 2~=length(constantDir), error('Wrongly Defined Line Direction!'); end
		switch constantDir(1)
			case 'X'
				nodesOnLine1 = find(abs(boundaryNodeCoords(:,1)-tarNode(1))<=lineRelaxFactor);
			case 'Y'
				nodesOnLine1 = find(abs(boundaryNodeCoords(:,2)-tarNode(2))<=lineRelaxFactor);
			case 'Z'
				nodesOnLine1 = find(abs(boundaryNodeCoords(:,3)-tarNode(3))<=lineRelaxFactor);				
			otherwise
				error('Wrongly Defined Line Direction!');
		end
		switch constantDir(2)
			case 'X'
				nodesOnLine = nodesOnLine1(find(abs(boundaryNodeCoords(nodesOnLine1,1)-tarNode(1))<=lineRelaxFactor));
			case 'Y'
				nodesOnLine = nodesOnLine1(find(abs(boundaryNodeCoords(nodesOnLine1,2)-tarNode(2))<=lineRelaxFactor));
			case 'Z'
				nodesOnLine = nodesOnLine1(find(abs(boundaryNodeCoords(nodesOnLine1,3)-tarNode(3))<=lineRelaxFactor));				
			otherwise
				error('Wrongly Defined Line Direction!');
		end			
		hdPickedNode_(end+1) = plot3(boundaryNodeCoords(nodesOnLine,1), boundaryNodeCoords(nodesOnLine,2), ...
			boundaryNodeCoords(nodesOnLine,3), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
	end
	numNewlyPickedNodes = length(nodesOnLine);
	pickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesOnLine;
end