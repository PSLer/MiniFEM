function IO_ImportSurfaceMesh_MiniFEM(fileName)
	global simMesh_;
	global boundingBox_;
	simMesh_ = Data_ArbitraryMeshStruct();
	CreateMdl_ExclusiveFormat_Shell(fileName);
	boundingBox_ = [min(simMesh_.nodeCoords,[],1); max(simMesh_.nodeCoords,[],1)];
end

function CreateMdl_ExclusiveFormat_Shell(fileName)
	global simMesh_;
	global loadingCond_ fixingCond_;
	
	%%1. read file header
	fid = fopen(fileName, 'r');
	fgetl(fid);
	domainType = fscanf(fid, '%s', 1);
	meshType = fscanf(fid, '%s', 1);
	meshOrder = fscanf(fid, '%d', 1);
	
	if 1~=meshOrder, error('Un-supported Mesh!'); end
	startReadingVertices = fscanf(fid, '%s', 1);	
	if ~strcmp(startReadingVertices, 'Vertices:'), error('Un-supported Data!'); end
	%%2. read node coordinates
	numNodes_ = fscanf(fid, '%d', 1);	
	nodeCoords = fscanf(fid, '%e %e %e', [3, numNodes_])';
	%%3. read element
	startReadingElements = fscanf(fid, '%s', 1);
	if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
	numEles_ = fscanf(fid, '%d', 1);
	switch meshType
		case 'Tri'
			simMesh_.meshType = 'TRI';
			switch meshOrder
				case 1
					meshInfo = fscanf(fid, '%d %d %d %d %e', [5, numEles_])';
					eNodMat = meshInfo(:,1:end-2);
				otherwise
					error('Un-supported Mesh!');
			end
		case 'Quad'
			simMesh_.meshType = 'QUAD';
			switch meshOrder
				case 1
					meshInfo = fscanf(fid, '%d %d %d %d %d %e', [6, numEles_])'; 
					eNodMat = meshInfo(:,1:end-2);						
				otherwise
					error('Un-supported Mesh!');
			end				
		otherwise
			error('Un-supported Mesh!');
	end

	%%4. Read boundary condition
	startReadingLoads = fscanf(fid, '%s %s', 2); 
	if ~strcmp(startReadingLoads, 'NodeForces:'), error('Un-supported Data!'); end
	numLoadedNodes = fscanf(fid, '%d', 1);
	if numLoadedNodes>0	
		loadingCond_ = fscanf(fid, '%d %e %e %e %e %e %e', [7, numLoadedNodes])';
	else
		loadingCond_ = []; 
	end
	startReadingFixations = fscanf(fid, '%s %s', 2);
	if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
	numFixedNodes = fscanf(fid, '%d', 1);
	if numFixedNodes
		fixingCond_ = fscanf(fid, '%d %d %d %d %d %d %d', [7, numFixedNodes])';
	else
		fixingCond_ = [];
	end		
	fclose(fid);
	
	simMesh_.numNodes = size(nodeCoords,1); simMesh_.nodeCoords = nodeCoords;
	simMesh_.numElements = size(eNodMat,1); simMesh_.eNodMat = eNodMat;	
	
	eleCharacterSizeList = zeros(simMesh_.numElements,1);
	for ii=1:simMesh_.numElements
		switch simMesh_.meshType
			case 'TRI'
				iNodesPerEle = eNodMat(ii,1:3);
				edgePerEle = [1 2; 2 3; 3 1];			
			case 'QUAD'
				iNodesPerEle = eNodMat(ii,1:4);
				edgePerEle = [1 2; 2 3; 3 4; 4 1];					
		end
		iEleNodeCoords = nodeCoords(iNodesPerEle,:);
		iEleEdgeLengths = vecnorm(iEleNodeCoords(edgePerEle(:,2),:)-iEleNodeCoords(edgePerEle(:,1),:),2,2);
		eleCharacterSizeList(ii) = min(iEleEdgeLengths);
	end
	simMesh_.refSize = mean(eleCharacterSizeList);		
end