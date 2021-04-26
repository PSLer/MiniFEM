function InitializeLoadingCond(force)
	global eleType_;
	global boundaryNodes_;
	global nodeCoords_;
	global loadingCond_;
	global PickedNodeCache_;
	if isempty(PickedNodeCache_), warning('There is no node available!'); end
	PickedNodeCache_ = unique(PickedNodeCache_);
	numTarNodes = length(PickedNodeCache_);
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		force = force(:)';
		if 2==size(force,2)
			iLoadingVec = [double(boundaryNodes_(PickedNodeCache_)) repmat(force/numTarNodes, numTarNodes, 1)];
			loadingCond_(end+1:end+numTarNodes,1:3) = iLoadingVec;			
		else
			warning('Wrongly Defined Force!');
		end
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		if 3==size(force,2) || 6==size(force,2)
			if 3==size(force,2)
				iLoadingVec = [double(PickedNodeCache_) repmat([force 0 0 0]/numTarNodes, numTarNodes, 1)];
			else
				iLoadingVec = [double(PickedNodeCache_) repmat(force/numTarNodes, numTarNodes, 1)];
			end
			loadingCond_(end+1:end+numTarNodes,1:7) = iLoadingVec;	
		else
			warning('Wrongly Defined Force!');
		end
	else
		iLoadingVec = [double(boundaryNodes_(PickedNodeCache_)) repmat(force/numTarNodes, numTarNodes, 1)];
		loadingCond_(end+1:end+numTarNodes,1:4) = iLoadingVec;		
	end
	ClearPickedNodes();
	ShowLoadingCondition(iLoadingVec);
end