function ComputeCartesianStress()	
	%% sigma_x, sigma_y, sigma_z, tadisyz, tadiszx, tadisxy (solid)
	%%NOTE: Outer Interpolate the stress at Gauss Points to Nodes by Element Stress Interpolation Matrix --- Ns
	%% stress_GaussPoints = Ns * stress_Nodes -> stress_Nodes = inv(Ns) * stress_GaussPoints
	global eleType_;
	global meshType_;
	global numEles_; 
	global numNodes_ nodeCoords_; 
	global eNodMat_; 
	global eDofMat_;
	global numNodsAroundEleVec_;
	global matrixD_;
	global matrixDb_;
	global deShapeFuncs_;
	global invJ_;
	global U_;
	global align2GlobalFrameElement_;
	global shellThicknessList_;
	global cartesianStressField_;
	global cartesianStressField_;
	
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
			cartesianStressField_ = zeros(numNodes_, 6);	
			c = 1; %% 0: mid-surface; 1: top; -1: bottom
			for ii=1:numEles_
				t = shellThicknessList_(ii);
				iEleU = U_(eDofMat_(ii,:),1);
				iEleUlocal = align2GlobalFrameElement_(:,:,ii)' * iEleU;
				[iMatrixBm, iMatrixBb, ~] = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr, N);					
				stressGaussPointsLocal = matrixD_(ii).arr * (iMatrixBm*iEleUlocal + c*t/2*iMatrixBb*iEleUlocal); %%Membrane
				stressGaussPointsLocal = reshape(stressGaussPointsLocal, 3, eleType_.nEleNodes)';
				iNodes = eNodMat_(ii,1:3); iEleNodeCoords = nodeCoords_(iNodes,:);
				gpLocalFrames = zeros(3,3,3);
				for jGP=1:3
					[gpLocalFrames(:,:,jGP), ~, ~, ~] = ComputeLocalFrameAtGivenPosition(gaussPts(jGP,:), iEleNodeCoords);
				end				
				stressGaussPointsGlobal = GlobalFrame2Local_StressTensor(stressGaussPointsLocal, gpLocalFrames, 0);
				stressNodesGlobal = OTP*reshape(stressGaussPointsGlobal', numel(stressGaussPointsGlobal), 1); 
				stressNodesGlobal = reshape(stressNodesGlobal, 6, 3)';
				cartesianStressField_(iNodes,:) = stressNodesGlobal + cartesianStressField_(iNodes,:);				
			end
		case 'Shell144'
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussPts);
			Ns = GetElementStressInterpolationMatrix(); OTP = inv(Ns);
			cartesianStressField_ = zeros(numNodes_, 6); %%to be confirmed
			c = 1; %% 0: mid-surface; 1: top; -1: bottom
			parasNodes = [-1 -1; 1.0 -1; 1 1.0; -1.0 1.0];
			for ii=1:numEles_
				t = shellThicknessList_(ii);
				iEleU = U_(eDofMat_(ii,:),1);
				[iMatrixBm, iMatrixBb, ~] = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr, N);
				iNodes = eNodMat_(ii,1:4); iEleNodeCoords = nodeCoords_(iNodes,:);
				stressGaussPointsGlobal = zeros(4,6);
				for jGP=1:4
					ijEleUlocal = align2GlobalFrameElement_(:,:,jGP,ii)' * iEleU;
					jBm = iMatrixBm((jGP-1)*3+1:jGP*3,:); jDm = matrixD_(ii).arr((jGP-1)*3+1:jGP*3,(jGP-1)*3+1:jGP*3);
					jBb = iMatrixBb((jGP-1)*3+1:jGP*3,:); 
					stressGaussPointsLocal = jDm * (jBm*ijEleUlocal + c*t/2*jBb*ijEleUlocal); %%Membrane
					[igpLocalFrames, ~, ~, ~] = ComputeLocalFrameAtGivenPosition(gaussPts(jGP,:), iEleNodeCoords);
					stressGaussPointsGlobal(jGP,:) = GlobalFrame2Local_StressTensor(stressGaussPointsLocal(:)', igpLocalFrames, 0);
				end
				stressNodesGlobal = OTP*reshape(stressGaussPointsGlobal', numel(stressGaussPointsGlobal), 1);
				stressNodesGlobal = reshape(stressNodesGlobal, 6, 4)';
				cartesianStressField_(iNodes,:) = stressNodesGlobal + cartesianStressField_(iNodes,:);	
			end
    end
	cartesianStressField_ = cartesianStressField_./numNodsAroundEleVec_;
end