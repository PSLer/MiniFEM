function IO_ImportTriMesh2D(fileName)
	global simMesh_;
	global surfMesh_;
	global boundingBox_;
	simMesh_ = Data_ArbitraryMeshStruct();
	surfMesh_ = Data_ArbitraryMeshStruct();
	[~,~,dataType] = fileparts(fileName);
	switch dataType
		case '.msh'
			IO_ImportTriMesh2D_Format_msh(fileName);
	end
	boundingBox_ = [min(surfMesh_.nodeCoords,[],1); max(surfMesh_.nodeCoords,[],1)];
end



function IO_ImportTriMesh2D_Format_msh(fileName)
	global simMesh_;
	global surfMesh_;
	
	%%Read Data
    fid = fopen(fileName, 'r');
	if ~strcmp(fscanf(fid, '%s', 1), '$MeshFormat'), error('Incompatible Mesh Data Format!'); end
	if 2.2~=fscanf(fid, '%f', 1), error('Incompatible Mesh Data Format!'); end
	if 0~=fscanf(fid, '%d', 1), error('Incompatible Mesh Data Format!'); end
	if 8~=fscanf(fid, '%d', 1), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), '$EndMeshFormat'), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), '$Nodes'), error('Incompatible Mesh Data Format!'); end
	simMesh_.numNodes = fscanf(fid, '%d', 1);
	simMesh_.nodeCoords = fscanf(fid, '%d %f %f', [3, simMesh_.numNodes])';
	simMesh_.nodeCoords(:,1) = [];
	if ~strcmp(fscanf(fid, '%s', 1), '$EndNodes'), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), '$Elements'), error('Incompatible Mesh Data Format!'); end
	simMesh_.numElements = fscanf(fid, '%d', 1);
	simMesh_.eNodMat = fscanf(fid, '%d %d %d %d %d %d', [6, simMesh_.numElements])';
	simMesh_.eNodMat(:,[1 2 3]) = [];
	fclose(fid);
	
	%%Extract Boundary Info of Mesh
	[simMesh_.boundaryNodeCoords, simMesh_.boundaryPatchNodMat, simMesh_.nodeState, ~] = ...
			Common_ExtractBoundaryInfoFromTriMesh2D(simMesh_.nodeCoords, simMesh_.eNodMat);
	surfMesh_.nodeCoords = simMesh_.boundaryNodeCoords;
	surfMesh_.eNodMat = simMesh_.boundaryPatchNodMat;	
	simMesh_.meshType = 'TRI';
	surfMesh_.numNodes = size(surfMesh_.nodeCoords,1);
	surfMesh_.numElements = size(surfMesh_.eNodMat,1);
	simMesh_.state = 1;
	surfMesh_.state = 1;		
end

function [reOrderedBoundaryNodeCoords, reOrderedBoundaryFaceNodMat, nodState, eleState] = ...
			Common_ExtractBoundaryInfoFromTriMesh2D(nodeCoords, eNodMat)
	
	numNodes = size(nodeCoords,1);
	[numEles, numNodesPerEle] = size(eNodMat);

	numEdgesPerEle = 3;
	numEdgesPerEle = 6;
	patchIndices = eNodMat(:, [1 2  2 3  3 1])';
	patchIndices = reshape(patchIndices(:), 2, 3*numEles)';	
	patchIndices = sort(patchIndices,2);
	[uniqueEdges, ia, ic] = unique(patchIndices, 'stable', 'rows');
	
	leftEdgeIDs = (1:3*numEles)'; leftEdgeIDs = setdiff(leftEdgeIDs, ia);
	leftEdges = patchIndices(leftEdgeIDs,:);
	
	[bEdges, bEdgeIDsInUniqueEdges] = setdiff(uniqueEdges, leftEdges, 'rows');
	boundaryEdgeNodMat = patchIndices(ia(bEdgeIDsInUniqueEdges),:);
	boundaryNodes = unique(boundaryEdgeNodMat);
	nodState = zeros(numNodes,1); nodState(boundaryNodes) = 1;	
	eleState = numEdgesPerEle*ones(numEles,1);	
	
	allNodes = zeros(numNodes, 1);
	numBoundaryNodes = numel(boundaryNodes);
	allNodes(boundaryNodes,1) = (1:numBoundaryNodes)';
	reOrderedBoundaryFaceNodMat = allNodes(boundaryEdgeNodMat);
	reOrderedBoundaryNodeCoords = nodeCoords(boundaryNodes,:);
end