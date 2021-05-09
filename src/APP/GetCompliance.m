function c = GetCompliance(varargin)
	global freeDOFs_;
	global F_;
	global K_;
	global U_;
	global fixingCond_; 
	global loadingCond_;
	
	if isempty(fixingCond_), error('No Constraint!'); end
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	
	tStart = tic;
	if 0==nargin
		U_ = SolvingStaticLinearSystemEquations();
	elseif 1==nargin
		if strcmp(varargin{1}, 'DIRECT') || strcmp(varargin{1}, 'ITERATIVE')
			U_ = SolvingStaticLinearSystemEquations(varargin{1});
		else
			error('Wrong Input!');
		end	
	else
		error('Wrong Input!');
	end
	c = U_(freeDOFs_,1)' * (K_*U_(freeDOFs_,1));
	disp(['Compute Static Deformation Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	ShowDeformation('T');
end