function AssembleMassMatrix()
	global material_;
	global eleType_;
	global meshType_;
	global numEles_;
	global numDOFs_;
	global freeDOFs_;
	global eDofMat_;
	global shapeFuncs_;
	global detJ_;
	global materialIndicatorField_;
	
	global M_;
	if isempty(freeDOFs_), warning('Apply for Boundary Condition First!'); return; end
	tStart = tic;
	M_ = sparse(numDOFs_,numDOFs_);
	if max(materialIndicatorField_) ~= numel(material_)
		error('Un-matched Material Defination!');
	end	
	switch eleType_.eleName
		case 'Plane133'
			blockIndex = PartitionMission4CPU(numEles_, 5.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';
			shapeFuncs_ = ElementShapeFunctionMatrix(ShapeFunction(gaussIPs));
			if 1==numel(material_)
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sM = zeros(12, length(rangeIndex)); %%12 is based on the feature of element mass matrix of 'Plane133'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_.density);
						semiMe = tril(Me); 
						[eMi, eMj, eMs] = find(semiMe);				
						sM(:,index) = eMs;				
					end
					iM = eDofMat_(rangeIndex,eMi)';
					jM = eDofMat_(rangeIndex,eMj)';
					tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);
					tmpM = tmpM + tmpM' - diag(diag(tmpM));
					M_ = M_ + tmpM;
				end			
			else %% Multi-Material
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sM = zeros(12, length(rangeIndex)); %%12 is based on the feature of element mass matrix of 'Plane133'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_(materialIndicatorField_(ii)).density);
						semiMe = tril(Me); 
						[eMi, eMj, eMs] = find(semiMe);				
						sM(:,index) = eMs;				
					end
					iM = eDofMat_(rangeIndex,eMi)';
					jM = eDofMat_(rangeIndex,eMj)';
					tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);
					tmpM = tmpM + tmpM' - diag(diag(tmpM));
					M_ = M_ + tmpM;
				end				
			else
				error('Un-supported Material Property!');
			end			
		case 'Plane144'
			blockIndex = PartitionMission4CPU(numEles_, 5.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';
			shapeFuncs_ = ElementShapeFunctionMatrix(ShapeFunction(gaussIPs));
			if 1==numel(material_)		
				if strcmp(meshType_, 'Cartesian')
					Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_, material_.density);
					semiMe = tril(Me); 
					[eMi, eMj, eMs] = find(semiMe);
					for ii=1:size(blockIndex,1)
						rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
						sM = repmat(eMs, 1, length(rangeIndex));
						iM = eDofMat_(rangeIndex,eMi)';
						jM = eDofMat_(rangeIndex,eMj)';
						tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);					
						tmpM = tmpM + tmpM' - diag(diag(tmpM));
						M_ = M_ + tmpM;					
					end
				else
					for jj=1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sM = zeros(20, length(rangeIndex)); %%20 is based on the feature of element mass matrix of 'Solid144'
						index = 0;
						for ii=rangeIndex(1):rangeIndex(end)
							index = index + 1;
							Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_.density);
							semiMe = tril(Me); 
							[eMi, eMj, eMs] = find(semiMe);				
							sM(:,index) = eMs;				
						end
						iM = eDofMat_(rangeIndex,eMi)';
						jM = eDofMat_(rangeIndex,eMj)';
						tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);
						tmpM = tmpM + tmpM' - diag(diag(tmpM));
						M_ = M_ + tmpM;
					end
				end			
			else %% Multi-Material
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sM = zeros(20, length(rangeIndex)); %%20 is based on the feature of element mass matrix of 'Solid144'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_(materialIndicatorField_(ii)).density);
						semiMe = tril(Me); 
						[eMi, eMj, eMs] = find(semiMe);				
						sM(:,index) = eMs;				
					end
					iM = eDofMat_(rangeIndex,eMi)';
					jM = eDofMat_(rangeIndex,eMj)';
					tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);
					tmpM = tmpM + tmpM' - diag(diag(tmpM));
					M_ = M_ + tmpM;
				end				
			else
				error('Un-supported Material Property!');
			end
		case 'Solid144'
			blockIndex = PartitionMission4CPU(numEles_, 1.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(4,:)';
			shapeFuncs_ = ElementShapeFunctionMatrix(ShapeFunction(gaussIPs));
			if 1==numel(material_)
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sM = zeros(30, length(rangeIndex)); %%30 is based on the feature of element mass matrix of 'Solid144'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_.density);
						semiMe = tril(Me); 
						[eMi, eMj, eMs] = find(semiMe);				
						sM(:,index) = eMs;				
					end
					iM = eDofMat_(rangeIndex,eMi)';
					jM = eDofMat_(rangeIndex,eMj)';
					tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);
					tmpM = tmpM + tmpM' - diag(diag(tmpM));
					M_ = M_ + tmpM;
				end
			else %% Multi-Material
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sM = zeros(30, length(rangeIndex)); %%30 is based on the feature of element mass matrix of 'Solid144'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_(materialIndicatorField_(ii)).density);				
						semiMe = tril(Me); 
						[eMi, eMj, eMs] = find(semiMe);				
						sM(:,index) = eMs;				
					end
					iM = eDofMat_(rangeIndex,eMi)';
					jM = eDofMat_(rangeIndex,eMj)';
					tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);
					tmpM = tmpM + tmpM' - diag(diag(tmpM));
					M_ = M_ + tmpM;
				end					
			else
				error('Un-supported Material Property!');			
			end	
		case 'Solid188'
			blockIndex = PartitionMission4CPU(numEles_, 1.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(4,:)';
			shapeFuncs_ = ElementShapeFunctionMatrix(ShapeFunction(gaussIPs));
			if 1==numel(material_)
				if strcmp(meshType_, 'Cartesian')
					Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_, material_.density);
					semiMe = tril(Me); 
					[eMi, eMj, eMs] = find(semiMe);
					for ii=1:size(blockIndex,1)
						rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
						sM = repmat(eMs, 1, length(rangeIndex));
						iM = eDofMat_(rangeIndex,eMi)';
						jM = eDofMat_(rangeIndex,eMj)';
						tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);					
						tmpM = tmpM + tmpM' - diag(diag(tmpM));
						M_ = M_ + tmpM;					
					end					
				else
					for jj=1:size(blockIndex,1)
						rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
						sM = zeros(108, length(rangeIndex)); %%108 is based on the feature of element mass matrix of 'Solid188'
						index = 0;
						for ii=rangeIndex(1):rangeIndex(end)
							index = index + 1;
							Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_.density);
							semiMe = tril(Me); 
							[eMi, eMj, eMs] = find(semiMe);				
							sM(:,index) = eMs;				
						end
						iM = eDofMat_(rangeIndex,eMi)';
						jM = eDofMat_(rangeIndex,eMj)';
						tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);
						tmpM = tmpM + tmpM' - diag(diag(tmpM));
						M_ = M_ + tmpM;
					end
				end
			else %% Multi-Material
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sM = zeros(108, length(rangeIndex)); %%108 is based on the feature of element mass matrix of 'Solid188'
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_(materialIndicatorField_(ii)).density);				
						semiMe = tril(Me); 
						[eMi, eMj, eMs] = find(semiMe);				
						sM(:,index) = eMs;				
					end
					iM = eDofMat_(rangeIndex,eMi)';
					jM = eDofMat_(rangeIndex,eMj)';
					tmpM = sparse(iM, jM, sM, numDOFs_, numDOFs_);
					tmpM = tmpM + tmpM' - diag(diag(tmpM));
					M_ = M_ + tmpM;
				end					
			else
				error('Un-supported Material Property!');			
			end
		case 'Shell133'
			error('Not supported yet!');
		case 'Shell144'
			error('Not supported yet!');
		case 'Truss122'
			error('Not supported yet!');
		case 'Truss123'
			error('Not supported yet!');
		case 'Beam122'
			error('Not supported yet!');
		case 'Beam123'
			error('Not supported yet!');
	end
	M_ = M_(freeDOFs_, freeDOFs_);
	disp(['Assemble Mass Matrix Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
end