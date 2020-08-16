function X = SolvingStaticFEM(printP)
	global domainType_;
	global advancedSolvingOpt_;
	global K_; global F_; global freeDofs_; global numDOFs_;
	X = zeros(numDOFs_,1);
	
	if (strcmp(domainType_, '3D')&numDOFs_>1.0e5) || strcmp(advancedSolvingOpt_, 'SpacePriority')
		global tol_; global maxIT_; global preCond_; global Lp_; global GPU_;
		preCondState = strcmp(preCond_, 'ON') & strcmp(advancedSolvingOpt_, 'TimePriority');
		Lp_ = 0;
		if strcmp(GPU_, 'ON') & strcmp(advancedSolvingOpt_, 'TimePriority');
			[gpuK opt] = TransferBigMat2GPU(K_);
			if 0==opt
				X(freeDofs_) = myCG_GPU(gpuK, F_(freeDofs_), tol_, maxIT_, printP);
			else
				if preCondState
					Lp_ = ichol(K_);	
					if strcmp(printP, 'printP_ON'), disp( 'Making preconditioner finished!' ); end
				end		
				X(freeDofs_) = myCG(@spStaticMtV, F_(freeDofs_), tol_, maxIT_, preCondState, printP);	
			end			
		else
			if preCondState
				Lp_ = ichol(K_);	
				if strcmp(printP, 'printP_ON'), disp( 'Making preconditioner finished!' ); end
			end		
			X(freeDofs_) = myCG(@spStaticMtV, F_(freeDofs_), tol_, maxIT_, preCondState, printP);
		end
	else
		X(freeDofs_) = K_\F_(freeDofs_);
	end	
end
