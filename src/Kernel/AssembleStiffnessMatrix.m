function AssembleStiffnessMatrix()
	global eleType_;
	global meshType_;
	global freeDOFs_;
	global eNodMat_;
	global nodeCoords_;
	global K_;
	
	switch eleType_.eleName
		case 'Plane133'
			if strcmp(meshType_, 'Cartesian')
			
			else
			
			end			
		case 'Plane144'
			if strcmp(meshType_, 'Cartesian')
				detJ = zeros(4,1); 
				for jj=1:4
					probeNodCoord = nodeCoords_(eNodMat_(1,:)',:);
					[detJ(jj), invJ_.SPmat(2*(jj-1)+1:2*jj, 2*(jj-1)+1:2*jj)] = JacobianMat(...
							dShape_(2*(jj-1)+1:2*jj,:), probeNodCoord);			
				end				
			else
			
			end		
		case 'Solid144'
		
		case 'Solid188'
			if strcmp(meshType_, 'Cartesian')
			
			else
			
			end			
		case 'Shell133'
		
		case 'Shell144'
		
	end
	K_ = K_(freeDOFs_, freeDOFs_);	
end