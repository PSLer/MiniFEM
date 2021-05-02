function GetFrequencyResponse(iFreq, varargin)
	global F_;
	global K_;
	global M_;
	global U_;
	global loadingCond_;
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	if isempty(M_), AssembleMassMatrix(); end
	if 1==nargin
		U_ = SolvingDynamicLinearSystemEquations(iFreq);
	elseif 2==nargin
		if strcmp(varargin{1}, 'DIRECT') || strcmp(varargin{1}, 'ITERATIVE')
			U_ = SolvingDynamicLinearSystemEquations(iFreq, varargin{1});
		else
			error('Wrong Input!');
		end	
	else
		error('Wrong Input!');
	end	
	ShowDeformation('T');
end