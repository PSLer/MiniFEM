function ApplyLoads()
	global domainType_;
	global modelSource_;
	global numDOFs_;
	global loadedNodes_; global loadedDofs_;  	
	global eleType_; global nodeCoords_;
	global nodeLoadVec_; global F_; F_ = sparse(numDOFs_,1);
	global loadingCond_;
	switch domainType_
		case '2D'			
			if isnumeric(loadingCond_)
				if 3==size(loadingCond_,2)
					global nodeMap4CutBasedModel_;
					nodeLoadVec_ = loadingCond_;
					if strcmp(modelSource_, 'TopOpti')
						nodeLoadVec_(:,1) = nodeMap4CutBasedModel_(nodeLoadVec_(:,1));
					end
				elseif 4==size(loadingCond_,2)
					nodeLoadVec_ = zeros(size(loadingCond_,1),3);
					nodeLoadVec_(:,2:3) = loadingCond_(:,3:4);
					for ii=1:1:size(loadingCond_,1)
						[minVal nodeLoadVec_(ii,1)] = ...
							min(vecnorm(loadingCond_(ii,1:2)-nodeCoords_,2,2));				
					end
				end				
			else
				error('Wrong loading type! Error code: XXX');
			end
		case '3D'
			if isnumeric(loadingCond_)
				if 4==size(loadingCond_,2)
					global nodeMap4CutBasedModel_;
					nodeLoadVec_ = loadingCond_;
					if strcmp(modelSource_, 'TopOpti')
						nodeLoadVec_(:,1) = nodeMap4CutBasedModel_(nodeLoadVec_(:,1));
					end
				elseif 6==size(loadingCond_,2)
					nodeLoadVec_ = zeros(size(loadingCond_,1),4);
					nodeLoadVec_(:,2:4) = loadingCond_(:,4:6);
					for ii=1:1:size(loadingCond_,1)
						[minVal nodeLoadVec_(ii,1)] = ...
							min(vecnorm(loadingCond_(ii,1:3)-nodeCoords_,2,2));		
					end
				end				
			else
				error('Wrong loading type! Error code: XXX');
			end		
	end
	loadedNodes_ = nodeLoadVec_(:,1); 
	loadedDofs_ = eleType_.numNodeDOFs*loadedNodes_-(eleType_.numNodeDOFs-1:-1:0);
	loadedDofs_ = reshape(loadedDofs_', size(loadedDofs_,1)*size(loadedDofs_,2), 1);
	loadVec = nodeLoadVec_(:,2:end); loadVec = reshape(loadVec', numel(loadVec), 1);
	F_(loadedDofs_) = loadVec;
end
