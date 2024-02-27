function InitializeFixingCond(varargin)
	global eleType_;
	global boundaryNodes_;
	global fixingCond_;
	global pickedNodeCache_;
	if isempty(pickedNodeCache_), warning('There is no node available!'); return; end
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);

	% if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		% iFixingVec = pickedNodeCache_;
	% else
		% iFixingVec = boundaryNodes_(pickedNodeCache_,1);
	% end
	iFixingVec = boundaryNodes_(pickedNodeCache_,1);
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144') || strcmp(eleType_.eleName, 'Truss122')
		fixingState = zeros(numTarNodes, 2);
		if 0==nargin
			fixingState(:,1) = 1; fixingState(:,2) = 1;		
		elseif 1==nargin
			fixingDOFs = varargin{1};
			for ii=1:length(fixingDOFs)
				switch fixingDOFs(ii)
					case 'X'
						fixingState(:,1) = 1;
					case 'Y'
						fixingState(:,2) = 1;
					otherwise
						warning('Wrong input!'); return;
				end		
			end
		else
			warning('Wrong input!'); return;
		end
		fixingCond_(end+1:end+numTarNodes,1:3) = [iFixingVec fixingState];
	elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188') || strcmp(eleType_.eleName, 'Truss123')
		fixingState = zeros(numTarNodes, 3);
		if 0==nargin
			fixingState(:,1) = 1; fixingState(:,2) = 1;	fixingState(:,3) = 1;
		elseif 1==nargin
			fixingDOFs = varargin{1};
			for ii=1:length(fixingDOFs)
				switch fixingDOFs(ii)
					case 'X'
						fixingState(:,1) = 1;
					case 'Y'
						fixingState(:,2) = 1;
					case 'Z'
						fixingState(:,3) = 1;
					otherwise
						warning('Wrong input!'); return;
				end		
			end
		else
			warning('Wrong input!'); return;
		end
		fixingCond_(end+1:end+numTarNodes,1:4) = [iFixingVec fixingState];
	elseif strcmp(eleType_.eleName, 'Beam122')
		fixingState = zeros(numTarNodes, 3);
		if 0==nargin
			fixingState(:,1) = 1; fixingState(:,2) = 1;	fixingState(:,3) = 1;
		elseif 1==nargin
			fixingDOFs = varargin{1};
			for ii=1:length(fixingDOFs)
				switch fixingDOFs(ii)
					case 'X'
						fixingState(:,1) = 1;
					case 'Y'
						fixingState(:,2) = 1;
					case 'XY'
						fixingState(:,3) = 1;
					otherwise
						warning('Wrong input!'); return;
				end		
			end
		else
			warning('Wrong input!'); return;
		end		
		fixingCond_(end+1:end+numTarNodes,1:4) = [iFixingVec fixingState];
	elseif strcmp(eleType_.eleName, 'Beam123') || strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		fixingState = zeros(numTarNodes, 6);
		if 0==nargin
			fixingState(:,1) = 1; fixingState(:,2) = 1;	fixingState(:,3) = 1;
			fixingState(:,4) = 1; fixingState(:,5) = 1;	fixingState(:,6) = 1;
		elseif 1==nargin
			fixingDOFs = varargin{1};
			for ii=1:length(fixingDOFs)
				switch fixingDOFs(ii)
					case 'X'
						fixingState(:,1) = 1;
					case 'Y'
						fixingState(:,2) = 1;
					case 'Z'
						fixingState(:,3) = 1;						
					case 'YZ'
						fixingState(:,4) = 1;
					case 'ZX'						
						fixingState(:,5) = 1;
					case 'XY'						
						fixingState(:,6) = 1;
					otherwise
						warning('Wrong input!'); return;
				end		
			end
		else
			warning('Wrong input!'); return;
		end		
		fixingCond_(end+1:end+numTarNodes,1:7) = [iFixingVec fixingState];
	end

	ClearPickedNodes();
	ShowFixingCondition(iFixingVec);	
end