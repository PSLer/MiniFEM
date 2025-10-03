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
	global align2GlobalFrame_;
	global align2GlobalFrameElement_;
	
	meshQualityJacobianRatio_ = ones(numEles_,1);
	switch eleType_.eleName
		case 'Plane133'
			nEND = eleType_.nEleNodeDOFs;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			deShapeFuncs_ = DeShapeFunction(gaussPts);					
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
			nEND = eleType_.nEleNodeDOFs;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			deShapeFuncs_ = DeShapeFunction(gaussPts);			
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
			nEND = eleType_.nEleNodeDOFs;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			deShapeFuncs_ = DeShapeFunction(gaussPts);			
			iInvJ = struct('arr', sparse(nEND*nEGIP,nEND*nEGIP));
			iDetJ = zeros(nEGIP,1);
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
		case 'Solid188'
			nEND = eleType_.nEleNodeDOFs;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			deShapeFuncs_ = DeShapeFunction(gaussPts);			
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
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussPts);
			deShapeFuncs_ = DeShapeFunction(gaussPts);
			iInvJ = struct('arr', sparse(2*nEGIP, 2*nEGIP));
			invJ_ = repmat(iInvJ, numEles_, 1);
			iDetJ = zeros(nEGIP,1);
			detJ_ = repmat(iDetJ,1,numEles_);
			align2GlobalFrame_ = zeros(3,3,numEles_);
			align2GlobalFrameElement_ = zeros(18,18,numEles_);
			for ii=1:numEles_
				iEleCoords = nodeCoords_(eNodMat_(ii,:),:);
				[R, origin, t1, t2] = ComputeLocalFrameAtGivenPosition([1/3 1/3], iEleCoords);
				align2GlobalFrame_(:,:,ii) = R;
				Rnode = blkdiag(R, R); % 3×3 block diagonal
				Relement = blkdiag(Rnode, Rnode, Rnode); % 18×18
				align2GlobalFrameElement_(:,:,ii) = Relement;
				xl = GlobalFrame2Local_Coords(iEleCoords, R, origin, 1);
				for jj=1:nEGIP
					% Shape function derivatives in natural coords
					idNdPara = deShapeFuncs_(2*(jj-1)+1:2*jj,:);
					% Jacobian
					Jac = idNdPara * xl(:,1:2);
					detJ_(jj,ii) = det(Jac);
					invJ_(ii).arr(2*(jj-1)+1:2*jj,2*(jj-1)+1:2*jj) = inv(Jac);
                end
				meshQualityJacobianRatio_(ii) = min(detJ_(:,ii)) / max(detJ_(:,ii));
			end
		case 'Shell144'
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussPts);
			deShapeFuncs_ = DeShapeFunction(gaussPts);
			iInvJ = struct('arr', sparse(2*nEGIP, 2*nEGIP));
			invJ_ = repmat(iInvJ, numEles_, 1);
			iDetJ = zeros(nEGIP,1);
			detJ_ = repmat(iDetJ,1,numEles_);
			% global JacList_; JacList_ = invJ_;
			% align2GlobalFrame_ = zeros(3,3,numEles_);
			align2GlobalFrameElement_ = zeros(24, 24, 4, numEles_);
			for ii=1:numEles_
				iEleCoords = nodeCoords_(eNodMat_(ii,:),:);
				iR = zeros(6,6,4);
				for jj=1:nEGIP
					jPara = gaussPts(jj,:);
					[jR, origin, t1, t2] = ComputeLocalFrameAtGivenPosition(jPara, iEleCoords); 
					xl = GlobalFrame2Local_Coords(iEleCoords, jR, origin, 1);
					% Shape function derivatives in natural coords
					idNdPara = deShapeFuncs_(2*(jj-1)+1:2*jj,:);
                    % a1a2 = idNdPara*iEleCoords;
					% e1 = jR(:,1); e2 = jR(:,2);
					% Jac = [a1a2(1,:)*e1 a1a2(2,:)*e1; a1a2(1,:)*e2 a1a2(2,:)*e2];
					% JacList_(ii).arr(2*(jj-1)+1:2*jj,2*(jj-1)+1:2*jj) = Jac;
					Jac = idNdPara * xl(:,1:2);
					detJ_(jj,ii) = det(Jac);
					invJ_(ii).arr(2*(jj-1)+1:2*jj,2*(jj-1)+1:2*jj) = inv(Jac);
					Rnode = blkdiag(jR,jR);	
					align2GlobalFrameElement_(:,:,jj,ii) = blkdiag(Rnode, Rnode, Rnode, Rnode);
				end			
				meshQualityJacobianRatio_(ii) = min(detJ_(:,ii)) / max(detJ_(:,ii));
			end
	end
end


