function ApplyBoundaryCondition()
	global eleType_;
	global numDOFs_;
	global F_;
	global freeDOFs_;
	global fixingCond_; 
	global loadingCond_;
	global loadedDOFs_;
	freeDOFs_ = (1:numDOFs_)';
	if ~isempty(fixingCond_)
		if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
			tmp = 2*fixingCond_(:,1);
			fixedDOFs = [tmp-1 tmp]'; fixedDOFs = fixedDOFs(:);
		elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
			tmp = 3*fixingCond_(:,1);
			fixedDOFs = [tmp-2 tmp-1 tmp]'; fixedDOFs = fixedDOFs(:);
		elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
			tmp = 6*fixingCond_(:,1);
			fixedDOFs = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp]'; fixedDOFs = fixedDOFs(:);
		end
		fixingState = fixingCond_(:,2:end)';
		realFixedDOFs = fixedDOFs(find(1==fixingState(:)));
		freeDOFs_ = setdiff(freeDOFs_, realFixedDOFs);	
	end
	
	F_ = sparse(numDOFs_,1);
	if ~isempty(loadingCond_)
		if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
			tmp = 2*loadingCond_(:,1);
			loadedDOFs_ = [tmp-1 tmp]'; loadedDOFs_ = loadedDOFs_(:);
			loadingVec = loadingCond_(:,2:3)'; loadingVec = loadingVec(:);
		elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
			tmp = 3*loadingCond_(:,1);
			loadedDOFs_ = [tmp-2 tmp-1 tmp]'; loadedDOFs_ = loadedDOFs_(:);
			loadingVec = loadingCond_(:,2:4)'; loadingVec = loadingVec(:);
		elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
			tmp = 6*loadingCond_(:,1);
			loadedDOFs_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp]'; loadedDOFs_ = loadedDOFs_(:);
			loadingVec = loadingCond_(:,2:7)'; loadingVec = loadingVec(:);
		end
		F_(loadedDOFs_) = loadingVec;
	end
	F_ = F_(freeDOFs_);
end