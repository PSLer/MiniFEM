function X = SolvingStaticLinearSystemEquations()
	global eleType_;
	global K_; 
	global F_;
	global freeDOFs_; global numDOFs_;
	global preconditionerC_; 
	global GPU_;
	global gpuK_;
	X = zeros(numDOFs_,1);
	
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		climactericDOF = 2.0e6;
	elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		climactericDOF = 1.0e5;
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell133')
		climactericDOF = 1.0e6;
	end
	if numDOFs_<climactericDOF
		X(freeDOFs_) = K_\F_;
	else
		if strcmp(GPU_, 'ON')
			[gpuK_, opt] = PartitionMission4GPU(K_);
			if opt
				X(freeDOFs_) = myCG_GPU(gpuK_, F_, 'printP_ON');
			else
				preconditionerC_ = ichol(K_);
				Preconditioning = @(x) preconditionerC_'\(preconditionerC_\x);			
				ATX = @(x) K_*x;
				X(freeDOFs_) = myCG(ATX, Preconditioning, F_, 'printP_ON');
			end
		else
			preconditionerC_ = ichol(K_);
			Preconditioning = @(x) preconditionerC_'\(preconditionerC_\x);			
			ATX = @(x) K_*x;
			X(freeDOFs_) = myCG(ATX, Preconditioning, F_, 'printP_ON');		
		end
	end	
end
