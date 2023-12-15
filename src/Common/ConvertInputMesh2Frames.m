function [edgeNodMat, nodState, boundaryNodes] = ConvertInputMesh2Frames(domainType, meshType)
	global numNodes_;
	global numEles_;
	global eNodMat_;
	switch domainType
		case 'Plane'
			switch meshType
				case 'Tri'
					numEdgesPerEle = 3;
					edgeIndices = eNodMat_(:, [1 2  2 3  3 1])';				
				case 'Quad'
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
			edgeNodMat = uniqueEdges;
		case 'Solid'
			switch meshType
				case 'Tet'
					numNodesPerFace = 3;
					numFacesPerEle = 4;
					numEdgesPerEle = 6;
					patchIndices = eNodMat_(:, [3 2 1  1 2 4  2 3 4  3 1 4])';
					edgeIndices = eNodMat_(:, [1 2  2 3  3 1  1 4  2 4  3 4])';	
				case 'Hex'
					numNodesPerFace = 4;
					numFacesPerEle = 6;
					numEdgesPerEle = 12;
					patchIndices = eNodMat_(:, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
					edgeIndices = eNodMat_(:, [1 2  2 3  3 4  4 1  5 6  6 7  7 8  8 5  1 5  2 6  3 7  4 8])';
			end
			patchIndices = reshape(patchIndices(:), numNodesPerFace, numFacesPerEle*numEles_)';	
			tmp = sort(patchIndices,2);
			[uniqueFaces, ia, ic] = unique(tmp, 'stable', 'rows');
			leftFaceIDs = (1:numFacesPerEle*numEles_)'; leftFaceIDs = setdiff(leftFaceIDs, ia);
			leftFaces = tmp(leftFaceIDs,:);
			[surfFaces, surfFacesIDsInUniqueFaces] = setdiff(uniqueFaces, leftFaces, 'rows');
			boundaryFaceNodMat = patchIndices(ia(surfFacesIDsInUniqueFaces),:);
            boundaryNodes = unique(boundaryFaceNodMat);
			nodState = zeros(numNodes_,1); 
			nodState(boundaryNodes) = 1;	
			edgeIndices = reshape(edgeIndices, 2, numEdgesPerEle*numEles_);
			tmp = sort(edgeIndices,1)';
			[edgeNodMat, ~, ~] = unique(tmp, 'rows');			
	end
	
end