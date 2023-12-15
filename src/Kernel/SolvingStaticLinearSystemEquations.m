function X = SolvingStaticLinearSystemEquations(varargin)
	global eleType_;
	global K_; 
	global F_;
	global freeDOFs_; global numDOFs_;
	global preconditionerC_; 
	global GPU_;
	global gpuK_;
	
	if 0==nargin
		if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
			climactericDOF = 2.0e6;
		elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
			climactericDOF = 5.0e5;
		elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell133')
			climactericDOF = 1.0e6;
		else
			climactericDOF = 1.0e6;
		end
		if numDOFs_>climactericDOF
			solverType = 'ITERATIVE';
		else
			solverType = 'DIRECT';
		end
	else
		solverType = varargin{1};
	end
	
	X = zeros(numDOFs_,1);
	switch solverType
		case 'DIRECT'
			X(freeDOFs_) = K_\F_;
		case 'ITERATIVE'
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
