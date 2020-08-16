function CreateModelExtMeshSrc(fileName)
	global nodeCoords_;
	global eNodMat_;
	global numEles_; 
	global numNodes_;
	global vtxLowerBound_; global vtxUpperBound_;
	global numNod2ElesVec_;
	global nodesOutline_;
	global originalValidNodeIndex_; 
	global edofMat_;
	global eleType_;
	global numDOFs_;
	global boundaryCond_;
	global loadingCond_;
	
	%%1. read head
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
	eNodMat_ = eNodMat_'; eNodMat_(:,1) = []; eNodMat_ = eNodMat_+1;
	reOrdering = [5 6 2 1 8 7 3 4];
	eNodMat_ = eNodMat_(:, reOrdering);
	
	%%4. read element type (useless here)
	tmp = fscanf(fid, '%s', 1);
	tmp = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%d', [1 tmp])';
	
	%%5. identify node type (interior or not)
	tmp = fscanf(fid, '%s %s', 2);
	tmp = fscanf(fid, '%s %s %s', 3);
	tmp = fscanf(fid, '%s %s', 2);
	tmp = fscanf(fid, '%d', [1 numNodes_])';
	nodesOutline_ = find(1==tmp);
	
	%%6. boundary condition
	tmp = fscanf(fid, '%s %s', 2);
	numFixedNodes = fscanf(fid, '%d', 1);
	boundaryCond_ = fscanf(fid, '%d', [1 numFixedNodes])';
	
	%%7. loading condition
	tmp = fscanf(fid, '%s %s', 2);
	numLoadedNodes = fscanf(fid, '%d', 1);	
	loadingCond_ = fscanf(fid, '%d %e %e %e', [4 numLoadedNodes])';		
	fclose(fid);
	
	%%%
	vtxLowerBound_ = [min(nodeCoords_(:,1)) min(nodeCoords_(:,2)) ...
		min(nodeCoords_(:,3))];
	vtxUpperBound_ = [max(nodeCoords_(:,1)) max(nodeCoords_(:,2)) ...
		max(nodeCoords_(:,3))];
	
	numNod2ElesVec_ = zeros(numNodes_,1);
	for ii=1:1:numEles_
		for jj=1:1:eleType_.numNode
			numNod2ElesVec_(eNodMat_(ii,jj)) = numNod2ElesVec_(eNodMat_(ii,jj))+1;
		end
	end
	nodesOutline_ = find(numNod2ElesVec_<eleType_.numNode);
	originalValidNodeIndex_ = (1:numNodes_)';
	
	edofMat_ = eNodMat_*3;
	index1 = 1:8;
	index1 = repmat(index1, 3, 1);
	index1 = reshape(index1, numel(index1), 1)';
	edofMat_ = edofMat_(:,index1);
	index2 = -2:0;
	index2 = repmat(index2, 1, 8);
	edofMat_ = edofMat_ + index2;
	
	numDOFs_ = eleType_.numNodeDOFs * numNodes_;
end
