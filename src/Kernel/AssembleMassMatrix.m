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
	global M_;
	
	if isempty(freeDOFs_), warning('Apply for Boundary Condition First!'); return; end
	
	M_ = sparse(numDOFs_,numDOFs_);
	switch eleType_.eleName
		case 'Plane133'
			if strcmp(meshType_, 'Cartesian')
			
			else
			
			end			
		case 'Plane144'
			blockIndex = PartitionMission4CPU(numEles_, 5.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';
			shapeFuncs_ = ElementShapeFunctionMatrix(ShapeFunction(gaussIPs));
			if 1==length(material_.density)			
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
						sM = zeros(8*(8+1)/2, length(rangeIndex));
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
			elseif numEles_==length(material_.density)
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sM = zeros(8*(8+1)/2, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_.density(ii));
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
		
		case 'Solid188'
			blockIndex = PartitionMission4CPU(numEles_, 1.0e6);
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			wgts = eleType_.GaussIntegralPointsNaturalSpace(4,:)';
			shapeFuncs_ = ElementShapeFunctionMatrix(ShapeFunction(gaussIPs));
			if 1==length(material_.density)
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
						sM = zeros(24*(24+1)/2, length(rangeIndex));
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
			elseif numEles_==length(material_.modulus) && numEles_==length(material_.poissonRatio)
				for jj=1:size(blockIndex,1)
					rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
					sM = zeros(24*(24+1)/2, length(rangeIndex));
					index = 0;
					for ii=rangeIndex(1):rangeIndex(end)
						index = index + 1;
						Me = ElementMassMatrix(shapeFuncs_, wgts, detJ_(:,ii), material_.density(ii));				
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
		
		case 'Shell144'
		
	end
	M_ = M_(freeDOFs_, freeDOFs_);	
end