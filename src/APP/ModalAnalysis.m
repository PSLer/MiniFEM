function ModalAnalysis()	
	global domainType_; 
	global structureState_;
	global advancedSolvingOpt_;
	global numDOFs_; global freeDofs_;
	global K_; global M_;
	global modalSpace_;
	global naturalFreqs_;
	global numNaturalFreqs_;
	if strcmp(structureState_, 'STATIC'), error('Wrong analysis type! Please switch to DYNAMIC mode.'); end
	if strcmp(advancedSolvingOpt_, 'SpacePriority'), error('Wrong Matrix type in Modal anaysis!'); end
	modalSpace_ = zeros(numDOFs_, numNaturalFreqs_);
	tic;	 
	if (strcmp(domainType_, '3D') & numDOFs_>5.0e4)		
		[modalSpace_(freeDofs_,:), naturalFreqs_, flag] = ...
			GeneralizedEigenvalueProblemIterativeSolver(numNaturalFreqs_);
	else
		[modalSpace_(freeDofs_,:), naturalFreqs_, flag] = ...
			GeneralizedEigenvalueProblemDirectSolver(numNaturalFreqs_);
	end

	if 0==flag
		disp('Modal analysis succeed!');
	else
		error('Failed to perform Modal Analysis!'); 
	end
	naturalFreqs_ = diag(naturalFreqs_);
	naturalFreqs_ = sqrt(naturalFreqs_)/2/pi;
	modalSpace_ = modalSpace_./vecnorm(modalSpace_,2,1);
	disp(['Modal analysis costs: ' sprintf('%10.3g',toc) 's']);
end

	%% Ref::
	% [modalSpace_, naturalFreqs_, flag] = eigs(K_, M_, numNaturalFreqs_, 'smallestabs', ...
		% 'IsSymmetricDefinite', 1, 'Tolerance', tol_);