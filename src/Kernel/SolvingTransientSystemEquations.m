function X = SolvingTransientSystemEquations(stepSize, numTimeStep, varargin)
	global eleType_;
	global K_; global M_;
	global F_;
	global freeDOFs_; global numDOFs_;
	global displacmentHistory_;
	global velocityHistory_;
	global accelerationHistory_;
	global timeAxis_;
	global preconditionerL_; global preconditionerU_;
	%%Newmark
	
	if 2==nargin
		solvingScheme = 'Implicit';
	else
		solvingScheme = varargin{1};
	end
	displacmentHistory_ = zeros(numDOFs_, 1+numTimeStep);
	velocityHistory_ = displacmentHistory_;
	accelerationHistory_ = displacmentHistory_;
	timeAxis_ = (0:1:numTimeStep) * stepSize;
	diagM = diag(M_);
	condensedMvec = sum(M_,2);
	condensedMmat = diag(condensedMvec);
	switch solvingScheme
		case 'Explicit'
			for ii=1:numel(timeAxis_)
				% disp(['Integration: ' sprintf('%6i',ii-1) ' Total.: ' sprintf('%6i',numel(timeAxis_)-1)]);
				disp(['Time: ' sprintf('%.6e',timeAxis_(ii)) ' of ' sprintf('%.6e',timeAxis_(end))]);
				if 1==ii
					accelerationHistory_(freeDOFs_,ii) = -((K_*displacmentHistory_(freeDOFs_,ii))./condensedMvec) + F_./condensedMvec;
				else
					iRHS = F_ - K_*(displacmentHistory_(freeDOFs_,ii-1) + stepSize*velocityHistory_(freeDOFs_,ii-1) + ...
						1/2*stepSize^2*accelerationHistory_(freeDOFs_,ii-1));
					accelerationHistory_(freeDOFs_,ii) = iRHS ./ condensedMvec;
					displacmentHistory_(freeDOFs_,ii) = displacmentHistory_(freeDOFs_,ii-1) + stepSize^2*velocityHistory_(freeDOFs_,ii-1) .* ...
						accelerationHistory_(freeDOFs_,ii-1);
					velocityHistory_(freeDOFs_,ii) = velocityHistory_(freeDOFs_,ii-1) + stepSize*accelerationHistory_(freeDOFs_,ii-1);					
				end
			end
		case 'Implicit'
			if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
				climactericDOF = 2.0e6;
			elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
				climactericDOF = 5.0e5;
			elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell133')
				climactericDOF = 1.0e6;
			end
			if numDOFs_>climactericDOF
				solverType = 'ITERATIVE';
			else
				solverType = 'DIRECT';
			end
			beta1 = 1/2; beta2 = 1/2;
			Tmat = condensedMmat + 1/2 * stepSize^2 * beta2*K_;
			switch solverType
				case 'DIRECT'
					[Lfac_, Ufac_, Pfac_, Qfac_, Rfac_] = lu(Tmat);	
					for ii=1:numel(timeAxis_)
						% disp(['Integration: ' sprintf('%6i',ii-1) ' Total.: ' sprintf('%6i',numel(timeAxis_)-1)]);
						disp(['Time: ' sprintf('%.6e',timeAxis_(ii)) ' of ' sprintf('%.6e',timeAxis_(end))]);
						if 1==ii
							accelerationHistory_(freeDOFs_,ii) = -((K_*displacmentHistory_(freeDOFs_,ii))./condensedMvec) + F_./condensedMvec;
						else
							iRHS = F_ - K_*(displacmentHistory_(freeDOFs_,ii-1) + stepSize*velocityHistory_(freeDOFs_,ii-1) + ...
								1/2*stepSize^2*(1-beta2)*accelerationHistory_(freeDOFs_,ii-1));
							accelerationHistory_(freeDOFs_,ii) = Qfac_*(Ufac_\(Lfac_\(Pfac_*(Rfac_\iRHS))));
							displacmentHistory_(freeDOFs_,ii) = displacmentHistory_(freeDOFs_,ii-1) + stepSize^2*velocityHistory_(freeDOFs_,ii-1) .* ...
								((1-beta2)*accelerationHistory_(freeDOFs_,ii-1) + beta2*accelerationHistory_(freeDOFs_,ii));
							velocityHistory_(freeDOFs_,ii) = velocityHistory_(freeDOFs_,ii-1) + stepSize* ...
								((1-beta1)*accelerationHistory_(freeDOFs_,ii-1) + beta1*accelerationHistory_(freeDOFs_,ii));
						end
					end				
				case 'ITERATIVE'					
					[preconditionerL_, preconditionerU_] = ilu(Tmat);
					Preconditioning = @(x) preconditionerU_\(preconditionerL_\x);
					ATX = @(x) Tmat*x;					
					for ii=1:numel(timeAxis_)
						% disp(['Integration: ' sprintf('%6i',ii-1) ' Total.: ' sprintf('%6i',numel(timeAxis_)-1)]);
						disp(['Time: ' sprintf('%.6e',timeAxis_(ii)) ' of ' sprintf('%.6e',timeAxis_(end))]);
						if 1==ii
							accelerationHistory_(freeDOFs_,ii) = -((K_*displacmentHistory_(freeDOFs_,ii))./condensedMvec) + F_./condensedMvec;
						else
							iRHS = F_ - K_*(displacmentHistory_(freeDOFs_,ii-1) + stepSize*velocityHistory_(freeDOFs_,ii-1) + ...
								1/2*stepSize^2*(1-beta2)*accelerationHistory_(freeDOFs_,ii-1));
							% accelerationHistory_(freeDOFs_,ii) = myGMRES(ATX, Preconditioning, iRHS, 'printP_OFF');
							accelerationHistory_(freeDOFs_,ii) = myCG(ATX, Preconditioning, iRHS, 'printP_OFF');							
							displacmentHistory_(freeDOFs_,ii) = displacmentHistory_(freeDOFs_,ii-1) + stepSize^2*velocityHistory_(freeDOFs_,ii-1) .* ...
								((1-beta2)*accelerationHistory_(freeDOFs_,ii-1) + beta2*accelerationHistory_(freeDOFs_,ii));
							velocityHistory_(freeDOFs_,ii) = velocityHistory_(freeDOFs_,ii-1) + stepSize* ...
								((1-beta1)*accelerationHistory_(freeDOFs_,ii-1) + beta1*accelerationHistory_(freeDOFs_,ii));
						end
					end						
			end
	end
	X = displacmentHistory_(:,end);
end
