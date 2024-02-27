function CreateFromExternalTriSurfMesh_plyFormat(fileName)
	global eleType_;
	global boundingBox_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global numNodsAroundEleVec_;
	if ~strcmp(eleType_.eleName, 'Shell133')
		error('Only Works with Shell133 Element!');
	end
	
	fid = fopen(fileName, 'r');
	tmp = fscanf(fid, '%s', 1);
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s', 2);
	numNodes_ = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s %s', 3);
	tmp = fscanf(fid, '%s %s', 2);
	numEles_ = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%s %s %s %s %s', 5);
	tmp = fscanf(fid, '%s', 1);
	nodeCoords_ = fscanf(fid,'%f %f %f',[3,numNodes_])'; 
	eNodMat_ = fscanf(fid,'%d %d %d %d',[4,numEles_]); 
	eNodMat_(1,:) = []; 
	eNodMat_ = eNodMat_' + 1; eNodMat_ = int32(eNodMat_);
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
	eDofMat_ = eDofMat_(:,[1 4 7 10 13 16  2 5 8 11 14 17  3 6 9 12 15 18]);	
end