function InitializeFixingCond()
	global eleType_;
	global boundaryNodes_;
	global nodeCoords_;
	global fixingCond_;
	global pickedNodeCache_;
	if isempty(pickedNodeCache_), warning('There is no node available!'); return; end
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);

	if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		iFixingVec = pickedNodeCache_;
	else
		iFixingVec = boundaryNodes_(pickedNodeCache_,1);
	end	
	fixingCond_(end+1:end+numTarNodes,1) = iFixingVec;
	
	ClearPickedNodes();
	ShowFixingCondition(iFixingVec);	
end