function CreateFromExternalHexMesh_vtkFormat(fileName)
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
	fgetl(fid); fgetl(fid); fgetl(fid); fgetl(fid);
	
	%%2. read node coordinates
	tmp = fscanf(fid, '%s', 1); 
	numNodes_ = fscanf(fid, '%d', 1);
	
	tmp = fscanf(fid, '%s', 1);
	nodeCoords_ = fscanf(fid, '%f %f %f', [3, numNodes_]); nodeCoords_ = nodeCoords_'; 

	%%3. read element
	tmp = fscanf(fid, '%s', 1);
	numEles_ = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%d', 1);
	eNodMat_ = fscanf(fid, '%d %d %d %d %d %d %d %d %d', [9, numEles_]); 
	eNodMat_ = eNodMat_'; eNodMat_(:,1) = []; eNodMat_ = eNodMat_+1; eNodMat_ = int32(eNodMat_);

	%%4. read element type 
	tmp = fscanf(fid, '%s', 1);
	tmp = fscanf(fid, '%d', 1);
	eleState_ = fscanf(fid, '%d', [1 tmp])'; eleState_ = int32(eleState_);

	%%5. identify node type (interior or not)
	tmp = fscanf(fid, '%s %s', 2);
	tmp = fscanf(fid, '%s %s %s', 3);
	tmp = fscanf(fid, '%s %s', 2);
	nodState_ = fscanf(fid, '%d', [1 numNodes_])'; nodState_ = int32(nodState_);	
	fclose(fid);

	%%6. Fit External Hex-mesh for FEA
	%FitExternalHexMesh4FEA();
	
	%%7. Initialize Additional Mesh Info
	numDOFs_ = 3*numNodes_;
	boundaryNodes_ = find(1==nodState_); boundaryNodes_ = int32(boundaryNodes_);
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
	eDofMat_ = eDofMat_(:,[1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);	
end