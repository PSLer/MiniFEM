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
	global Tlist_;
	global shellThicknessList_;
	global cartesianStressField_;
	global cartesianStressFieldGlobal_;
	
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
			cartesianStressFieldGlobal_ = zeros(numNodes_, 6);	
			c = 1; %% 0: mid-surface; 1: top; -1: bottom
			for ii=1:numEles_
				t = shellThicknessList_(ii);
				iEleU = U_(eDofMat_(ii,:),1);
				iEleUlocal = Tlist_(:,:,ii)' * iEleU;
				[iMatrixB, iMatrixBb, ~] = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr, N);					
				stressGaussPointsLocal = matrixD_(ii).arr * (iMatrixB*iEleUlocal + c*t/2*iMatrixBb*iEleUlocal); %%Membrane
				stressGaussPointsLocal = reshape(stressGaussPointsLocal, 3, eleType_.nEleNodes)';
				parasNodes = [0.0 0.0; 1.0 0.0; 0.0 1.0];
				iNodes = eNodMat_(ii,1:3); iEleNodeCoords = nodeCoords_(iNodes,:);
				nodeLocalFrames = zeros(3,3,3);
				for jj=1:3
					[nodeLocalFrames(:,:,jj), ~, ~, ~] = ComputeLocalFrameAtGivenPosition(parasNodes(jj,:), iEleNodeCoords);
				end				
				stressGaussPointsGlobal = GlobalFrame2Local_StressTensor(stressGaussPointsLocal, nodeLocalFrames, 0);
				stressNodesGlobal = OTP*reshape(stressGaussPointsGlobal', numel(stressGaussPointsGlobal), 1); 
				stressNodesGlobal = reshape(stressNodesGlobal, 6, 3)';
				cartesianStressFieldGlobal_(iNodes,:) = stressNodesGlobal + cartesianStressFieldGlobal_(iNodes,:);				
			end
		case 'Shell144'
			cartesianStressField_ = zeros(numNodes_, 6); %%to be confirmed
			Ns = GetElementStressInterpolationMatrix(); OTP = inv(Ns);
    end
	cartesianStressFieldGlobal_ = cartesianStressFieldGlobal_./numNodsAroundEleVec_;
end