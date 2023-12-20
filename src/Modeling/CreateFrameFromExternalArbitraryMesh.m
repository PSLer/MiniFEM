function CreateFrameFromArbitraryMesh_unifiedStressFormat(fileName, varargin)
	global eleType_;
	global boundingBox_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global boundaryNodes_;
	global boundaryFaceNodMat_;
	global numNodsAroundEleVec_;
	global nodState_; global eleState_;
	global fixingCond_;
	global loadingCond_;
	global diameterList_;
	global eleCrossSecAreaList_;
	global eleLengthList_;
	
	%%1. read file header
	fid = fopen(fileName, 'r');
	fgetl(fid);
	domainType = fscanf(fid, '%s', 1);
	if ~(strcmp(domainType, 'Plane') || strcmp(domainType, 'Solid') || strcmp(domainType, 'Frame')), warning('Un-supported Data!'); return; end
	if strcmp(domainType, 'Frame')
		dimensionType = fscanf(fid, '%s', 1);
		meshType = fscanf(fid, '%s', 1);
		meshOrder = fscanf(fid, '%d', 1);
		if 1~=meshOrder, warning('Un-supported Mesh!'); return; end
		startReadingVertices = fscanf(fid, '%s', 1);
		if ~strcmp(startReadingVertices, 'Vertices:'), warning('Un-supported Data!'); return; end	
		%%2. read node coordinates
		numNodes_ = fscanf(fid, '%d', 1);
		switch dimensionType
			case '2D'
				nodeCoords_ = fscanf(fid, '%e %e', [2, numNodes_])';
			case '3D'
				nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';				
		end
		%%3. read element
		startReadingElements = fscanf(fid, '%s', 1);
		if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
		numEles_ = fscanf(fid, '%d', 1);
		eNodMat_ = fscanf(fid, '%d %d', [2, numEles_])';
		%%4. read node state (identifying boundary nodes)
		startReadingNodeState = fscanf(fid, '%s %s', 2);
		if ~strcmp(startReadingNodeState, 'NodeState:'), warning('Un-supported Data!'); return; end
		tmpNumNodes = fscanf(fid, '%d', 1);
		if 0==tmpNumNodes
			nodState_ = []; boundaryNodes_ = [];
		else
			if tmpNumNodes ~= numNodes_
				warning('Un-supported Data!'); return;
			end
			nodState_ = fscanf(fid, '%d', [1, numEles_])';
			boundaryNodes_ = find(1==nodState_);
		end
		%%5. Read boundary condition
		startReadingLoads = fscanf(fid, '%s %s', 2); 
		if ~strcmp(startReadingLoads, 'NodeForces:'), warning('Un-supported Data!'); return; end
		numLoadedNodes = fscanf(fid, '%d', 1);
		if numLoadedNodes>0	
			switch dimensionType
				case '2D'					
					switch meshType
						case 'Truss'
							SetElement('Truss122'); 
							loadingCond_ = fscanf(fid, '%d %e %e', [3, numLoadedNodes])';
						case 'Beam'
							SetElement('Beam122');
							loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])';
					end
				case '3D'				
					switch meshType
						case 'Truss'
							SetElement('Truss123');
							loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])'; 
						case 'Beam'
							SetElement('Beam123');
							loadingCond_ = fscanf(fid, '%d %e %e %e %e %e %e', [7, numLoadedNodes])'; 
					end
			end		
		else 
			loadingCond_ = []; 
		end
		startReadingFixations = fscanf(fid, '%s %s', 2);
		if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
		numFixedNodes = fscanf(fid, '%d', 1);
		if numFixedNodes>0
			fixingCond_ = fscanf(fid, '%d', [1, numFixedNodes])'; 
			switch dimensionType
				case '2D'				
					switch eleType_.eleName
						case 'Truss122'
							fixingCond_ = [fixingCond_ ones(numFixedNodes, 2)];
						case 'Beam122'
							fixingCond_ = [fixingCond_ ones(numFixedNodes, 3)];
					end					
				case '3D'					
					switch eleType_.eleName
						case 'Truss123'
							fixingCond_ = [fixingCond_ ones(numFixedNodes, 3)];
						case 'Beam123'
							fixingCond_ = [fixingCond_ ones(numFixedNodes, 6)];
					end					
			end	
		else
			fixingCond_ = []; 
		end		
	else
		meshType = fscanf(fid, '%s', 1);
		meshOrder = fscanf(fid, '%d', 1);
		if 1~=meshOrder, warning('Un-supported Mesh!'); return; end
		startReadingVertices = fscanf(fid, '%s', 1);
		if ~strcmp(startReadingVertices, 'Vertices:'), warning('Un-supported Data!'); return; end	
		%%2. read node coordinates
		numNodes_ = fscanf(fid, '%d', 1);
		switch domainType
			case 'Plane'
				nodeCoords_ = fscanf(fid, '%e %e', [2, numNodes_])'; 
			case 'Solid'
				nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])'; 
		end
		%%3. read element
		startReadingElements = fscanf(fid, '%s', 1);
		if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
		numEles_ = fscanf(fid, '%d', 1);
		switch meshType
			case 'Quad'
				eNodMat_ = fscanf(fid, '%d %d %d %d', [4, numEles_])'; 
			case 'Tri'
				eNodMat_ = fscanf(fid, '%d %d %d', [3, numEles_])'; 
			case 'Hex'
				eNodMat_ = fscanf(fid, '%d %d %d %d %d %d %d %d', [8, numEles_])';			
			case 'Tet'
				eNodMat_ = fscanf(fid, '%d %d %d %d', [4, numEles_])'; 			
		end
		%%4. Read boundary condition
		startReadingLoads = fscanf(fid, '%s %s', 2); 
		if ~strcmp(startReadingLoads, 'NodeForces:'), warning('Un-supported Data!'); return; end
		numLoadedNodes = fscanf(fid, '%d', 1);
		if numLoadedNodes>0	
			switch domainType
				case 'Plane'
					loadingCond_ = fscanf(fid, '%d %e %e', [3, numLoadedNodes])';
					if strcmp(eleType_.eleName, 'Beam122')
						loadingCond_ = [loadingCond_ zeros(numLoadedNodes,1)];
					end				
				case 'Solid'
					loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])'; 
					if strcmp(eleType_.eleName, 'Beam123')
						loadingCond_ = [loadingCond_ zeros(numLoadedNodes,3)];
					end						
			end		
		else 
			loadingCond_ = []; 
		end
	
		startReadingFixations = fscanf(fid, '%s %s', 2);
		if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
		numFixedNodes = fscanf(fid, '%d', 1);
		if numFixedNodes>0
			fixingCond_ = fscanf(fid, '%d', [1, numFixedNodes])'; 
			switch domainType
				case 'Plane'
					fixingCond_ = [fixingCond_ ones(numFixedNodes, 2)];
					if strcmp(eleType_.eleName, 'Beam122')
						fixingCond_ = [fixingCond_ ones(numFixedNodes,1)];
					end					
				case 'Solid'
					fixingCond_ = [fixingCond_ ones(numFixedNodes, 3)];
					if strcmp(eleType_.eleName, 'Beam123')
						fixingCond_ = [fixingCond_ ones(numFixedNodes,3)];
					end					
			end	
		else
			fixingCond_ = []; 
		end
		[eNodMat_, nodState_, boundaryNodes_] = ConvertInputMesh2Frames(domainType, meshType);
		numEles_ = size(eNodMat_,1);
	end
	fclose(fid);

	%%4. Initialize Additional Mesh Info	
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	switch eleType_.eleName
		case 'Truss122'
			numDOFs_ = 2*numNodes_;
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 2 4]);		
		case 'Truss123'
			numDOFs_ = 3*numNodes_;
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 5 2 4 6]);
		case 'Beam122'
			numDOFs_ = 3*numNodes_;
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 5 2 4 6]);
		case 'Beam123'
			numDOFs_ = 6*numNodes_;
			tmp = 6*eNodMat_; eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 5 7 9 11 2 4 6 8 10 12]);	
	end
	
	if 1==nargin
		scalingEdgeThickness = 200;
	else
		scalingEdgeThickness = varargin{1};
	end
	refDiameter = max(boundingBox_(2,:) - boundingBox_(1,:))/scalingEdgeThickness;
	diameterList_ = repmat(refDiameter, numEles_, 1);
	eleCrossSecAreaList_ = pi/2 * (diameterList_/2).^2;
	if 1 %% For Test	
		eleCrossSecAreaList_ = 100*ones(numEles_,1);
		diameterList_ = 2*(2*eleCrossSecAreaList_/pi).^(1/2);
	end
	eleLengthList_ = vecnorm(nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,1),:),2,2);
	
	%%Evaluate Volume of Frame Structure
	if 1 && (strcmp(eleType_.eleName, 'Truss123') || strcmp(eleType_.eleName, 'Beam123'))
		iSphereVolume = 4/3*pi*(refDiameter/2)^3/2; 
		%iSphereVolume = 0;
		frameVolume = pi/4 * (eleLengthList_(:)' * diameterList_.^2) - (sum(numNodsAroundEleVec_)-numNodes_)*iSphereVolume;
		disp(['Frame Volume: ', sprintf('%.6f', frameVolume)]);
	end
end