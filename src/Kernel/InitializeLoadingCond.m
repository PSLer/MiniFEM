function InitializeLoadingCond(force)
	global eleType_;
	global boundaryNodes_;
	global nodeCoords_;
	global loadingCond_;
	global pickedNodeCache_;
	if isempty(pickedNodeCache_), warning('There is no node available!'); end
	force = force(:)';
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')	
		if 2==size(force,2)
			iLoadingVec = [double(boundaryNodes_(pickedNodeCache_)) repmat(force/numTarNodes, numTarNodes, 1)];
			loadingCond_(end+1:end+numTarNodes,1:3) = iLoadingVec;			
		else
			warning('Wrongly Defined Force!');
		end
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		if 3==size(force,2) || 6==size(force,2)
			if 3==size(force,2)
				iLoadingVec = [double(pickedNodeCache_) repmat([force 0 0 0]/numTarNodes, numTarNodes, 1)];
			else
				iLoadingVec = [double(pickedNodeCache_) repmat(force/numTarNodes, numTarNodes, 1)];
			end
			loadingCond_(end+1:end+numTarNodes,1:7) = iLoadingVec;	
		else
			warning('Wrongly Defined Force!');
		end
	else
		iLoadingVec = [double(boundaryNodes_(pickedNodeCache_)) repmat(force/numTarNodes, numTarNodes, 1)];
		loadingCond_(end+1:end+numTarNodes,1:4) = iLoadingVec;		
	end
	ClearPickedNodes();
	ShowLoadingCondition(iLoadingVec);
end