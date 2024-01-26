function GetTransientResponse(stepSize, numTimeStep, varargin)
	global F_;
	global K_;
	global M_;
	global U_;
	global loadingCond_;
	global freeDOFs_;
	global displacmentHistory_;
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	if isempty(M_), AssembleMassMatrix(); end
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
	cTotal = 0;
	for kk=3:size(displacmentHistory_,2)
		iU = displacmentHistory_(freeDOFs_,kk);
		cTotal = cTotal + iU' * (K_*iU);
	end
	% cTotal = U_(freeDOFs_,1)' * (K_*U_(freeDOFs_,1));
	disp(['Transient compliance: ' sprintf('%.6e',cTotal)]);
	ShowDeformation('T');
end