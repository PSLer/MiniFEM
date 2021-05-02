function EvaluateMeshQuality()
	global eleType_;
	global meshType_;
	global numEles_;
	global eNodMat_;
	global nodeCoords_;	
	global detJ_;
	global invJ_;
	global deShapeFuncs_;
	global meshQualityJacobianRatio_;
	
	meshQualityJacobianRatio_ = ones(numEles_,1);
	switch eleType_.eleName
		case 'Plane133'
			nEN = eleType_.nEleNodes;
			nEND = eleType_.nEleNodeDOFs;
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			deShapeFuncs_ = DeShapeFunction(gaussIPs);					
			iInvJ = struct('arr', sparse(nEND*nEGIP,nEND*nEGIP));
			invJ_ = repmat(iInvJ, numEles_, 1);
			iDetJ = zeros(nEGIP,1);
			detJ_ = repmat(iDetJ,1,numEles_);
			for ii=1:numEles_
				probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
				for kk=1:nEGIP
					Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
					iInvJ.arr(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);
					iDetJ(kk) = det(Jac);	
				end
				invJ_(ii) = iInvJ;
				detJ_(:,ii) = iDetJ;
				meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
			end
		case 'Plane144'
			nEN = eleType_.nEleNodes;
			nEND = eleType_.nEleNodeDOFs;
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			deShapeFuncs_ = DeShapeFunction(gaussIPs);			
			iInvJ = struct('arr', sparse(nEND*nEGIP,nEND*nEGIP));
			iDetJ = zeros(nEGIP,1);
			if strcmp(meshType_, 'Cartesian')
				probeEleNods = nodeCoords_(eNodMat_(1,:)',:);
				for kk=1:nEGIP
					Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
					iInvJ.arr(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);
					iDetJ(kk) = det(Jac);	
				end
				invJ_ = iInvJ;
				detJ_ = iDetJ;			
			else
				invJ_ = repmat(iInvJ, numEles_, 1);
				detJ_ = repmat(iDetJ,1,numEles_);
				for ii=1:numEles_
					probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
					for kk=1:nEGIP
						Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
						iInvJ.arr(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);
						iDetJ(kk) = det(Jac);	
					end
					invJ_(ii) = iInvJ;
					detJ_(:,ii) = iDetJ;
					meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
				end				
			end
		case 'Solid144'
			nEN = eleType_.nEleNodes;
			nEND = eleType_.nEleNodeDOFs;
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;		
		case 'Solid188'
			nEN = eleType_.nEleNodes;
			nEND = eleType_.nEleNodeDOFs;
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			deShapeFuncs_ = DeShapeFunction(gaussIPs);			
			iInvJ = struct('arr', sparse(nEND*nEGIP,nEND*nEGIP));
			iDetJ = zeros(nEGIP,1);
			if strcmp(meshType_, 'Cartesian')
				probeEleNods = nodeCoords_(eNodMat_(1,:)',:);
				for kk=1:nEGIP
					Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
					iInvJ.arr(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);
					iDetJ(kk) = det(Jac);	
				end
				invJ_ = iInvJ;
				detJ_ = iDetJ;			
			else
				invJ_ = repmat(iInvJ, numEles_, 1);
				detJ_ = repmat(iDetJ,1,numEles_);
				for ii=1:numEles_
					probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
					for kk=1:nEGIP
						Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
						iInvJ.arr(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);
						iDetJ(kk) = det(Jac);	
					end
					invJ_(ii) = iInvJ;
					detJ_(:,ii) = iDetJ;
					meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
				end				
			end
		case 'Shell133'
		
		case 'Shell144'
		
	end
end