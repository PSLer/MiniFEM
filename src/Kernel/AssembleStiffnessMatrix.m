function AssembleStiffnessMatrix()
	global material_;
	global eleType_;
	global meshType_;
	global numEles_;
	global numDOFs_;
	global freeDOFs_;
	global eDofMat_;
	global matrixD_;
	global detJ_;
	global invJ_;
	global deShapeFuncs_;
	global cachePach_;
	
	global K_;	
	if isempty(freeDOFs_), warning('Apply for Boundary Condition First!'); return; end
	tStart = tic;
	K_ = sparse(numDOFs_,numDOFs_);
	switch eleType_.eleName
		case 'Plane133'
			nEN = eleType_.nEleNodes;
			nEND = eleType_.nEleNodeDOFs;
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
	
			blockIndex = PartitionMission4CPU(numEles_, 5.0e6);
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';
			if 1==length(material_.modulus) && 1==length(material_.poissonRatio)
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);	
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(17, length(rangeIndex)); %%17 is based on the feature of element stiffness matrix of 'Plane133'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_(:,ii));
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
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(17, length(rangeIndex)); %%17 is based on the feature of element stiffness matrix of 'Plane133'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(dShape_, invJ_(ii).arr);
						iMatrixD = ElementElasticityMatrix(material_.modulus(ii), material_.poissonRatio(ii));	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, detJ_(:,ii));				
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
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';	
			if 1==length(material_.modulus) && 1==length(material_.poissonRatio)			
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);				
				if strcmp(meshType_, 'Cartesian')
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_.arr);
					Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_);
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
					for jj=1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sK = zeros(8*(8+1)/2, length(rangeIndex)); %%Ke = 8-by-8
						index = 0;
						for ii=rangeIndex(1):rangeIndex(end)
							index = index + 1;
							iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
							Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_(:,ii));
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
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(8*(8+1)/2, length(rangeIndex)); %%Ke = 8-by-8
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						iMatrixD = ElementElasticityMatrix(material_.modulus(ii), material_.poissonRatio(ii));	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, detJ_(:,ii));				
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
			wgts = eleType_.GaussIntegralPointsNaturalSpace(4,:)';
			if 1==length(material_.modulus) && 1==length(material_.poissonRatio)
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);	
				if strcmp(meshType_, 'Cartesian')
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_.arr);
					Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_);
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
timeList = zeros(1,4);				
					for jj=1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sK = zeros(24*(24+1)/2, length(rangeIndex)); %%Ke = 24-by-24
						index = 0;
						for ii=rangeIndex(1):rangeIndex(end)
							index = index + 1;						
							iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);			
							Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_(:,ii));							
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
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(24*(24+1)/2, length(rangeIndex)); %%Ke = 24-by-24
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						iMatrixD = ElementElasticityMatrix(material_.modulus(ii), material_.poissonRatio(ii));	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, detJ_(:,ii));				
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
	disp(['Assemble Stiffness Matrix Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
end