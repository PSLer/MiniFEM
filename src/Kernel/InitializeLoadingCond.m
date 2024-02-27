function InitializeLoadingCond(force)
	global eleType_;
	global boundaryNodes_;
	global loadingCond_;
	global pickedNodeCache_;
	if isempty(pickedNodeCache_), warning('There is no node available!'); end
	force = force(:)';
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);
	loadedNodes = double(boundaryNodes_(pickedNodeCache_,1));
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')	|| strcmp(eleType_.eleName, 'Truss122')
		if 2==size(force,2)
			iLoadingVec = [loadedNodes repmat(force/numTarNodes, numTarNodes, 1)];
			loadingCond_(end+1:end+numTarNodes,1:3) = iLoadingVec;			
		else
			warning('Wrongly Defined Force!');
		end
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144') || strcmp(eleType_.eleName, 'Beam123')
		if 3==size(force,2) || 6==size(force,2)
			if 3==size(force,2)
				iLoadingVec = [loadedNodes repmat([force 0 0 0]/numTarNodes, numTarNodes, 1)];
			else
				iLoadingVec = [loadedNodes repmat(force/numTarNodes, numTarNodes, 1)];
			end
			loadingCond_(end+1:end+numTarNodes,1:7) = iLoadingVec;	
		else
			warning('Wrongly Defined Force!');
		end
	elseif strcmp(eleType_.eleName, 'Solid188') || strcmp(eleType_.eleName, 'Solid144')	|| ...
			strcmp(eleType_.eleName, 'Truss123') || strcmp(eleType_.eleName, 'Beam122')
		iLoadingVec = [double(boundaryNodes_(pickedNodeCache_)) repmat(force/numTarNodes, numTarNodes, 1)];
		loadingCond_(end+1:end+numTarNodes,1:4) = iLoadingVec;		
	end
	ClearPickedNodes();
	ShowLoadingCondition(iLoadingVec);
end