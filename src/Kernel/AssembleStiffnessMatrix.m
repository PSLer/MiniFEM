function AssembleStiffnessMatrix()
	global material_;
	global eleType_;
	global meshType_;
	global numEles_;
	global numDOFs_;
	global freeDOFs_;
	global eDofMat_;
	global eNodMat_;
	global nodeCoords_;
	global matrixD_;
	global detJ_;
	global invJ_;
	global deShapeFuncs_;
	global diameterList_;
	global eleCrossSecAreaList_;
	global eleLengthList_;
	global materialIndicatorField_;
	global Ke_;
	global K_;
	if isempty(freeDOFs_), warning('Apply for Boundary Condition First!'); return; end
	tStart = tic;
	K_ = sparse(numDOFs_,numDOFs_);
	[eKi, eKj, eKk] = GetLowerEleStiffMatIndices();
	numEntries = length(eKk);
	if max(materialIndicatorField_) ~= numel(material_)
		error('Un-matched Material Defination!');
	end
	switch eleType_.eleName
		case 'Plane133'
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
	
			blockIndex = PartitionMission4CPU(numEles_, 5.0e6);
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';
			if 1==numel(material_)
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);	
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(numEntries, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_(:,ii));
						eKs = Ke(eKk);			
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end				
			else %% Multi-Material
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(numEntries, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(dShape_, invJ_(ii).arr);
						iMatrixD = ElementElasticityMatrix(material_(materialIndicatorField_(ii)).modulus, material_(materialIndicatorField_(ii)).poissonRatio);	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, detJ_(:,ii));				
						eKs = Ke(eKk);				
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end						
			end
		case 'Plane144'
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;	
			blockIndex = PartitionMission4CPU(numEles_, 5.0e6);
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';	
			if 1==numel(material_)		
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);				
				if strcmp(meshType_, 'Cartesian')
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_.arr);
					Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_);
					eKs = Ke(eKk);
					for ii=1:size(blockIndex,1)
						rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
						sK = repmat(eKs, 1, length(rangeIndex));
						iK = eDofMat_(rangeIndex,eKi)';
						jK = eDofMat_(rangeIndex,eKj)';
						tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);					
						tmpK = tmpK + tmpK' - diag(diag(tmpK));
						K_ = K_ + tmpK;					
					end
					Ke_ = Ke;					
				else
					for jj=1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sK = zeros(numEntries, length(rangeIndex));
						index = 0;
						for ii=rangeIndex(1):rangeIndex(end)
							index = index + 1;
							iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
							Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_(:,ii));
							eKs = Ke(eKk);			
							sK(:,index) = eKs;				
						end
						iK = eDofMat_(rangeIndex,eKi)';
						jK = eDofMat_(rangeIndex,eKj)';
						tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
						tmpK = tmpK + tmpK' - diag(diag(tmpK));
						K_ = K_ + tmpK;
					end
				end			
			else %% Multi-Material
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(numEntries, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						iMatrixD = ElementElasticityMatrix(material_(materialIndicatorField_(ii)).modulus, material_(materialIndicatorField_(ii)).poissonRatio);	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, detJ_(:,ii));				
						eKs = Ke(eKk);			
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end				
			end
		case 'Solid144'
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			blockIndex = PartitionMission4CPU(numEles_, 1.0e6);
			wgts = eleType_.GaussIntegralPointsNaturalSpace(4,:)';
			if 1==numel(material_)
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);	
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(numEntries, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;						
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);			
						Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_(:,ii));							
						eKs = Ke(eKk);    
						sK(:,index) = eKs;						
					end						
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;						
				end
			else %% Multi-Material
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(numEntries, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						iMatrixD = ElementElasticityMatrix(material_(materialIndicatorField_(ii)).modulus, material_(materialIndicatorField_(ii)).poissonRatio);	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, detJ_(:,ii));				
						eKs = Ke(eKk);			
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end							
			end			
		case 'Solid188'
			nESC = eleType_.nEleStressComponents;
			nEGIP = eleType_.nEleGaussIntegralPoints;
			blockIndex = PartitionMission4CPU(numEles_, 1.0e6);
			wgts = eleType_.GaussIntegralPointsNaturalSpace(4,:)';			
			if 1==numel(material_)
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC));
				matrixD_.arr = ElementElasticityMatrix(material_.modulus, material_.poissonRatio);	
				if strcmp(meshType_, 'Cartesian')
					iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_.arr);
					Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_);
					eKs = Ke(eKk);
					for ii=1:size(blockIndex,1)
						rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
						sK = repmat(eKs, 1, length(rangeIndex));
						iK = eDofMat_(rangeIndex,eKi)';
						jK = eDofMat_(rangeIndex,eKj)';
						tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);					
						tmpK = tmpK + tmpK' - diag(diag(tmpK));
						K_ = K_ + tmpK;					
					end
					Ke_ = Ke;					
                else			
					for jj=1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sK = zeros(numEntries, length(rangeIndex));
						index = 0;
						for ii=rangeIndex(1):rangeIndex(end)
							index = index + 1;						
							iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);			
							Ke = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_(:,ii));							
							eKs = Ke(eKk);
							sK(:,index) = eKs;						
						end						
						iK = eDofMat_(rangeIndex,eKi)';
						jK = eDofMat_(rangeIndex,eKj)';
						tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
						tmpK = tmpK + tmpK' - diag(diag(tmpK));
						K_ = K_ + tmpK;						
					end					
				end
			else
				matrixD_ = struct('arr', sparse(nEGIP*nESC,nEGIP*nESC)); matrixD_ = repmat(matrixD_, 1, 1, numEles_);
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK = zeros(numEntries, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
						iMatrixD = ElementElasticityMatrix(material_(materialIndicatorField_(ii)).modulus, material_(materialIndicatorField_(ii)).poissonRatio);	
						matrixD_(ii).arr = iMatrixD;
						Ke = ElementStiffMatrix(iMatrixB, iMatrixD, wgts, detJ_(:,ii));				
						eKs = Ke(eKk);
						sK(:,index) = eKs;				
					end
					iK = eDofMat_(rangeIndex,eKi)';
					jK = eDofMat_(rangeIndex,eKj)';
					tmpK = sparse(iK, jK, sK, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end							
			end
		case 'Shell133'
		
		case 'Shell144'
		
		case 'Truss122'

		case 'Truss123'
			lx = (nodeCoords_(eNodMat_(:,2),1)-nodeCoords_(eNodMat_(:,1),1)) ./ eleLengthList_;
			ly = (nodeCoords_(eNodMat_(:,2),2)-nodeCoords_(eNodMat_(:,1),2)) ./ eleLengthList_;
			lz = (nodeCoords_(eNodMat_(:,2),3)-nodeCoords_(eNodMat_(:,1),3)) ./ eleLengthList_;
			sK = zeros(numEntries, numEles_);
			if 1==numel(material_)
				for ii=1:numEles_
					iD = [	lx(ii)*lx(ii), lx(ii)*ly(ii), lx(ii)*lz(ii); 
							ly(ii)*lx(ii), ly(ii)*ly(ii), ly(ii)*lz(ii);
							lz(ii)*lx(ii), lz(ii)*ly(ii), lz(ii)*lz(ii)];
					iD = material_.modulus*eleCrossSecAreaList_(ii)/eleLengthList_(ii) * iD;
					Ke = [iD -iD; -iD iD];
					eKs = Ke(eKk);
					sK(:,ii) = eKs;
				end				
			else %% Multi-Material
				for ii=1:numEles_
					iD = [	lx(ii)*lx(ii), lx(ii)*ly(ii), lx(ii)*lz(ii); 
							ly(ii)*lx(ii), ly(ii)*ly(ii), ly(ii)*lz(ii);
							lz(ii)*lx(ii), lz(ii)*ly(ii), lz(ii)*lz(ii)];
					iD = material_(materialIndicatorField_(ii)).modulus*eleCrossSecAreaList_(ii)/eleLengthList_(ii) * iD;
					Ke = [iD -iD; -iD iD];
					eKs = Ke(eKk);
					sK(:,ii) = eKs;
				end
			end
			iK = eDofMat_(:,eKi)';
			jK = eDofMat_(:,eKj)';
			K_ = sparse(iK, jK, sK, numDOFs_, numDOFs_);
			K_ = K_ + K_' - diag(diag(K_));	
		case 'Beam122'
	
		case 'Beam123'
			sK = zeros(numEntries, numEles_);
			Izz = pi/4 * diameterList_.^4;
			Iyy = Izz;
			J = pi/32 * diameterList_.^4;
			beta_ang = zeros(size(J));
			x_axis = (nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,1),:))./eleLengthList_;
			x_axis = x_axis ./ vecnorm(x_axis,2,2);
			if 1==numel(material_)
				for ii=1:numEles_
					iKeLocal = ElementStiffMatrix_Beam(eleCrossSecAreaList_(ii),Izz(ii),Iyy(ii),J(ii), ...
						material_.modulus,material_.poissonRatio,eleLengthList_(ii));
					iKeTrans = ElementTransformationMatrix_Beam(beta_ang(ii),x_axis(ii,:));
					iKeGlobal = (reshape(iKeTrans,12,12))'*(reshape(iKeLocal,12,12))*(reshape(iKeTrans,12,12));
					eKs = iKeGlobal(eKk);
					sK(:,ii) = eKs;					
				end
			else %% Multi-Material
				for ii=1:numEles_
					iKeLocal = ElementStiffMatrix_Beam(eleCrossSecAreaList_(ii),Izz(ii),Iyy(ii),J(ii), ...
						material_(materialIndicatorField_(ii)).modulus, material_(materialIndicatorField_(ii)).poissonRatio,eleLengthList_(ii));
					iKeTrans = ElementTransformationMatrix_Beam(beta_ang(ii),x_axis(ii,:)');
					iKeGlobal = (reshape(iKeTrans,12,12))'*(reshape(iKeLocal,12,12))*(reshape(iKeTrans,12,12));
					eKs = iKeGlobal(eKk);
					sK(:,ii) = eKs;
				end			
			end
			iK = eDofMat_(:,eKi)';
			jK = eDofMat_(:,eKj)';
			K_ = sparse(iK, jK, sK, numDOFs_, numDOFs_);
			K_ = K_ + K_' - diag(diag(K_));			
	end
	K_ = K_(freeDOFs_, freeDOFs_);
	% disp(['Assemble Stiffness Matrix Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
end

function [eKi, eKj, eKk] = GetLowerEleStiffMatIndices()
	global eleType_;
	dimK = eleType_.nEleNodes*eleType_.nEleNodeDOFs;
	rowMat = (1:dimK)'; rowMat = repmat(rowMat, 1, dimK);
	colMat = (1:dimK); colMat = repmat(colMat, dimK, 1);
	valMat = (1:dimK^2)'; valMat = reshape(valMat, dimK, dimK);
	eKi = tril(rowMat); [~, ~, eKi] = find(eKi);
	eKj = tril(colMat); [~, ~, eKj] = find(eKj);
	eKk = tril(valMat); [~, ~, eKk] = find(eKk);
end