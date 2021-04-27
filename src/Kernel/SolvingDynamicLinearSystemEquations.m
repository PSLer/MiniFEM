function X = SolvingDynamicLinearSystemEquations(iFreq)
	global eleType_;
	global K_; global M_; global T_;
	global F_;
	global freeDOFs_; global numDOFs_;
	global preconditionerL_; global preconditionerU_;
	global GPU_;
	global gpuT_;
	X = zeros(numDOFs_,1);
	
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		climactericDOF = 2.0e6;
	elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		climactericDOF = 1.0e5;
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell133')
		climactericDOF = 1.0e6;
	end
	
	T_ = (K_-(2*pi*iFreq)^2*M_);
	if numDOFs_<climactericDOF
		X(freeDOFs_) = T_\F_;
	else	
		if strcmp(GPU_, 'ON')
			[gpuT_, opt] = PartitionMission4GPU(T_);
			if opt
				X(freeDOFs_) = myCG_GPU(gpuT_, F_, 'printP_ON');
			else
				[preconditionerL_, preconditionerU_] = ilu(T_);
				Preconditioning = @(x) preconditionerU_\(preconditionerL_\x);
				ATX = @(x) T_*x;
				% X(freeDOFs_) = myGMRES(ATX, Preconditioning, F_, 'printP_ON');
				X(freeDOFs_) = myCG(ATX, Preconditioning, F_, 'printP_ON');	
			end
		else
			[preconditionerL_, preconditionerU_] = ilu(T_);
			Preconditioning = @(x) preconditionerU_\(preconditionerL_\x);
			ATX = @(x) T_*x;
			% X(freeDOFs_) = myGMRES(ATX, Preconditioning, F_, 'printP_ON');
			X(freeDOFs_) = myCG(ATX, Preconditioning, F_, 'printP_ON');
		end		
	end	
end
