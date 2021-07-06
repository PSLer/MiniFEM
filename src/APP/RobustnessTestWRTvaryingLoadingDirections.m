function complianceList = RobustnessTestWRTvaryingLoadingDirections()
	global eleType_;
	global freeDOFs_;
	global F_;
	global K_;
	global U_;
	global fixingCond_; 
	global loadingCond_;
	
	complianceList = [];
	if isempty(fixingCond_), error('No Constraint!'); end
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	%%backup loading condtion
	oriLoadingCond = loadingCond_;	
	
	tStart = tic;
	if strcmp(eleType_.eleName, 'Plane144') || strcmp(eleType_.eleName, 'Plane133')
		theta0 = -pi/4;
		theta1 = pi/4;
		numLoadSteps = 11;
		thetaList = linspace(theta0, theta1, numLoadSteps);
		complianceList = zeros(numLoadSteps, 1);
		loadingAmp = vecnorm(loadingCond_(:,2:end),2,2);

		refTheta = acos(loadingCond_(:,2:3)*[1; 0] ./ vecnorm(loadingCond_(:,2:3),2,2));
		minusY = find(loadingCond_(:,3)<0);
		refTheta(minusY) = 2*pi-refTheta(minusY);

		for ii=1:numLoadSteps
			disp([' Progress.: ' sprintf('%4i %4i', [ii numLoadSteps] )]);
			loadingCond_(:,2) = loadingAmp .* cos(refTheta+thetaList(ii));
			loadingCond_(:,3) = loadingAmp .* sin(refTheta+thetaList(ii));
			ApplyBoundaryCondition(); 
			U_ = SolvingStaticLinearSystemEquations();
			complianceList(ii) = U_(freeDOFs_,1)' * (K_*U_(freeDOFs_,1));
			F_ = [];
		end		
	else
		theta0 = -pi/4; theta1 = pi/4;
		numLoadSteps = 7;
		thetaList = linspace(theta0, theta1, numLoadSteps);
		complianceList = zeros(numLoadSteps, 1);
		loadingAmp = vecnorm(loadingCond_(:,2:end),2,2);
		
		pitchAngle = acos(loadingCond_(:,2:4)*[0; 0; 1] ./ vecnorm(loadingCond_(:,2:4),2,2));
		minusX = find(loadingCond_(:,2)<0);
		pitchAngle(minusX) = 2*pi-pitchAngle(minusX);
		
		caseType = 'normal'; %%'special', 'normal'. WATCH OUT !!!	
		switch caseType
			case 'special' %% loads are parallel to z-axes
				yawAngle = ones(size(pitchAngle)) .* pi/2; %%rotate around X
				% yawAngle = ones(size(pitchAngle)) .* 0;	%%rotate around Y
				for ii=1:numLoadSteps
					disp([' Progress.: ' sprintf('%4i %4i', [ii numLoadSteps] )]);
					loadingCond_(:,2) = loadingAmp .* sin(pitchAngle+thetaList(ii)) .* cos(yawAngle);
					loadingCond_(:,3) = loadingAmp .* sin(pitchAngle+thetaList(ii)) .* sin(yawAngle);
					loadingCond_(:,4) = loadingAmp .* cos(pitchAngle+thetaList(ii));				
					ApplyBoundaryCondition(); 
					U_ = SolvingStaticLinearSystemEquations();
					complianceList(ii) = U_(freeDOFs_,1)' * (K_*U_(freeDOFs_,1));
					F_ = []; 
				end					
			case 'normal'
				projecOnXYplane = loadingCond_(:,2:4); projecOnXYplane(:,end) = 0;
				yawAngle = acos(projecOnXYplane*[1; 0; 0] ./ vecnorm(projecOnXYplane,2,2));
				minusY = find(projecOnXYplane(:,2)<0);
				yawAngle(minusY) = 2*pi-yawAngle(minusY);
				rotationOpt = 'pitch'; %%'pitch', 'yaw'	. WATCH OUT !!!				
				for ii=1:numLoadSteps
					disp([' Progress.: ' sprintf('%4i %4i', [ii numLoadSteps] )]);
					switch rotationOpt
						case 'pitch'
							loadingCond_(:,2) = loadingAmp .* sin(pitchAngle+thetaList(ii)) .* cos(yawAngle);
							loadingCond_(:,3) = loadingAmp .* sin(pitchAngle+thetaList(ii)) .* sin(yawAngle);
							loadingCond_(:,4) = loadingAmp .* cos(pitchAngle+thetaList(ii));							
						case 'yaw'
							loadingCond_(:,2) = loadingAmp .* sin(pitchAngle) .* cos(yawAngle+thetaList(ii));
							loadingCond_(:,3) = loadingAmp .* sin(pitchAngle) .* sin(yawAngle+thetaList(ii));
							loadingCond_(:,4) = loadingAmp .* cos(pitchAngle);						
					end		
					ApplyBoundaryCondition(); 
					U_ = SolvingStaticLinearSystemEquations();
					complianceList(ii) = U_(freeDOFs_,1)' * (K_*U_(freeDOFs_,1));
					F_ = []; 
				end				
				
		end
	end
	disp(['Perform Robustness Test Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	
	%%recover loading condtion
	% loadingCond_ = oriLoadingCond;
	
	figure; plot(thetaList/pi*180, complianceList, '-r', 'LineWidth', 3);
	xlabel('Force rotation angle'); ylabel('Compliance');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
end
