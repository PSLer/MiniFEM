function CreateFromExternalQuadSurfMesh_meshFormat(fileName)
	global eleType_;
	global boundingBox_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global boundaryNodes_;
	global numNodsAroundEleVec_;
	global nodState_; global eleState_;
	if ~strcmp(eleType_.eleName, 'Shell144')
		error('Only Works with Shell144 Element!');
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
	eNodMat_ = fscanf(fid, '%d %d %d %d %d', [5, numEles_]); 
	eNodMat_ = eNodMat_'; eNodMat_(:,end) = []; eNodMat_ = int32(eNodMat_);
	fclose(fid);

	%%Initialize Additional Mesh Info
	numDOFs_ = 6*numNodes_;
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	tmp = 6*eNodMat_;
	eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
	eDofMat_ = eDofMat_(:,[1 5 9 13 17 21  2 6 10 14 18 22  3 7 11 15 19 23  4 8 12 16 20 24]);		
end