function CreateMdl_StressData(fileName)
	global boundingBox_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global materialIndicatorField_;
	global boundaryNodes_;
	global boundaryFaceNodMat_;
	global numNodsAroundEleVec_;
	global nodState_; global eleState_;
	global fixingCond_;
	global loadingCond_;
	
	%%1. read file header
	fid = fopen(fileName, 'r');
	fgetl(fid);
	fgetl(fid);
	domainType = fscanf(fid, '%s', 1);
	if ~(strcmp(domainType, 'Plane') || strcmp(domainType, 'Solid')), warning('Un-supported Data!'); return; end
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
			case 'Solid'
				fixingCond_ = [fixingCond_ ones(numFixedNodes, 3)];
		end	
	else
		fixingCond_ = []; 
	end
	fclose(fid);

	%%4. Initialize Additional Mesh Info	
	switch domainType
		case 'Plane'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromPlaneMesh();
		case 'Solid'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromSolidMesh();
		case 'Shell'
			boundaryFaceNodMat_ = eNodMat_;
			nodState_ = ones(numNodes_,1);
			boundaryNodes_ = (1:numNodes_)';			
	end	
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	switch meshType
		case 'Quad'
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5  2 6  3 7  4 8]);
		case 'Tri'
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 4  2 5  3 6]);
		case 'Hex'
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);			
		case 'Tet'
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5 9  2 6 10  3 7 11  4 8 12]);			
	end
	materialIndicatorField_ = ones(numEles_,1);
	EvaluateMeshQuality();
end