function flag = ModeAnalysis(numModalModes, varargin)	
	global eleType_;
	global numDOFs_;
	global freeDOFs_;
	global naturalFrequencyList_; 
	global modeSpace_; 
	flag = 1;
	modeSpace_ = zeros(numDOFs_, numModalModes);
	
	if 1==nargin
		if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
			climactericDOF = 2.0e6;
		elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
			climactericDOF = 2.0e5;
		elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell133')
			climactericDOF = 1.0e6;
		end
		if numDOFs_>climactericDOF
			solverType = 'ITERATIVE';
			if length(freeDOFs_) == numDOFs_	
				warning('The Self-determined Iterative Solver cannot Work with Free Vibration! Recommend to Enforce the Direct Solver!');
				return;
			end
		else
			solverType = 'DIRECT';
		end
	else
		solverType = varargin{1};
	end
	switch solverType
		case 'DIRECT'
			[modeSpace_(freeDOFs_,:), naturalFrequencyList_, flag] = GeneralizedEigenvalueProblemDirectSolver(numModalModes);
		case 'ITERATIVE'
			[modeSpace_(freeDOFs_,:), naturalFrequencyList_, flag] = GeneralizedEigenvalueProblemIterativeSolver(numModalModes);
	end	
	
	if 0==flag
		disp('Modal analysis succeed!');
	else
		error('Failed to perform Modal Analysis!'); 
	end
	naturalFrequencyList_ = diag(naturalFrequencyList_);
	naturalFrequencyList_ = sqrt(naturalFrequencyList_)/2/pi;
	modeSpace_ = modeSpace_./vecnorm(modeSpace_,2,1);
end