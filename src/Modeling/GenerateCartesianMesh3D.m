function GenerateCartesianMesh3D(voxelizedModel)
	global meshType_;
	global nelx_; global nely_; global nelz_; global boundingBox_;	
	global numEles_; global eNodMat_; global eDofMat_;
	global numNodes_; global numDOFs_; global nodeCoords_;
	global carEleMapBack_; global carEleMapForward_;
	global carNodMapBack_; global carNodMapForward_;
	global numNodsAroundEleVec_;
	global boundaryNodes_;
	
	meshType_ = 'Cartesian';
	carEleMapBack_ = int32(find(1==voxelizedModel));
	numEles_ = length(carEleMapBack_);
	carEleMapForward_ = zeros(nelx_*nely_*nelz_,1,'int32');	
	carEleMapForward_(carEleMapBack_) = (1:numEles_)';
	nodenrs = reshape(1:(nelx_+1)*(nely_+1)*(nelz_+1), 1+nely_, 1+nelx_, 1+nelz_); nodenrs = int32(nodenrs);
	eNodVec = reshape(nodenrs(1:end-1,1:end-1,1:end-1)+1, nelx_*nely_*nelz_, 1);
	eNodMat_ = repmat(eNodVec(carEleMapBack_),1,8);
	tmp = [0 nely_+[1 0] -1 (nely_+1)*(nelx_+1)+[0 nely_+[1 0] -1]]; tmp = int32(tmp);
	for ii=1:8
		eNodMat_(:,ii) = eNodMat_(:,ii) + repmat(tmp(ii), numEles_,1);
	end	
	carNodMapBack_ = unique(eNodMat_);
	numNodes_ = length(carNodMapBack_);
	numDOFs_ = 3*numNodes_;
	carNodMapForward_ = zeros((nelx_+1)*(nely_+1)*(nelz_+1),1,'int32');
	carNodMapForward_(carNodMapBack_) = (1:numNodes_)';		
	for ii=1:8
		eNodMat_(:,ii) = carNodMapForward_(eNodMat_(:,ii));
	end
	nodeCoords_ = zeros(numNodes_,3);
	
	xSeed = boundingBox_(1,1):(boundingBox_(2,1)-boundingBox_(1,1))/nelx_:boundingBox_(2,1);
	ySeed = boundingBox_(2,2):(boundingBox_(1,2)-boundingBox_(2,2))/nely_:boundingBox_(1,2);	
	zSeed = boundingBox_(1,3):(boundingBox_(2,3)-boundingBox_(1,3))/nelz_:boundingBox_(2,3);		
	tmp = reshape(repmat(xSeed,nely_+1,1), (nelx_+1)*(nely_+1), 1); tmp = repmat(tmp, (nelz_+1), 1);
	nodeCoords_(:,1) = tmp(carNodMapBack_);
	tmp = repmat(repmat(ySeed,1,nelx_+1 )', (nelz_+1), 1);
	nodeCoords_(:,2) = tmp(carNodMapBack_);
	tmp = reshape(repmat(zSeed,(nelx_+1)*(nely_+1),1), (nelx_+1)*(nely_+1)*(nelz_+1), 1);
	nodeCoords_(:,3) = tmp(carNodMapBack_);

	tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
	eDofMat_ = eDofMat_(:,[1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);
	
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	boundaryNodes_ = find(numNodsAroundEleVec_<8);	
end