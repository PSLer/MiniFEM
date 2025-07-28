function ComputeCartesianStress()	
	%% sigma_x, sigma_y, sigma_z, tadisyz, tadiszx, tadisxy (solid)
	%%NOTE: Outer Interpolate the stress at Gauss Points to Nodes by Element Stress Interpolation Matrix --- Ns
	%% stress_GaussPoints = Ns * stress_Nodes -> stress_Nodes = inv(Ns) * stress_GaussPoints
	global eleType_;
	global meshType_;
	global numEles_; 
	global numNodes_; 
	global eNodMat_; 
	global eDofMat_;
	global numNodsAroundEleVec_;
	global matrixD_;
	global matrixDb_;
	global deShapeFuncs_;
	global invJ_;
	global U_;
	global cartesianStressField_;
	global cartesianStressField_ShellBend_;
	global cartesianStressFieldGlobal_;
	global cartesianStressFieldGlobal_ShellBend_;	
	global align2GlobalFrame_;
	
	switch eleType_.eleName 
		case 'Plane133'
			cartesianStressField_ = zeros(numNodes_, 3);
			Ns = GetElementStressInterpolationMatrix(); OTP = inv(Ns);
			if 1==length(matrixD_)
				iMatrixD = matrixD_.arr;
				for ii=1:numEles_
					iEleU = U_(eDofMat_(ii,:),1);
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
					stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
					stressNodes = OTP*stressGaussPoints;
					iNodes = eNodMat_(ii,:);
					cartesianStressField_(iNodes,:) = reshape(stressNodes, 3, 3)' + cartesianStressField_(iNodes,:);
				end
			elseif numEles_==length(matrixD_)
				for ii=1:numEles_
					iEleU = U_(eDofMat_(ii,:),1);
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
					iMatrixD = matrixD_(ii).arr;
					stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
					stressNodes = OTP*stressGaussPoints;
					iNodes = eNodMat_(ii,:);
					cartesianStressField_(iNodes,:) = reshape(stressNodes, 3, 3)' + cartesianStressField_(iNodes,:);
				end			
			else
				error('Un-supported Material Property!');
			end
		case 'Plane144'
			cartesianStressField_ = zeros(numNodes_, 3);
			Ns = GetElementStressInterpolationMatrix(); OTP = inv(Ns);
			if 1==length(matrixD_)
				iMatrixD = matrixD_.arr;
				if strcmp(meshType_, 'Cartesian')
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_.arr);				
					for ii=1:numEles_
						iEleU = U_(eDofMat_(ii,:),1);
						stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
						stressNodes = OTP*stressGaussPoints;
						iNodes = eNodMat_(ii,:);
						cartesianStressField_(iNodes,:) = reshape(stressNodes, 3, 4)' + cartesianStressField_(iNodes,:);
					end					
				else
					for ii=1:numEles_
						iEleU = U_(eDofMat_(ii,:),1);
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
						stressNodes = OTP*stressGaussPoints;
						iNodes = eNodMat_(ii,:);
						cartesianStressField_(iNodes,:) = reshape(stressNodes, 3, 4)' + cartesianStressField_(iNodes,:);
					end					
				end
			elseif numEles_==length(matrixD_)
				for ii=1:numEles_
					iEleU = U_(eDofMat_(ii,:),1);
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
					iMatrixD = matrixD_(ii).arr;					
					stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
					stressNodes = OTP*stressGaussPoints;
					iNodes = eNodMat_(ii,:);
					cartesianStressField_(iNodes,:) = reshape(stressNodes, 3, 4)' + cartesianStressField_(iNodes,:);
				end				
			else
				error('Un-supported Material Property!');
			end			
		case 'Solid144'
			cartesianStressField_ = zeros(numNodes_, 6);
			Ns = GetElementStressInterpolationMatrix(); OTP = inv(Ns);
			iMatrixD = matrixD_.arr;
			for ii=1:numEles_
				iEleU = U_(eDofMat_(ii,:),1);
				iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
				stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
				stressNodes = OTP*stressGaussPoints;
				iNodes = eNodMat_(ii,:);
				cartesianStressField_(iNodes,:) = reshape(stressNodes, 6, 4)' + cartesianStressField_(iNodes,:);
			end			
		case 'Solid188'
			cartesianStressField_ = zeros(numNodes_, 6);
			Ns = GetElementStressInterpolationMatrix(); OTP = inv(Ns);
			if 1==length(matrixD_)
				iMatrixD = matrixD_.arr;
				if strcmp(meshType_, 'Cartesian')
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_.arr);
					for ii=1:numEles_
						iEleU = U_(eDofMat_(ii,:),1);
						stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
						stressNodes = OTP*stressGaussPoints;
						iNodes = eNodMat_(ii,:);
						cartesianStressField_(iNodes,:) = reshape(stressNodes, 6, 8)' + cartesianStressField_(iNodes,:);
					end					
				else
					for ii=1:numEles_
						iEleU = U_(eDofMat_(ii,:),1);
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
						stressNodes = OTP*stressGaussPoints;
						iNodes = eNodMat_(ii,:);
						cartesianStressField_(iNodes,:) = reshape(stressNodes, 6, 8)' + cartesianStressField_(iNodes,:);
					end					
				end
			elseif numEles_==length(matrixD_)
				for ii=1:numEles_
					iEleU = U_(eDofMat_(ii,:),1);
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
					iMatrixD = matrixD_(ii).arr;						
					stressGaussPoints = iMatrixD * (iMatrixB*iEleU);
					stressNodes = OTP*stressGaussPoints;
					iNodes = eNodMat_(ii,:);
					cartesianStressField_(iNodes,:) = reshape(stressNodes, 6, 8)' + cartesianStressField_(iNodes,:);
				end				
			else
				error('Un-supported Material Property!');
			end		
		case 'Shell133'
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussPts);		
			Ns = GetElementStressInterpolationMatrix(); OTP = inv(Ns);
			cartesianStressField_ = zeros(numNodes_, 3);
			cartesianStressField_ShellBend_ = zeros(numNodes_, 3);
			cartesianStressFieldGlobal_ = zeros(numNodes_, 6);
			cartesianStressFieldGlobal_ShellBend_ = zeros(numNodes_, 6);			
			stressNodesGlobal = zeros(3,6);
			stressNodes_bendGlobal = zeros(3,6);			
			for ii=1:numEles_
				iEleU = U_(eDofMat_(ii,:),1);
				[iMatrixB, iMatrixBb, ~] = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr, N);					
				stressGaussPoints = matrixD_(ii).arr * (iMatrixB*iEleU); %%Membrane
				stressGaussPoints_bend = matrixDb_(ii).arr * (iMatrixBb*iEleU); %%Bending
				stressNodes = OTP*stressGaussPoints; stressNodes = reshape(stressNodes, 3, 3)';
				stressNodes_bend = OTP*stressGaussPoints_bend; stressNodes_bend = reshape(stressNodes_bend, 3, 3)';
				iR = align2GlobalFrame_(:,:,ii);
				for jj=1:3
					iStressMembraneLocal = stressNodes(jj,:);
					iStressMembraneLocal = iStressMembraneLocal([1 3; 3 2]);
					iStressMembraneLocalTmp = zeros(3,3);
					iStressMembraneLocalTmp(1:2,1:2) = iStressMembraneLocal;
					iStressMembraneGlobal = iR * iStressMembraneLocalTmp * iR';
					stressNodesGlobal(jj,:) = iStressMembraneGlobal([1 5 9 6 3 2]);
					
					iStressBendingLocal = stressNodes_bend(jj,:);
					iStressBendingLocal = iStressBendingLocal([1 3; 3 2]);
					iStressBendingLocalTmp = zeros(3,3);
					iStressBendingLocalTmp(1:2,1:2) = iStressBendingLocal;
					iStressBendingGlobal = iR * iStressBendingLocalTmp * iR';
					stressNodes_bendGlobal(jj,:) = iStressBendingGlobal([1 5 9 6 3 2]);					
				end
				iNodes = eNodMat_(ii,:);
				cartesianStressField_(iNodes,:) = stressNodes + cartesianStressField_(iNodes,:);
				cartesianStressField_ShellBend_(iNodes,:) = stressNodes_bend + cartesianStressField_ShellBend_(iNodes,:);
				cartesianStressFieldGlobal_(iNodes,:) = stressNodesGlobal + cartesianStressFieldGlobal_(iNodes,:);
				cartesianStressFieldGlobal_ShellBend_(iNodes,:) = stressNodes_bendGlobal + cartesianStressFieldGlobal_ShellBend_(iNodes,:);				
			end
		case 'Shell144'
			cartesianStressField_ = zeros(numNodes_, 6); %%to be confirmed
			Ns = GetElementStressInterpolationMatrix(); OTP = inv(Ns);
	end
	cartesianStressField_ = cartesianStressField_./numNodsAroundEleVec_;
	cartesianStressField_ShellBend_ = cartesianStressField_ShellBend_./numNodsAroundEleVec_;
	cartesianStressFieldGlobal_ = cartesianStressFieldGlobal_./numNodsAroundEleVec_;
	cartesianStressFieldGlobal_ShellBend_ = cartesianStressFieldGlobal_ShellBend_./numNodsAroundEleVec_;	
end