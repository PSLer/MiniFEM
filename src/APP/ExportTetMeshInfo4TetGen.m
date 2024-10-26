function ExportTetMeshInfo4TetGen(lowerB, upperB)
	global outPath_;
	global eleType_;
	global vonMisesStressField_;
	global boundingBox_;
	global numEles_; 
	global boundaryFaceNodMat_;
	global boundaryNodes_;
	global nodeCoords_;
	global eNodMat_;
	global numNodes_;
	if ~strcmp(eleType_.eleName, 'Solid144'), return; end
	if isempty(vonMisesStressField_), return; end

	edgeIndices = boundaryFaceNodMat_(:, [1 2  2 3  3 1])';
	numEdgesPerEle = 3;
	edgeIndices = reshape(edgeIndices(:), 2, numEdgesPerEle*size(boundaryFaceNodMat_,1))';	
	tmp = sort(edgeIndices,2);
	[uniqueEdges, ia, ~] = unique(tmp, 'stable', 'rows');
	
	refTetCell = min(boundingBox_(2,:)-boundingBox_(1,:)) / 100;
	sizeList = vonMisesStressField_ / max(vonMisesStressField_);
	p = 2; sizeList = sizeList.^(1/p);
	sizeList = ((sizeList - min(sizeList)) / (1-min(sizeList)) * (lowerB-upperB) + upperB)*refTetCell;
	
	outopt = 'node'; %% 'mesh', 'smesh', 'smesh2', 'node'
	switch outopt
		case 'mesh'
			fileName = strcat(outPath_, 'inputTetMesh4TetGen.mesh');
			fid = fopen(fileName, 'w');
			fprintf(fid, '%s ', 'MeshVersionFormatted');
			fprintf(fid, '%d\n', 1);
			fprintf(fid, '\n');
			fprintf(fid, '%s', 'Dimension');
			fprintf(fid, '\n');
			fprintf(fid, '%d\n', 3);
			fprintf(fid, '\n');
			fprintf(fid, '\n');
			fprintf(fid, '%s %s %s %s %s', '# Set of mesh vertices');
			fprintf(fid, '\n');
			fprintf(fid, '%s', 'Vertices');
			fprintf(fid, '\n');
			fprintf(fid, '%d\n', numNodes_);
			fprintf(fid, '%f %f %f %f\n', [nodeCoords_ sizeList]');
			
			fprintf(fid, '\n');
			fprintf(fid, '%s', 'Edges');
			fprintf(fid, '\n');
			fprintf(fid, '%d\n', size(uniqueEdges,1));
			fprintf(fid, '%d %d %d\n', [uniqueEdges -ones(size(uniqueEdges,1),1)]');
			
			fprintf(fid, '\n');
			fprintf(fid, '%s %s %s %s', '# Set of Triangles');
			fprintf(fid, '\n');
			fprintf(fid, '%s', 'Triangles');
			fprintf(fid, '\n');
			fprintf(fid, '%d\n', size(boundaryFaceNodMat_,1));
			fprintf(fid, '%d %d %d %d\n', [boundaryFaceNodMat_ -ones(size(boundaryFaceNodMat_,1),1)]');
			
			fprintf(fid, '\n');
			fprintf(fid, '%s %s %s %s', '# Set of Tetrahedra');
			fprintf(fid, '\n');
			fprintf(fid, '%s', 'Tetrahedra');
			fprintf(fid, '\n');
			fprintf(fid, '%d\n', numEles_);
			fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ zeros(numEles_,1)]');
			
			fprintf(fid, '\n');
			fprintf(fid, '%s', 'End');
			fclose(fid);		
		case 'smesh'
			patchIndices = eNodMat_(:, [3 2 1  1 2 4  2 3 4  3 1 4])';
			patchIndices = reshape(patchIndices(:), 3, 4*numEles_)';	
			tmp = sort(patchIndices,2);
			[uniqueFaces1, ia, ~] = unique(tmp, 'stable', 'rows');			
			uniqueFaces2 = patchIndices(ia,:);
			uniqueFaces = uniqueFaces2;
			fileName = strcat(outPath_, 'inputTetMesh4TetGen.smesh');
			fid = fopen(fileName, 'w');
			fprintf(fid, '%d %d %d %d\n', [numNodes_ 3 0 0]);
			fprintf(fid, '%d %f %f %f\n', [(1:numNodes_)' nodeCoords_]');
			fprintf(fid, '%d %d\n', [size(uniqueFaces,1) 0]);
			fprintf(fid, '%d %d %d %d\n', [3*ones(size(uniqueFaces,1),1) uniqueFaces]');
			fprintf(fid, '%d\n', 0);
			fprintf(fid, '%d\n', 0);
			fclose(fid);
			
			fileName = strcat(outPath_, 'inputTetMesh4TetGen.mtr');
			fid = fopen(fileName, 'w');
			fprintf(fid, '%d %d\n', [numNodes_ 1]);
			fprintf(fid, '%f\n', sizeList');
			fclose(fid);
		case 'smesh2'
			reOrderedSurfaceMesh = zeros(numNodes_,1);
			reOrderedSurfaceMesh(boundaryNodes_) = (1:numel(boundaryNodes_))';
			reOrderedSurfaceMesh = reOrderedSurfaceMesh(boundaryFaceNodMat_);
			fileName = strcat(outPath_, 'inputTetMesh4TetGen.smesh');
			fid = fopen(fileName, 'w');
			fprintf(fid, '%d %d %d %d\n', [numel(boundaryNodes_) 3 0 0]);
			fprintf(fid, '%d %f %f %f\n', [(1:numel(boundaryNodes_))' nodeCoords_(boundaryNodes_,:)]');
			fprintf(fid, '%d %d\n', [size(reOrderedSurfaceMesh,1) 0]);
			fprintf(fid, '%d %d %d %d\n', [3*ones(size(reOrderedSurfaceMesh,1),1) reOrderedSurfaceMesh]');
			fprintf(fid, '%d\n', 0);
			fprintf(fid, '%d\n', 0);
			fclose(fid);
			
			fileName = strcat(outPath_, 'inputTetMesh4TetGen.mtr');
			fid = fopen(fileName, 'w');
			fprintf(fid, '%d %d\n', [numel(boundaryNodes_) 1]);
			fprintf(fid, '%f\n', sizeList(boundaryNodes_,1)');
			fclose(fid);
		case 'node'
			fileName = strcat(outPath_, 'inputPoints4TetGen.node');
			fid = fopen(fileName, 'w');
			fprintf(fid, '%d %d %d %d\n', [numNodes_ 3 0 0]);
			fprintf(fid, '%d %f %f %f\n', [(1:numNodes_)' nodeCoords_]');			
			fclose(fid);
	end
	

end