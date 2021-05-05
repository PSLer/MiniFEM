function GetDirVec()
	global eleType_;
	global nodeCoords_;
	global boundaryNodes_;
	global pickedNodeCache_;
	if size(pickedNodeCache_, 1) < 2, 
		warning('There MUST be at lease TWO Picked Nodes Available!'); return;
	end
	if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		boundaryNodeCoords = nodeCoords_;
	else
		boundaryNodeCoords = nodeCoords_(boundaryNodes_,:);
	end	
	sp = boundaryNodeCoords(pickedNodeCache_(end-1:end),:);
	dirVec = sp(2,:) - sp(1,:);
	dirVec = dirVec/norm(dirVec)
	ClearPickedNodes();
end