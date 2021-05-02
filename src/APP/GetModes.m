function GetModes(numModalModes, varargin)
	global freeDOFs_;
	global K_;
	global M_;	
	if isempty(freeDOFs_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	if isempty(M_), AssembleMassMatrix(); end
	tStart = tic;
	if 1==nargin
		flag = ModeAnalysis(numModalModes);
	elseif 2==nargin
		if strcmp(varargin{1}, 'DIRECT') || strcmp(varargin{1}, 'ITERATIVE')
			flag = ModeAnalysis(numModalModes, varargin{1});
		else
			error('Wrong Input!');
		end
	else
		error('Wrong Input!');
	end
	disp(['Perform Modal Analysis Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	if 0==flag %%Successful Modal Analysis
		ShowModalMode(1);
	end
end