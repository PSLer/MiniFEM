function CreateCartesianHexMeshFromTriFaceMesh_plyFormat(fileName, resCtrl)
	global eleType_;
	global nelx_; global nely_; global nelz_;
	global boundingBox_;
	if ~strcmp(eleType_.eleName, 'Solid188')
		error('Only Works with 3D Solid188 Element!');
	end
	
	fid = fopen(fileName, 'r');
	tmp = fscanf(fid, '%s', 1);
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s', 2);
	numNodesTriPly = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s %s', 3);
	tmp = fscanf(fid, '%s %s', 2);
	numElementsTriPly = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%s %s %s %s %s', 5);
	tmp = fscanf(fid, '%s', 1);
	nodeCoordsTriPly = fscanf(fid,'%f %f %f',[3,numNodesTriPly])'; 
	eNodMatTriPly = fscanf(fid,'%d %d %d %d',[4,numElementsTriPly]); 
	eNodMatTriPly(1,:) = []; 
	eNodMatTriPly = eNodMatTriPly' + 1;	
	fclose(fid);
	
	minX = min(nodeCoordsTriPly(:,1)); minY = min(nodeCoordsTriPly(:,2)); minZ = min(nodeCoordsTriPly(:,3));
	maxX = max(nodeCoordsTriPly(:,1)); maxY = max(nodeCoordsTriPly(:,2)); maxZ = max(nodeCoordsTriPly(:,3));	
	boundingBox_ = [minX minY minZ; maxX maxY maxZ];
	maxDimensions = boundingBox_(2,:) - boundingBox_(1,:);
	dimensionResolutions = round(resCtrl*(maxDimensions/max(maxDimensions)));
	nelx_ = dimensionResolutions(1);
	nely_ = dimensionResolutions(2);
	nelz_ = dimensionResolutions(3);
	
	%%re-organize the coord list into Nx3x3 array - The vertex coordinates for each facet, with:
	%%1 row for each facet
	%%3 columns for the x,y,z coordinates
	%%3 pages for the three vertices			
	formatedTriMesh = zeros(numElementsTriPly,3,3);
	formatedTriMesh(:,:,1) = nodeCoordsTriPly(eNodMatTriPly(:,1),:);
	formatedTriMesh(:,:,2) = nodeCoordsTriPly(eNodMatTriPly(:,2),:);
	formatedTriMesh(:,:,3) = nodeCoordsTriPly(eNodMatTriPly(:,3),:);

	voxelizedModel = flip(Voxelize(nelx_, nely_, nelz_, formatedTriMesh),1);
	
	GenerateCartesianMesh3D(voxelizedModel);
	EvaluateMeshQuality();
end