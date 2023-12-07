function [boundaryFaceNodMat, nodState, eleState, boundaryNodes] = ExtractBoundaryInfoFromSolidMesh()
	global eleType_;
	global numNodes_;
	global numEles_;
	global eNodMat_;
	
	if ~(strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188'))
		error('Un-supported Mesh!');
	end
	
	switch eleType_.eleName
		case 'Solid144'
			numNodesPerFace = 3;
			numFacesPerEle = 4;
			numEdgesPerEle = 6;
			patchIndices = eNodMat_(:, [3 2 1  1 2 4  2 3 4  3 1 4])';
		case 'Solid188'
			numNodesPerFace = 4;
			numFacesPerEle = 6;
			numEdgesPerEle = 12;
			patchIndices = eNodMat_(:, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
	end
	patchIndices = reshape(patchIndices(:), numNodesPerFace, numFacesPerEle*numEles_)';	
	tmp = sort(patchIndices,2);
	[uniqueFaces, ia, ic] = unique(tmp, 'stable', 'rows');
	leftFaceIDs = (1:numFacesPerEle*numEles_)'; leftFaceIDs = setdiff(leftFaceIDs, ia);
	leftFaces = tmp(leftFaceIDs,:);
	[surfFaces, surfFacesIDsInUniqueFaces] = setdiff(uniqueFaces, leftFaces, 'rows');
	boundaryFaceNodMat = patchIndices(ia(surfFacesIDsInUniqueFaces),:);
	boundaryNodes = int32(unique(boundaryFaceNodMat));
	nodState = zeros(numNodes_,1,'int32'); nodState(boundaryNodes) = 1;	
	eleState = numEdgesPerEle*ones(numEles_,1,'int32');	
end