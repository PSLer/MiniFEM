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
	global shellAreaList_;
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
			% warning('Still under Debugging!!!');
			nEGIP = eleType_.nEleGaussIntegralPoints;
			gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussPts);
			deShapeFuncs_ = DeShapeFunction(gaussPts);
			iInvJ = struct('arr', sparse(2*nEGIP, 2*nEGIP));
			invJ_ = repmat(iInvJ, numEles_, 1);
			iDetJ = zeros(nEGIP,1);
			detJ_ = repmat(iDetJ,1,numEles_);
			align2GlobalFrame_ = zeros(3,3,numEles_);
			shellAreaList_ = zeros(numEles_,1);
			implOld = 0;
			for ii=1:numEles_
				iEleCoords = nodeCoords_(eNodMat_(ii,:),:);
				if implOld
					v1 = iEleCoords(2,:) - iEleCoords(1,:);
					v2 = iEleCoords(3,:) - iEleCoords(1,:);
					origin = iEleCoords(1,:);
					e1 = v1 / norm(v1);
					e3 = cross(v1, v2); e3 = e3 / norm(e3);
					e2 = cross(e3, e1);
					R = [e1(:), e2(:), e3(:)]; % use columns = basis vectors, i.e. local-to-global
				else
					[R, origin, t1, t2] = ComputeLocalFrameAtGivenPosition([1/3 1/3], iEleCoords);
				end
				align2GlobalFrame_(:,:,ii) = R;
				if implOld
					xl = R' * (iEleCoords - origin)';					
				else
					xl = GlobalFrame2Local_Coords(iEleCoords, R, origin, 1);
				end
				% xl = xl';
				% shellAreaList_(ii) = 0.5 * norm(cross(xl(2,:) - xl(1,:), xl(3,:) - xl(1,:)));
				for jj=1:nEGIP
					% Shape functions
					iN = N(jj,:);
					% Shape function derivatives in natural coords
					idNdPara = deShapeFuncs_(2*(jj-1)+1:2*jj,:);
					% Jacobian
					J = idNdPara * xl(:,1:2);
					detJ_(jj,ii) = det(J);
					invJ_(ii).arr(2*(jj-1)+1:2*jj,2*(jj-1)+1:2*jj) = inv(J);
                end
                shellAreaList_(ii) = 0.5*detJ_(1,ii);
			end
			meshQualityJacobianRatio_ = ones(numEles_,1);
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% nEND = eleType_.nEleNodeDOFs;
			% nEGIP = eleType_.nEleGaussIntegralPoints;
			% gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			% deShapeFuncs_ = DeShapeFunction(gaussPts);					
			% iInvJ = struct('arr', sparse(3*nEGIP,3*nEGIP));
			% invJ_ = repmat(iInvJ, numEles_, 1);
			% iDetJ = zeros(nEGIP,1);
			% detJ_ = repmat(iDetJ,1,numEles_);
			% for ii=1:numEles_
				% probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
				% for kk=1:nEGIP
					% Jac = deShapeFuncs_(3*(kk-1)+1:3*kk,:)*probeEleNods;
					% iInvJ.arr(3*(kk-1)+1:3*kk, 3*(kk-1)+1:3*kk) = inv(Jac);
					% iDetJ(kk) = det(Jac);	
				% end
				% invJ_(ii) = iInvJ;
				% detJ_(:,ii) = iDetJ;
				% meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
			% end		
		case 'Shell144'
			% nEGIP = eleType_.nEleGaussIntegralPoints;
			% gaussPts = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			% deShapeFuncs_ = DeShapeFunction(gaussPts);			
			% iInvJ = struct('arr', sparse(3*nEGIP,3*nEGIP));
			% iDetJ = zeros(nEGIP,1);
			% invJ_ = repmat(iInvJ, numEles_, 1);
			% detJ_ = repmat(iDetJ,1,numEles_);
			% for ii=1:numEles_
				% probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
				% for kk=1:nEGIP
					% Jac = deShapeFuncs_(3*(kk-1)+1:3*kk,:)*probeEleNods;
					% iInvJ.arr(3*(kk-1)+1:3*kk, 3*(kk-1)+1:3*kk) = inv(Jac);
					% iDetJ(kk) = det(Jac);	
				% end
				% invJ_(ii) = iInvJ;
				% detJ_(:,ii) = iDetJ;
				% meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
			% end		
	end
end


