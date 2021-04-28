function ModeAnalysis(numModalModes)	
	global eleType_;
	global numDOFs_;
	global freeDOFs_;
	global naturalFrequencyList_; 
	global modeSpace_; 

	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		climactericDOF = 2.0e6;
	elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		climactericDOF = 1.0e5;
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell133')
		climactericDOF = 1.0e6;
	end
	modeSpace_ = zeros(numDOFs_, numModalModes);
	if numDOFs_<climactericDOF
		[modeSpace_(freeDOFs_,:), naturalFrequencyList_, flag] = GeneralizedEigenvalueProblemDirectSolver(numModalModes);
	else
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