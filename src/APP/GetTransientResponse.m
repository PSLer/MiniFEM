function GetTransientResponse(stepSize, numTimeStep, varargin)
	global F_;
	global K_;
	global M_;
	global U_;
	global loadingCond_;
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	if isempty(M_), AssembleMassMatrix(); end
	M_ = diag(diag(M_));
	disp(['Computing Transient Response from 0.0 to ', sprintf('%.6e',stepSize*numTimeStep), 's with Step Size ' sprintf('%.6e',stepSize)]);
	tStart = tic;
	if 2==nargin
		U_ = SolvingTransientSystemEquations(stepSize, numTimeStep);
	elseif 3==nargin
		if strcmp(varargin{1}, 'Explicit') || strcmp(varargin{1}, 'Implicit')
			U_ = SolvingTransientSystemEquations(stepSize, numTimeStep, varargin{1});
		else
			error('Wrong Input!');
		end	
	else
		error('Wrong Input!');
	end
	
	disp(['Compute Transient Response Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	ShowDeformation('T');
end