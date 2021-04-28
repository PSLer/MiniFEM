function CreateFromExternalHexMesh_meshFormat(fileName)
	global eleType_;
	global boundingBox_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global boundaryNodes_;
	global eleState_; global nodState_;
	global numNodsAroundEleVec_;
	if ~strcmp(eleType_.eleName, 'Solid188')
		error('Only Works with 3D Solid188 Element!');
	end
	
	%%1. read file header
	fid = fopen(fileName, 'r');
	fgetl(fid); tmp = fscanf(fid, '%s', 1); tmp = fscanf(fid, '%d', 1);
	
	%%2. read node coordinates
	tmp = fscanf(fid, '%s', 1); 
	numNodes_ = fscanf(fid, '%d', 1);
	nodeCoords_ = fscanf(fid, '%f %f %f  %f', [4, numNodes_]); 
	nodeCoords_ = nodeCoords_'; nodeCoords_(:,4) = [];

	%%3. read element
	tmp = fscanf(fid, '%s', 1);
	numEles_ = fscanf(fid, '%d', 1);
	eNodMat_ = fscanf(fid, '%d %d %d %d %d %d %d %d %d', [9, numEles_]); 
	eNodMat_ = eNodMat_'; eNodMat_(:,end) = []; eNodMat_ = int32(eNodMat_);
	fclose(fid);

	%%6. Fit External Hex-mesh for FEA
	%FitExternalHexMesh4FEA();
	
	%%7. Initialize Additional Mesh Info
	%% Extract Boundary Mesh
	patchIndices = eNodMat_(:, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
	patchIndices = reshape(patchIndices(:), 4, 6*numEles_);	
	tmp = sort(patchIndices',2);
	[~, ia, ic] = unique(tmp, 'rows');
	numRawPatchs = 6*numEles_;
	patchState = zeros(length(ia),1);
	for ii=1:numRawPatchs
		patchState(ic(ii)) = patchState(ic(ii)) + 1;
	end
	patchIndexOnBoundary = ia(1==patchState);
	boundaryPatchs = patchIndices(:,patchIndexOnBoundary');
	boundaryNodes_ = int32(unique(boundaryPatchs));
	nodState_ = zeros(numNodes_,1,'int32'); nodState_(boundaryNodes_) = 1;
	eleState_ = 12*ones(numEles_,1,'int32');
	
	numDOFs_ = 3*numNodes_;
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
	eDofMat_ = eDofMat_(:,[1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);	
end