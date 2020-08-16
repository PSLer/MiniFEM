function AssembleSystemMatrices()
	global domainType_;
	tic;
	global modelSource_; global advancedSolvingOpt_; global structureState_;
	global numEles_; global numDOFs_; global eleType_;
	global eleD_; global eleB_; global dShape_; global invJ_; global JacobianRatio_;
	global nodeCoords_; global eNodMat_; global edofMat_;
	global iK_; global jK_; global sK_; 
	global K_; global Ke_;
	global density_;
	global iM_; global jM_; global sM_; 
	global M_; global Me_;	
	
	switch domainType_
		case '2D'		
			[s t w] = GaussianIntegral();
			N = ShapeFunction(s, t);
			dShape_ = DeShapeFunction(s,t);
		case '3D'
			[s t p w] = GaussianIntegral();
			N = ShapeFunction(s, t, p);
			dShape_ = DeShapeFunction(s,t,p);
	end
	eleD_ = ElementElasticityMatrix();
	eleB_ = zeros(eleType_.numStrainComponents*eleType_.numNode, eleType_.numNodeDOFs*eleType_.numNode);
	JacobianRatio_ = ones(numEles_,1);
	detJ = zeros(eleType_.numGIPs,1); 	
	invJ_ = HDSparseMatStruct(eleType_.numNodeDOFs*eleType_.numGIPs, ...
		eleType_.numNodeDOFs*eleType_.numGIPs);
	blockIndex = PartitionBlock(numEles_);	
	numEntries = eleType_.numNode*eleType_.numNodeDOFs;	
	
	switch advancedSolvingOpt_
		case 'TimePriority'
			K_ = sparse(numDOFs_, numDOFs_);
			if strcmp(modelSource_, 'ExtMesh')
				invJ_ = repmat(invJ_, numEles_, 1);
				eleB_ = repmat(eleB_, 1, 1, numEles_);
				detJ = repmat(detJ, 1, numEles_);
				for jj=1:1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sK_ = zeros(numEntries*(numEntries+1)/2, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):1:rangeIndex(end)
						index = index + 1;
						relativeNodCoord = nodeCoords_(eNodMat_(ii,:)',:);
						for kk=1:1:eleType_.numGIPs
							[detJ(kk,ii) invJ_(ii,1).SPmat(eleType_.numNodeDOFs*(kk-1)+1:eleType_.numNodeDOFs*kk, ...
								eleType_.numNodeDOFs*(kk-1)+1:eleType_.numNodeDOFs*kk)] = JacobianMat(...
									dShape_(eleType_.numNodeDOFs*(kk-1)+1:eleType_.numNodeDOFs*kk,:), relativeNodCoord);			
						end
						JacobianRatio_(ii) = min(detJ(:,ii))/max(detJ(:,ii));
						eleB_(:,:,ii) = ElementStrainMatrix(dShape_, invJ_(ii,1).SPmat);
						Ke_ = ElementStiffMatrix(eleB_(:,:,ii), eleD_, w, detJ(:,ii));
						semiKe = tril(Ke_); semiKe = sparse(semiKe); 
						[rowIndice colIndice semiKe] = find(semiKe);				
						sK_(:,index) = semiKe;				
					end
					iK_ = edofMat_(rangeIndex,rowIndice)';
					jK_ = edofMat_(rangeIndex,colIndice)';			
					iK_ = reshape(iK_, numel(iK_), 1);
					jK_ = reshape(jK_, numel(jK_), 1);	
					sK_ = reshape(sK_, numel(sK_), 1);
					tmpK = sparse(iK_, jK_, sK_, numDOFs_, numDOFs_);
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;			
				end			
			else
				for jj=1:1:eleType_.numGIPs
					relativeNodCoord = nodeCoords_(eNodMat_(1,:)',:);
					[detJ(jj) invJ_.SPmat(eleType_.numNodeDOFs*(jj-1)+1:eleType_.numNodeDOFs*jj, ...
						eleType_.numNodeDOFs*(jj-1)+1:eleType_.numNodeDOFs*jj)] = JacobianMat(...
							dShape_(eleType_.numNodeDOFs*(jj-1)+1:eleType_.numNodeDOFs*jj,:), relativeNodCoord);			
				end
				eleB_ = ElementStrainMatrix(dShape_, invJ_.SPmat);
				Ke_ = ElementStiffMatrix(eleB_, eleD_, w, detJ);
				semiKe = tril(Ke_); semiKe = sparse(semiKe); 
				[rowIndice colIndice semiKe] = find(semiKe);	
				for ii=1:1:size(blockIndex,1)
					rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
					sK_ = repmat(semiKe, 1, length(rangeIndex));
					iK_ = edofMat_(rangeIndex,rowIndice)';
					jK_ = edofMat_(rangeIndex,colIndice)';
					iK_ = reshape(iK_, numel(iK_), 1);
					jK_ = reshape(jK_, numel(jK_), 1);	
					sK_ = reshape(sK_, numel(sK_), 1);
					tmpK = sparse(iK_, jK_, sK_, numDOFs_, numDOFs_);					
					tmpK = tmpK + tmpK' - diag(diag(tmpK));
					K_ = K_ + tmpK;
				end				
			end
			clearvars tmpK
			clearvars -global iK_ jK_ sK_ 
			
			if strcmp(structureState_, 'DYNAMIC')		
				eleN = ElementShapeFunctionMatrix(N);
				M_ = sparse(numDOFs_, numDOFs_);	
				if strcmp(modelSource_, 'ExtMesh')
					for jj=1:1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sM_ = zeros(numEntries*(eleType_.numNode+1)/2, length(rangeIndex));	
						index = 0;
						for ii=rangeIndex(1):1:rangeIndex(end)
							index = index + 1;
							Me_ = ElementMassMatrix(eleN, w, detJ(:,ii), density_);
							semiMe = tril(Me_); semiMe = sparse(semiMe); 
							[rowIndice colIndice semiMe] = find(semiMe);				
							sM_(:,index) = semiMe;				
						end
						iM_ = edofMat_(rangeIndex,rowIndice)';
						jM_ = edofMat_(rangeIndex,colIndice)';			
						iM_ = reshape(iM_, numel(iM_), 1);
						jM_ = reshape(jM_, numel(jM_), 1);	
						sK_ = reshape(sM_, numel(sM_), 1);
						tmpM = sparse(iM_, jM_, sM_, numDOFs_, numDOFs_);
						tmpM = tmpM + tmpM' - diag(diag(tmpM));
						M_ = M_ + tmpM;			
					end		
				else
					Me_ = ElementMassMatrix(eleN, w, detJ, density_);
					semiMe = tril(Me_); semiMe = sparse(semiMe); 
					[rowIndice colIndice semiMe] = find(semiMe);	
					for ii=1:1:size(blockIndex,1)
						rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
						sM_ = repmat(semiMe, 1, length(rangeIndex));
						iM_ = edofMat_(rangeIndex,rowIndice)';
						jM_ = edofMat_(rangeIndex,colIndice)';
						iM_ = reshape(iM_, numel(iM_), 1);
						jM_ = reshape(jM_, numel(jM_), 1);	
						sM_ = reshape(sM_, numel(sM_), 1);
						tmpM = sparse(iM_, jM_, sM_, numDOFs_, numDOFs_);
						tmpM = tmpM + tmpM' - diag(diag(tmpM));
						M_ = M_ + tmpM;
					end	
				end
				clearvars tmpM
				clearvars -global iM_ jM_ sM_ 		
			end
			clearvars -global edofMat_
		case 'SpacePriority'
			for jj=1:1:eleType_.numGIPs
				relativeNodCoord = nodeCoords_(eNodMat_(1,:)',:);
				[detJ(jj) invJ_.SPmat(eleType_.numNodeDOFs*(jj-1)+1:eleType_.numNodeDOFs*jj, ...
					eleType_.numNodeDOFs*(jj-1)+1:eleType_.numNodeDOFs*jj)] = JacobianMat(...
						dShape_(eleType_.numNodeDOFs*(jj-1)+1:eleType_.numNodeDOFs*jj,:), relativeNodCoord);			
			end
			eleB_ = ElementStrainMatrix(dShape_, invJ_.SPmat);
			Ke_ = ElementStiffMatrix(eleB_, eleD_, w, detJ);
			if strcmp(structureState_, 'DYNAMIC')
				eleN = ElementShapeFunctionMatrix(N);
				Me_ = ElementMassMatrix(eleN, w, detJ, density_);
			end
		otherwise
			error('Wrong option for assembling system matrix!');
	end	
	disp(['Assembling System Matrices costs: ' sprintf('%10.3g',toc) 's']);
end

function blockIndex = PartitionBlock(tot)
	step = 5.0e5;
	numBlocks = ceil(tot/step);		
	blockIndex = ones(numBlocks,2);
	blockIndex(1:numBlocks-1,2) = (1:1:numBlocks-1)' * step;
	blockIndex(2:numBlocks,1) = blockIndex(2:numBlocks,1) + blockIndex(1:numBlocks-1,2);
	blockIndex(numBlocks,2) = tot;	
end