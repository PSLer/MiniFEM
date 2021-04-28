function AssembleStiffnessMatrix()
	global material_;
	global eleType_;
	global meshType_;
	global numEles_;
	global numDOFs_;
	global freeDOFs_;
	global eNodMat_;
	global eDofMat_;
	global nodeCoords_;
	global matrixD_;
	global matrixB_;
	global detJ_;
	global deShapeFuncs_;
	global meshQualityJacobianRatio_;
	global K_;
	
	if isempty(freeDOFs_), warning('Apply for Boundary Condition First!'); return; end
	meshQualityJacobianRatio_ = ones(numEles_,1);
	K_ = sparse(numDOFs_,numDOFs_);
	switch eleType_.eleName
		case 'Plane133'
			nEN = eleType_.nEleNodes;
			nEND = eleType_.nEleNodeDOFs;
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
	
			blockIndex = PartitionMission4CPU(numEles_, 5.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';
			deShapeFuncs_ = DeShapeFunction(gaussIPs);		
			invJ = zeros(nEND*nEGIP,nEND*nEGIP);
			if 1==length(material_.modulus) && 1==length(material_.poissonRatio)
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);	
				detJ_ = zeros(nEGIP,numEles_);
				iDetJ = zeros(nEGIP,1);
				matrixB_ = zeros(nESC*nEGIP, nEND*nEGIP); matrixB_ = repmat(matrixB_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(17, length(rangeIndex)); %%17 is based on the feature of element stiffness matrix of 'Plane133'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
						for kk=1:nEGIP
							Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
							iDetJ(kk) = det(Jac);
							invJ(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);							
						end
						detJ_(:,ii) = iDetJ;
						meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ);;
						matrixB_(:,:,ii) = iMatrixB;
						Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, iDetJ);
						semiKe = tril(Ke); 
						[eKi, eKj, eKs] = find(semiKe);				
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end				
			elseif numEles_==length(material_.modulus) && numEles_==length(material_.poissonRatio)
				detJ_ = zeros(nEGIP,numEles_);
				iDetJ = zeros(nEGIP,1);
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				matrixB_ = zeros(nESC*nEGIP, nEND*nEGIP); matrixB_ = repmat(matrixB_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(17, length(rangeIndex)); %%17 is based on the feature of element stiffness matrix of 'Plane133'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
						for kk=1:nEGIP
							Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
							iDetJ(kk) = det(Jac);
							invJ(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);							
						end
						detJ_(:,ii) = iDetJ;
						meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
						iMatrixB = ElementStrainMatrix(dShape_, invJ_(ii,1).SPmat);;
						matrixB_(:,:,ii) = iMatrixB;
						iMatrixD = ElementElasticityMatrix(material_.modulus(ii), material_.poissonRatio(ii));	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, iDetJ);				
						semiKe = tril(Ke); 
						[eKi, eKj, eKs] = find(semiKe);				
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end				
			else
				error('Un-supported Material Property!');			
			end
		case 'Plane144'
			nEN = eleType_.nEleNodes;
			nEND = eleType_.nEleNodeDOFs;
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			
			blockIndex = PartitionMission4CPU(numEles_, 5.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';
			deShapeFuncs_ = DeShapeFunction(gaussIPs);		
			invJ = zeros(nEND*nEGIP,nEND*nEGIP);			
			if 1==length(material_.modulus) && 1==length(material_.poissonRatio)			
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);				
				if strcmp(meshType_, 'Cartesian')
					detJ_ = zeros(nEGIP,1);
					for jj=1:nEGIP
						probeEleNods = nodeCoords_(eNodMat_(1,:)',:);
						Jac = deShapeFuncs_(nEND*(jj-1)+1:nEND*jj,:)*probeEleNods;
						detJ_(jj) = det(Jac);
						invJ(nEND*(jj-1)+1:nEND*jj, nEND*(jj-1)+1:nEND*jj) = inv(Jac);
					end
					matrixB_ = ElementStrainMatrix(deShapeFuncs_, invJ);
					Ke = ElementStiffMatrix(matrixB_, matrixD_.arr, wgts, detJ_);
					semiKe = tril(Ke); 
					[eKi, eKj, eKs] = find(semiKe);
					for ii=1:size(blockIndex,1)
						rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
						sK = repmat(eKs, 1, length(rangeIndex));
						iK = eDofMat_(rangeIndex,eKi)';
						jK = eDofMat_(rangeIndex,eKj)';
						tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);					
						tmpK = tmpK + tmpK' - diag(diag(tmpK));
						K_ = K_ + tmpK;					
					end
				else
					detJ_ = zeros(nEGIP,numEles_);
					iDetJ = zeros(nEGIP,1);
					matrixB_ = zeros(nESC*nEGIP, nEND*nEGIP); matrixB_ = repmat(matrixB_, 1, 1, numEles_);
					for jj=1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sK = zeros(8*(8+1)/2, length(rangeIndex)); %%Ke = 8-by-8
						index = 0;
						for ii=rangeIndex(1):rangeIndex(end)
							index = index + 1;
							probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
							for kk=1:nEGIP
								Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
								iDetJ(kk) = det(Jac);
								invJ(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);							
							end
							detJ_(:,ii) = iDetJ;
							meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
							iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ);;
							matrixB_(:,:,ii) = iMatrixB;
							Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, iDetJ);
							semiKe = tril(Ke); 
							[eKi, eKj, eKs] = find(semiKe);				
							sK(:,index) = eKs;				
						end
						iK = eDofMat_(rangeIndex,eKi)';
						jK = eDofMat_(rangeIndex,eKj)';
						tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
						tmpK = tmpK + tmpK' - diag(diag(tmpK));
						K_ = K_ + tmpK;
					end
				end			
			elseif numEles_==length(material_.modulus) && numEles_==length(material_.poissonRatio)
				detJ_ = zeros(nEGIP,numEles_);
				iDetJ = zeros(nEGIP,1);
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				matrixB_ = zeros(nESC*nEGIP, nEND*nEGIP); matrixB_ = repmat(matrixB_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(8*(8+1)/2, length(rangeIndex)); %%Ke = 8-by-8
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
						for kk=1:nEGIP
							Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
							iDetJ(kk) = det(Jac);
							invJ(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);							
						end
						detJ_(:,ii) = iDetJ;
						meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
						iMatrixB = ElementStrainMatrix(dShape_, invJ_(ii,1).SPmat);;
						matrixB_(:,:,ii) = iMatrixB;
						iMatrixD = ElementElasticityMatrix(material_.modulus(ii), material_.poissonRatio(ii));	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, iDetJ);				
						semiKe = tril(Ke); 
						[eKi, eKj, eKs] = find(semiKe);				
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end				
			else
				error('Un-supported Material Property!');
			end
		case 'Solid144'
		
		case 'Solid188'
			nEN = eleType_.nEleNodes;
			nEND = eleType_.nEleNodeDOFs;
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
		
			blockIndex = PartitionMission4CPU(numEles_, 1.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(4,:)';
			deShapeFuncs_ = DeShapeFunction(gaussIPs);
			invJ = zeros(nEND*nEGIP,nEND*nEGIP);
			if 1==length(material_.modulus) && 1==length(material_.poissonRatio)
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);	
				if strcmp(meshType_, 'Cartesian')
					detJ_ = zeros(nEGIP,1);
					for jj=1:nEGIP
						probeEleNods = nodeCoords_(eNodMat_(1,:)',:);
						Jac = deShapeFuncs_(nEND*(jj-1)+1:nEND*jj,:)*probeEleNods;
						detJ_(jj) = det(Jac);
						invJ(nEND*(jj-1)+1:nEND*jj, nEND*(jj-1)+1:nEND*jj) = inv(Jac);
					end
					matrixB_ = ElementStrainMatrix(deShapeFuncs_, invJ);
					Ke = ElementStiffMatrix(matrixB_, matrixD_.arr, wgts, detJ_);
					semiKe = tril(Ke); 
					[eKi, eKj, eKs] = find(semiKe);
					for ii=1:size(blockIndex,1)
						rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
						sK = repmat(eKs, 1, length(rangeIndex));
						iK = eDofMat_(rangeIndex,eKi)';
						jK = eDofMat_(rangeIndex,eKj)';
						tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);					
						tmpK = tmpK + tmpK' - diag(diag(tmpK));
						K_ = K_ + tmpK;					
					end					
				else
					detJ_ = zeros(nEGIP,numEles_);
					iDetJ = zeros(nEGIP,1);				
					matrixB_ = zeros(nESC*nEGIP, nEND*nEGIP); matrixB_ = repmat(matrixB_, 1, 1, numEles_);
					for jj=1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sK = zeros(24*(24+1)/2, length(rangeIndex)); %%Ke = 24-by-24
						index = 0;
						for ii=rangeIndex(1):rangeIndex(end)
							index = index + 1;
							probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
							for kk=1:nEGIP
								Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
								iDetJ(kk) = det(Jac);
								invJ(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);							
							end
							detJ_(:,ii) = iDetJ;
							meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
							iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ);;
							matrixB_(:,:,ii) = iMatrixB;
							Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, iDetJ);
							semiKe = tril(Ke); 
							[eKi, eKj, eKs] = find(semiKe);				
							sK(:,index) = eKs;				
						end
						iK = eDofMat_(rangeIndex,eKi)';
						jK = eDofMat_(rangeIndex,eKj)';
						tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
						tmpK = tmpK + tmpK' - diag(diag(tmpK));
						K_ = K_ + tmpK;
					end
				end
			elseif numEles_==length(material_.modulus) && numEles_==length(material_.poissonRatio)
				detJ_ = zeros(nEGIP,numEles_);
				iDetJ = zeros(nEGIP,1);
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				matrixB_ = zeros(nESC*nEGIP, nEND*nEGIP); matrixB_ = repmat(matrixB_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(24*(24+1)/2, length(rangeIndex)); %%Ke = 24-by-24
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						probeEleNods = nodeCoords_(eNodMat_(ii,:)',:);
						for kk=1:nEGIP
							Jac = deShapeFuncs_(nEND*(kk-1)+1:nEND*kk,:)*probeEleNods;
							iDetJ(kk) = det(Jac);
							invJ(nEND*(kk-1)+1:nEND*kk, nEND*(kk-1)+1:nEND*kk) = inv(Jac);							
						end
						detJ_(:,ii) = iDetJ;
						meshQualityJacobianRatio_(ii) = min(iDetJ)/max(iDetJ);
						iMatrixB = ElementStrainMatrix(dShape_, invJ_(ii,1).SPmat);;
						matrixB_(:,:,ii) = iMatrixB;
						iMatrixD = ElementElasticityMatrix(material_.modulus(ii), material_.poissonRatio(ii));	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, iDetJ);				
						semiKe = tril(Ke); 
						[eKi, eKj, eKs] = find(semiKe);				
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end					
			else
				error('Un-supported Material Property!');			
			end
		case 'Shell133'
		
		case 'Shell144'
		
	end
	K_ = K_(freeDOFs_, freeDOFs_);	
end