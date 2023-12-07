function GenerateCartesianMesh2D(voxelizedModel)
	global meshType_;
	global eleType_;
	global nelx_; global nely_; global boundingBox_;	
	global numEles_; global eNodMat_; global eDofMat_;
	global numNodes_; global numDOFs_; global nodeCoords_;
	global carEleMapBack_; global carEleMapForward_;
	global carNodMapBack_; global carNodMapForward_;
	global numNodsAroundEleVec_;
	global boundaryNodes_;
	global boundaryEdgeNodMat_;
	
	carEleMapBack_ = int32(find(1==voxelizedModel));
	numEles_ = length(carEleMapBack_);
	carEleMapForward_ = zeros(nelx_*nely_,1,'int32');	
	carEleMapForward_(carEleMapBack_) = (1:numEles_)';
	nodenrs = reshape(1:(nelx_+1)*(nely_+1), 1+nely_, 1+nelx_); nodenrs = int32(nodenrs);
	eNodVec = reshape(nodenrs(1:end-1,1:end-1)+1, nelx_*nely_, 1);
	eNodMat_ = repmat(eNodVec(carEleMapBack_),1,4);
	tmp = [0 nely_+[1 0] -1]; tmp = int32(tmp);
	for ii=1:4
		eNodMat_(:,ii) = eNodMat_(:,ii) + repmat(tmp(ii), numEles_,1);
	end	
	carNodMapBack_ = unique(eNodMat_);
	numNodes_ = length(carNodMapBack_);
	numDOFs_ = 2*numNodes_;
	carNodMapForward_ = zeros((nelx_+1)*(nely_+1),1,'int32');
	carNodMapForward_(carNodMapBack_) = (1:numNodes_)';		
	for ii=1:4
		eNodMat_(:,ii) = carNodMapForward_(eNodMat_(:,ii));
	end
	nodeCoords_ = zeros(numNodes_,2);

	xSeed = boundingBox_(1,1):(boundingBox_(2,1)-boundingBox_(1,1))/nelx_:boundingBox_(2,1);
	ySeed = boundingBox_(2,2):(boundingBox_(1,2)-boundingBox_(2,2))/nely_:boundingBox_(1,2);		
	tmp = reshape(repmat(xSeed, nely_+1, 1), (nelx_+1)*(nely_+1), 1);
	nodeCoords_(:,1) = tmp(carNodMapBack_);
	tmp = repmat(ySeed, 1, nelx_+1)';
	nodeCoords_(:,2) = tmp(carNodMapBack_);
	
	if strcmp(eleType_.eleName, 'Plane133')
		eNodMat_ = eNodMat_(:, [2 4 1 4 2 3]);
		eNodMat_ = reshape(eNodMat_', numel(eNodMat_), 1);
		numEles_ = 2*numEles_;
		eNodMat_ = reshape(eNodMat_, 3, numEles_)';
		tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
		eDofMat_ = eDofMat_(:,[1 4 2 5 3 6]);
		numAdjacentNodes2Ele = 6;
	else
		meshType_ = 'Cartesian';
		tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
		eDofMat_ = eDofMat_(:,[1 5 2 6 3 7 4 8]);
		numAdjacentNodes2Ele = 4;
	end
	
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	boundaryNodes_ = find(numNodsAroundEleVec_<numAdjacentNodes2Ele);
	[boundaryEdgeNodMat_, ~, ~, ~] = ExtractBoundaryInfoFromPlaneMesh();
end