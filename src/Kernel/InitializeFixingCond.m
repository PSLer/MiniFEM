function InitializeFixingCond()
	global eleType_;
	global boundaryNodes_;
	global nodeCoords_;
	global fixingCond_;
	global PickedNodeCache_;
	ndC = nodeCoords_(boundaryNodes_,:);
	if isempty(PickedNodeCache_), warning('There is no node available!'); end
	PickedNodeCache_ = unique(PickedNodeCache_);
	numTarNodes = length(PickedNodeCache_);

	if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		iFixingVec = PickedNodeCache_;
	else
		iFixingVec = boundaryNodes_(PickedNodeCache_,1);
	end	
	fixingCond_(end+1:end+numTarNodes,1) = iFixingVec;
	
	ClearPickedNodes();
	ShowFixingCondition(iFixingVec);	
end