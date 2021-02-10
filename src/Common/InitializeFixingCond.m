function InitializeFixingCond(varargin)
	global nodesOutline_;
	global nodeCoords_;
	global boundaryCond_;
	global PickedNodeCache_;
	ndC = nodeCoords_(nodesOutline_,:);
	if isempty(PickedNodeCache_), warning('There is no node selected!'); end
	if 0==nargin
		if size(PickedNodeCache_,1)<2
			[~,tarNodes] =  min(vecnorm(PickedNodeCache_-ndC,2,2));
			iLth = 1;
		else
			ctr = PickedNodeCache_(end-1,:);
			rangeLimitNode = PickedNodeCache_(end,:);
			effectRad = norm(rangeLimitNode-ctr);
			tarNodes = find(vecnorm(ctr-ndC,2,2)<=effectRad);
			iLth = length(tarNodes);
		end
	else
		ctr = PickedNodeCache_(end,:);
		effectRad = varargin{1};
		tarNodes = find(vecnorm(ctr-ndC,2,2)<=effectRad);
		iLth = length(tarNodes);
	end
	boundaryCond_(end+1:end+iLth,1) = nodesOutline_(tarNodes);
	boundaryCond_ = unique(boundaryCond_);
	tarNodeCoord = ndC(tarNodes,:);	
	hold on; plot3(tarNodeCoord(:,1), tarNodeCoord(:,2), ...
				tarNodeCoord(:,3), 'xk', 'LineWidth', 2, 'MarkerSize', 6);
end