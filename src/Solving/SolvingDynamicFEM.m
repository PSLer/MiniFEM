function X = SolvingDynamicFEM(printP)
	global domainType_;
	global K_; global M_; global T_;
	global Ke_; global Me_; global Te_;
	global F_; global freeDofs_; global numDOFs_;
	global advancedSolvingOpt_;
	global iFreq_;
	
	X = zeros(numDOFs_,1);
	switch advancedSolvingOpt_
		case 'SpacePriority'
			Te_ = (Ke_-(2*pi*iFreq_)^2*Me_);
		case 'TimePriority'
			T_ = (K_-(2*pi*iFreq_)^2*M_);
	end
	if (strcmp(domainType_, '3D') & numDOFs_>1.0e5) || ...
		strcmp(advancedSolvingOpt_, 'SpacePriority')
		global tol_; global maxIT_; global preCond_; global Lp_; global Up_; global GPU_;
		restart = 500; 	
		preCondState = strcmp(preCond_, 'ON') & strcmp(advancedSolvingOpt_, 'TimePriority');
		Lp_ = 0; Up_ = 0;
		if strcmp(GPU_, 'ON') & strcmp(advancedSolvingOpt_, 'TimePriority');
			[gpuT opt] = TransferBigMat2GPU(T_);
			if 0==opt
				X(freeDofs_) = myCG_GPU(gpuT, F_(freeDofs_), tol_, maxIT_, printP);
			else
				if preCondState
					setup.type = 'nofill';  setup.milu = 'off';
					[Lp_,Up_] = ilu(T_,setup);		
					if strcmp(printP, 'printP_ON'), disp( 'Making preconditioner finished!' ); end
				end		
				X(freeDofs_) = myCG(@spDynamicMtV, F_(freeDofs_), tol_, maxIT_, preCondState, printP);	
			end				
		else
			if preCondState
				setup.type = 'nofill';  setup.milu = 'off';
				[Lp_,Up_] = ilu(T_,setup);			
				if strcmp(printP, 'printP_ON'), disp( 'Making preconditioner finished!' ); end
			end		
			X(freeDofs_) = myCG(@spDynamicMtV, F_(freeDofs_), tol_, maxIT_, preCondState, printP);
			%X(freeDofs_) = myGmres(@spDynamicMtV, F_(freeDofs_), restart, tol_, maxIT_, preCondState, Lp, Up, printP);		
		end
	else
		X(freeDofs_) = T_\F_(freeDofs_);
	end
	clearvars -global T_
end