function [bEdgeNodMat, nodState, eleState, boundaryNodes] = ExtractBoundaryInfoFromPlaneMesh()
	global eleType_;
	global numNodes_;
	global numEles_;
	global eNodMat_;
	
	if ~(strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144'))
		error('Un-supported Mesh!');
	end
	switch eleType_.eleName
		case 'Plane133'
			numEdgesPerEle = 3;
			edgeIndices = eNodMat_(:, [1 2  2 3  3 1])';	
		case 'Plane144'
			numEdgesPerEle = 4;
			edgeIndices = eNodMat_(:, [1 2  2 3  3 4  4 1])';	
	end
	edgeIndices = reshape(edgeIndices(:), 2, numEdgesPerEle*numEles_)';	
	tmp = sort(edgeIndices,2);
	[uniqueEdges, ia, ~] = unique(tmp, 'stable', 'rows');
	leftEdgeIDs = (1:numEdgesPerEle*numEles_)'; leftEdgeIDs = setdiff(leftEdgeIDs, ia);
	leftEdges = tmp(leftEdgeIDs,:);
	[~, boundaryEdgesIDsInUniqueEdges] = setdiff(uniqueEdges, leftEdges, 'rows');
	bEdgeNodMat = edgeIndices(ia(boundaryEdgesIDsInUniqueEdges),:);
	boundaryNodes = unique(bEdgeNodMat);
	nodState = zeros(numNodes_,1);
	nodState(boundaryNodes) = 1;
	eleState = numEdgesPerEle*ones(numEles_,1,'int32');
end