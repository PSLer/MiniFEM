function Dev_EvalTO_CoMe()
	global meshType_;
	global material_;
	global eleType_;
	global freeDOFs_;
	global F_ K_ U_ cartesianStressField_ vonMisesStressField_;
	global fixingCond_; 
	global loadingCond_;
	global numEles_ numDOFs_;
	global eDofMat_ nodeCoords_ eNodMat_;
	global Ke_;
	global outputDOFs_;
	
	if isempty(fixingCond_), error('No Constraint!'); end
	if isempty(loadingCond_), error('No Loads!'); end
	ApplyBoundaryCondition_4RobustTOpaper();
	AssembleStiffnessMatrix_4RobustTOpaper();
	kin = 1.0; kout = 1.0e-3; %%2D
	vecI = sparse(numDOFs_,1);
	outDOFs = outputDOFs_(:,1); nOutDOFs = numel(outDOFs);
	vecI(outDOFs) = outputDOFs_(:,2);	
	
	inDOFs = find(abs(full(F_))>0);
    nInDOFs = numel(inDOFs);
	springK_diag = sparse([inDOFs(:); outDOFs], [inDOFs(:); outDOFs], ...
		[repmat(kin/nInDOFs,numel(inDOFs),1); repmat(kout/nOutDOFs,nOutDOFs,1)], ...
		numDOFs_, numDOFs_);	
	K_ = K_ + springK_diag;	
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		U_(freeDOFs_,:) = K_(freeDOFs_,freeDOFs_) \ F_(freeDOFs_,:); 
	elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		error('not ready!');
		%%...
	end
	J = -vecI(:)' * U_(:,1);
	disp(['Output Displacement: ' sprintf('%10.4e',J)]);
	
	%%Stress Ana.
	ComputeCartesianStress();
	vonMisesStressField_ = ComputeVonMisesStress(cartesianStressField_);
	ShowStressComp('Sigma_vM',0);
end