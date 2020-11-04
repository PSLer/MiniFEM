function ApplyBoundaryCondition()
	global domainType_;
	global modelSource_;
	global numDOFs_; global numNodes_; 	
	global fixedNodes_; global fixeddofs_;
	global freeNodes_; global freeDofs_;
	global eleType_; global vtxLowerBound_; global nodeCoords_;
	global boundaryCond_;
	if isnumeric(boundaryCond_)
		if 1==min(size(boundaryCond_))
			fixedNodes_ = boundaryCond_;
		elseif (2==size(boundaryCond_,2)&strcmp(domainType_, '2D')) || ...
			(3==size(boundaryCond_,2)&strcmp(domainType_, '3D'))
				tmp = boundaryCond_;
				nn = size(boundaryCond_,1);
				fixedNodes_ = zeros(nn,1)
				for ii=1:nn
					[minVal minValPos] = min(vecnorm(boundaryCond_(ii,:)-nodeCoords_,2,2));
					fixedNodes_(ii) = minValPos;
				end
		else, error('Wrong boundary option!');
		end
	elseif ischar(boundaryCond_)
		switch boundaryCond_
			case 'X'
				fixedNodes_ = find(vtxLowerBound_(1)==nodeCoords_(:,1));
			case 'Y'
				fixedNodes_ = find(vtxLowerBound_(2)==nodeCoords_(:,2));
			case 'Z'
				if strcmp(domainType_, '3D')
					fixedNodes_ = find(vtxLowerBound_(3)==nodeCoords_(:,3));
				else, error('Wrong boundary option!'); end
			otherwise
				error('Wrong boundary option!');
		end
	else
		error('Wrong boundary option!');
	end
	
	fixeddofs_ = eleType_.numNodeDOFs*fixedNodes_-(eleType_.numNodeDOFs-1:-1:0);
	fixeddofs_ = reshape(fixeddofs_', size(fixeddofs_,1)*size(fixeddofs_,2), 1);
	allNodes = [1:numNodes_]; freeNodes_ = setdiff(allNodes, fixedNodes_);
	allDofs = [1:numDOFs_]; freeDofs_ = setdiff(allDofs, fixeddofs_);
	
	global K_; global M_; 
	global advancedSolvingOpt_; global structureState_;	
	if ~strcmp(advancedSolvingOpt_, 'SpacePriority')
		K_ = K_(freeDofs_,freeDofs_); 
		if strcmp(structureState_, 'DYNAMIC'), M_ = M_(freeDofs_,freeDofs_); end
	end
end
