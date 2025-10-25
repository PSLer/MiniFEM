function CreateMdl_TSVData(fileName)
	global boundingBox_ eleType_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global materialIndicatorField_;
	global boundaryNodes_ boundaryFaceNodMat_ numNodsAroundEleVec_;
	global nodState_ eleState_;
	global fixingCond_ loadingCond_;
	global refVec_ refVecFallback_ shellThicknessList_;
	
	%%1. read file header
	fid = fopen(fileName, 'r');
	version = fscanf(fid, '%s', 1);
	versionID = fscanf(fid, '%f', 1);
	% fgetl(fid);
	tmp = fscanf(fid, '%s %s %s %s', 4);
	domainType = fscanf(fid, '%s', 1);
	if ~(strcmp(domainType, 'Plane') || strcmp(domainType, 'Solid') || strcmp(domainType, 'Shell')), warning('Un-supported Data!'); return; end
	switch domainType
		case {'Plane', 'Solid'}
			meshType = fscanf(fid, '%s', 1);
			meshOrder = fscanf(fid, '%d', 1);
			if 1~=meshOrder, warning('Un-supported Mesh!'); return; end
			startReadingVertices = fscanf(fid, '%s', 1);
			if ~strcmp(startReadingVertices, 'Vertices:'), warning('Un-supported Data!'); return; end	
			%%2. read node coordinates
			numNodes_ = fscanf(fid, '%d', 1);
			switch domainType
				case 'Plane'
					numDOFs_ = 2*numNodes_;
					nodeCoords_ = fscanf(fid, '%e %e', [2, numNodes_])'; 
				case 'Solid'
					numDOFs_ = 3*numNodes_;
					nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])'; 
			end
			%%3. read element
			startReadingElements = fscanf(fid, '%s', 1);
			if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
			numEles_ = fscanf(fid, '%d', 1);
			switch meshType
				case 'Quad'
					SetElement('Plane144');
					eNodMat_ = fscanf(fid, '%d %d %d %d', [4, numEles_])'; 
				case 'Tri'
					SetElement('Plane133');
					eNodMat_ = fscanf(fid, '%d %d %d', [3, numEles_])';		
				case 'Hex'
					SetElement('Solid188');
					eNodMat_ = fscanf(fid, '%d %d %d %d %d %d %d %d', [8, numEles_])';		
				case 'Tet'
					SetElement('Solid144');
					eNodMat_ = fscanf(fid, '%d %d %d %d', [4, numEles_])';		
			end				
		case 'Shell'
			if 2.0==versionID
				meshType = fscanf(fid, '%s', 1);
				meshOrder = fscanf(fid, '%d', 1);
				if 1~=meshOrder, warning('Un-supported Mesh!'); return; end
				startReadingVertices = fscanf(fid, '%s', 1);
				if ~strcmp(startReadingVertices, 'Vertices:'), warning('Un-supported Data!'); return; end
				%%2. read node coordinates
				numNodes_ = fscanf(fid, '%d', 1);
				numDOFs_ = 6*numNodes_;
				nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';
				%%3. read element
				startReadingElements = fscanf(fid, '%s', 1);
				if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
				numEles_ = fscanf(fid, '%d', 1);
				switch meshType
					case 'Quad'
						SetElement('Shell144');
						eNodMat_ = fscanf(fid, '%d %d %d %d', [4, numEles_])'; 
						%%Initialize Thickness
						edge1 = vecnorm(nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,1),:),2,2);
						edge2 = vecnorm(nodeCoords_(eNodMat_(:,3),:)-nodeCoords_(eNodMat_(:,2),:),2,2);
						edge3 = vecnorm(nodeCoords_(eNodMat_(:,4),:)-nodeCoords_(eNodMat_(:,3),:),2,2);
						edge4 = vecnorm(nodeCoords_(eNodMat_(:,1),:)-nodeCoords_(eNodMat_(:,4),:),2,2);
						edgeLgth = [edge1 edge2 edge3 edge4];						
					case 'Tri'
						SetElement('Shell133');
						eNodMat_ = fscanf(fid, '%d %d %d', [3, numEles_])';
						%%Initialize Thickness
						edge1 = vecnorm(nodeCoords_(eNodMat_(:,1),:)-nodeCoords_(eNodMat_(:,2),:),2,2);
						edge2 = vecnorm(nodeCoords_(eNodMat_(:,1),:)-nodeCoords_(eNodMat_(:,3),:),2,2);
						edge3 = vecnorm(nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,3),:),2,2);
						edgeLgth = [edge1 edge2 edge3];						
				end
				tVarying = sum(edgeLgth, 2)/3  / 5;
				t = min(tVarying);
				shellThicknessList_ = ones(numEles_,1) .* t;
			else
				warning('Un-supported Data!'); return;
			end
	end
	
	%%4. Read boundary condition
	startReadingLoads = fscanf(fid, '%s %s', 2); 
	if ~strcmp(startReadingLoads, 'NodeForces:'), warning('Un-supported Data!'); return; end
	numLoadedNodes = fscanf(fid, '%d', 1);
	if numLoadedNodes>0	
		switch domainType
			case 'Plane'
				loadingCond_ = fscanf(fid, '%d %e %e', [3, numLoadedNodes])'; 
			case 'Solid'
				loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])'; 
			case 'Shell'
				loadingCond_ = fscanf(fid, '%d %e %e %e %e %e %e', [7, numLoadedNodes])'; 				
		end		
	else 
		loadingCond_ = []; 
	end

	startReadingFixations = fscanf(fid, '%s %s', 2);
    if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
	numFixedNodes = fscanf(fid, '%d', 1);
	if numFixedNodes>0
		switch domainType
			case 'Plane'
				fixingCond_ = fscanf(fid, '%d', [1, numFixedNodes])'; 
				fixingCond_ = [fixingCond_ ones(numFixedNodes, 2)];
			case 'Solid'
				fixingCond_ = fscanf(fid, '%d', [1, numFixedNodes])'; 
				fixingCond_ = [fixingCond_ ones(numFixedNodes, 3)];
			case 'Shell'
				fixingCond_ = fscanf(fid, '%d', [7, numFixedNodes])'; 			
		end	
	else
		fixingCond_ = []; 
	end
	fclose(fid);

	%%4. Initialize Additional Mesh Info
    materialIndicatorField_ = ones(numEles_,1);
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	switch eleType_.eleName
		case 'Plane133'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromPlaneMesh();
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 4  2 5  3 6]);
			EvaluateMeshQuality();
		case 'Plane144'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromPlaneMesh();
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5  2 6  3 7  4 8]);
			EvaluateMeshQuality();
		case 'Solid144'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromSolidMesh();
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5 9  2 6 10  3 7 11  4 8 12]);
			EvaluateMeshQuality();			
		case 'Solid188'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromSolidMesh();
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);
			EvaluateMeshQuality();
		case 'Shell133'
			boundaryFaceNodMat_ = eNodMat_;
			nodState_ = ones(numNodes_,1);
			boundaryNodes_ = (1:numNodes_)';
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 6*eNodMat_; eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 4 7 10 13 16  2 5 8 11 14 17  3 6 9 12 15 18]);
			EvaluateMeshQuality();
		case 'Shell144'
			boundaryFaceNodMat_ = eNodMat_;
			nodState_ = ones(numNodes_,1);
			boundaryNodes_ = (1:numNodes_)';
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 6*eNodMat_; eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5 9 13 17 21  2 6 10 14 18 22  3 7 11 15 19 23  4 8 12 16 20 24]);
			EvaluateMeshQuality();	
	end
end