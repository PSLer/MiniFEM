function complianceList = StiffnessTest_VaryingLoadingDir(varargin)
	global domainType_;
	global K_; global F_; global U_;  
	global freeDofs_;
	global loadingCond_;
	if 0==nargin		
		Deformation();
		tmp = U_(freeDofs_); complianceList = tmp'*(K_*tmp);
	else			
		switch domainType_
			case '2D'
				visType = 'EleVis';
				amps = vecnorm(loadingCond_(:,3:end),2,2);	
				thetaX = acos(loadingCond_(:,3)./amps);
				thetaY = acos(loadingCond_(:,4)./amps)-pi;
			case '3D'
				visType = 'outlineVis';
				amps = vecnorm(loadingCond_(:,4:end),2,2);
				thetaX = acos(loadingCond_(:,4)./amps);
				thetaY = acos(loadingCond_(:,5)./amps);
				thetaZ = acos(loadingCond_(:,6)./amps);
		end
		varyRange = 180;
		loadingSteps = 0:varargin{1}:varyRange; loadingSteps = flip(loadingSteps);
		numLoadingSteps = length(loadingSteps);
		complianceList = zeros(1,numLoadingSteps);
		for ii=1:numLoadingSteps			
			iRad = loadingSteps(ii)/180*pi;
			if strcmp(domainType_, '2D')
				loadingCond_(:,3) = amps .* cos(thetaX+iRad);
				loadingCond_(:,4) = amps .* cos(thetaY+iRad);
			else
				loadingCond_(:,4) = amps .* cos(thetaX+iRad);
				loadingCond_(:,5) = amps .* cos(thetaY+iRad);
				loadingCond_(:,6) = amps .* cos(thetaZ+iRad);
			end
			ApplyLoads();
			U_ = []; Deformation();
			tmp = U_(freeDofs_); complianceList(ii) = tmp'*(K_*tmp);
			
			figure; VisualizingProblemDescription(visType);
		end
		figure; plot(loadingSteps, complianceList, '-xk', 'LineWidth', 2, 'MarkerSize', 10);
	end
end