function CreateFromWrappedTetFEAmodel_meshFormat(fileName)
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
	% global eleVolumes_;
	if ~strcmp(eleType_.eleName, 'Solid144')
		error('Only Works with Solid144 Element!');
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
	numEles_ = fscanf(fid, '%d', 1)/4;
	eNodMat_ = fscanf(fid, '%d %d %d %d %d', [5, numEles_]); 
	eNodMat_ = eNodMat_'; eNodMat_(:,end) = []; eNodMat_ = int32(eNodMat_);
	
	%%4. Read bpundary condition
	tmp = fscanf(fid, '%s %s', 2);
	numFixedNodes = fscanf(fid, '%d', 1);
	if numFixedNodes
		fixingCond_ = fscanf(fid, '%d %d %d %d', [4 numFixedNodes])'; 
	end

	%%7. loading condition
	tmp = fscanf(fid, '%s %s', 2);
	numLoadedNodes = fscanf(fid, '%d', 1);
	if numLoadedNodes
		loadingCond_ = fscanf(fid, '%d %e %e %e', [4 numLoadedNodes])';
	end
	fclose(fid);

	%%4. Fit External Hex-mesh for FEA
	%FitExternalHexMesh4FEA();
	
	%%5. Initialize Additional Mesh Info
	%% Extract Boundary Mesh
	% patchIndices = eNodMat_(:, [1 2 3  1 2 4  2 3 4  3 1 4])';
	% patchIndices = reshape(patchIndices(:), 3, 4*numEles_);	
	% tmp = sort(patchIndices',2);
	% [~, ia, ic] = unique(tmp, 'rows');
	% numRawPatchs = 4*numEles_;
	% patchState = zeros(length(ia),1);
	% for ii=1:numRawPatchs
		% patchState(ic(ii)) = patchState(ic(ii)) + 1;
	% end
	% patchIndexOnBoundary = ia(1==patchState);
	% boundaryPatchs = patchIndices(:,patchIndexOnBoundary');
	% boundaryNodes_ = int32(unique(boundaryPatchs));
	% nodState_ = zeros(numNodes_,1,'int32'); nodState_(boundaryNodes_) = 1;
	% eleState_ = 4*ones(numEles_,1,'int32');	
	[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromSolidMesh();
	
	numDOFs_ = 3*numNodes_;
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
	eDofMat_ = eDofMat_(:,[1 5 9  2 6 10  3 7 11  4 8 12]);
	
	tetVtxs = zeros(4,3,numEles_);
	for ii=1:numEles_
		tetVtxs(:,:,ii) = nodeCoords_(eNodMat_(ii,:),:);
	end
	% eleVolumes_ = CalcTetVolume(tetVtxs);
	EvaluateMeshQuality();
end