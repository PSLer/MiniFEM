function GetStaticDeformation(varargin)
	global F_;
	global K_;
	global U_;
	global fixingCond_; 
	global loadingCond_;
	if isempty(fixingCond_), error('No Constraint!'); end
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end

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
	ShowDeformation('T');
end