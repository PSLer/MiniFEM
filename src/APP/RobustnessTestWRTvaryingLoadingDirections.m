function complianceList = RobustnessTestWRTvaryingLoadingDirections()
	global eleType_;
	global freeDOFs_;
	global F_;
	global K_;
	global U_;
	global fixingCond_; 
	global loadingCond_;
	
	complianceList = [];
	if ~strcmp(eleType_.eleName, 'Plane144')
		warning('Only Works with Plane144 Element!');
	end
	
	if isempty(fixingCond_), error('No Constraint!'); end
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	
	theta0 = 0;
	theta1 = pi/2;
	numLoadSteps = 10;
	thetaList = linspace(theta0, theta1, numLoadSteps);
	complianceList = zeros(numLoadSteps, 1);
	loadingAmp = vecnorm(loadingCond_(:,2:end),2,2);
	F_ = [];
	
	%%backup loading condtion
	oriLoadingCond = loadingCond_;	

	refTheta = acos(loadingCond_(:,2:3)*[1; 0] ./ vecnorm(loadingCond_(:,2:3),2,2));
	minusY = find(loadingCond_(:,3)<0);
	refTheta(minusY) = 2*pi-refTheta(minusY);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	tStart = tic;
	for ii=1:numLoadSteps
		disp([' Progress.: ' sprintf('%4i %4i', [ii numLoadSteps] )]);
		loadingCond_(:,2) = loadingAmp .* cos(refTheta+thetaList(ii));
		loadingCond_(:,3) = loadingAmp .* sin(refTheta+thetaList(ii));
		ApplyBoundaryCondition(); 
		U_ = SolvingStaticLinearSystemEquations();
		complianceList(ii) = U_(freeDOFs_,1)' * (K_*U_(freeDOFs_,1));
		F_ = [];
	end
	disp(['Perform Robustness Test Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	
	%%recover loading condtion
	% loadingCond_ = oriLoadingCond;
	
	figure; plot(thetaList/pi*180, complianceList, '-r', 'LineWidth', 3); axis tight;
	xlabel('Force rotation angle'); ylabel('Compliance');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 18);
end