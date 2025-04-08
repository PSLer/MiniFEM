function IO_ImportSolidMesh(fileName)
	global simMesh_;
	global surfMesh_;
	global boundingBox_;
	simMesh_ = Data_ArbitraryMeshStruct();
	surfMesh_ = Data_ArbitraryMeshStruct();
	[~,~,dataType] = fileparts(fileName);
	switch dataType
		case '.mesh'
			IO_ImportSolidMesh_Format_mesh(fileName);
		case '.vtk'
			IO_ImportSolidMesh_Format_vtk(fileName);
		case '.msh'
			IO_ImportSolidMesh_Format_msh(fileName);
	end
	boundingBox_ = [min(surfMesh_.nodeCoords,[],1); max(surfMesh_.nodeCoords,[],1)];
end

function IO_ImportSolidMesh_Format_mesh(fileName)
	global simMesh_;
	global surfMesh_;
	
	%%Read Data
	fid = fopen(fileName, 'r');
	if ~strcmp(fscanf(fid, '%s', 1), 'MeshVersionFormatted'), error('Incompatible Mesh Data Format!'); end
	if 1~=fscanf(fid, '%d', 1), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), 'Dimension'), error('Incompatible Mesh Data Format!'); end
	if 3~=fscanf(fid, '%d', 1), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), 'Vertices'), error('Incompatible Mesh Data Format!'); end
	simMesh_.numNodes = fscanf(fid, '%d', 1);
	simMesh_.nodeCoords = fscanf(fid, '%f %f %f  %f', [4, simMesh_.numNodes])'; 
	simMesh_.nodeCoords(:,4) = [];
	meshType = fscanf(fid, '%s', 1);
	switch meshType
		case 'Hexahedra'
			simMesh_.meshType = 'HEX';
			simMesh_.numElements = fscanf(fid, '%d', 1);
			simMesh_.eNodMat = fscanf(fid, '%d %d %d %d %d %d %d %d %d', [9, simMesh_.numElements])'; 
			simMesh_.eNodMat(:,end) = [];
		case 'Tetrahedra'
			simMesh_.meshType = 'TET';
			simMesh_.numElements = fscanf(fid, '%d', 1)/4;
			simMesh_.eNodMat = fscanf(fid, '%d %d %d %d %d', [5, simMesh_.numElements])';
			simMesh_.eNodMat(:,end) = [];
		otherwise
			error('Incompatible Mesh Data Format!');	
	end
	fclose(fid);
	
	%%Extract Boundary Info of Mesh
	[simMesh_.boundaryNodeCoords, simMesh_.boundaryPatchNodMat, simMesh_.nodeState, ~] = ...
			Common_ExtractBoundaryInfoFromSolidMesh(simMesh_.nodeCoords, simMesh_.eNodMat);
	surfMesh_.nodeCoords = simMesh_.boundaryNodeCoords;
	% switch simMesh_.meshType
		% case 'HEX'
			% surfMesh_.eNodMat = simMesh_.boundaryPatchNodMat(:,[1 2 3 3 4 1])';
			% surfMesh_.eNodMat = reshape(surfMesh_.eNodMat(:), 3, numel(surfMesh_.eNodMat)/3)';
		% case 'TET'
			% surfMesh_.eNodMat = simMesh_.boundaryPatchNodMat;
	% end
	surfMesh_.eNodMat = simMesh_.boundaryPatchNodMat;
	surfMesh_.numNodes = size(surfMesh_.nodeCoords,1);
	surfMesh_.numElements = size(surfMesh_.eNodMat,1);
	simMesh_.state = 1;
	surfMesh_.state = 1;
end

function IO_ImportSolidMesh_Format_vtk(fileName)
	global simMesh_;
	global surfMesh_;
	
	%%Read Data
    fid = fopen(fileName, 'r');
	if ~strcmp(fscanf(fid, '%s', 1), '#'), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), 'vtk'), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), 'DataFile'), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), 'Version'), error('Incompatible Mesh Data Format!'); end
	if 3.0~=fscanf(fid, '%f', 1), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), 'Volume'), error('Incompatible Mesh Data Format!'); end
    if ~strcmp(fscanf(fid, '%s', 1), 'mesh'), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), 'ASCII'), error('Incompatible Mesh Data Format!'); end	
	if ~strcmp(fscanf(fid, '%s', 1), 'DATASET'), error('Incompatible Mesh Data Format!'); end	
	if ~strcmp(fscanf(fid, '%s', 1), 'UNSTRUCTURED_GRID'), error('Incompatible Mesh Data Format!'); end	
	if ~strcmp(fscanf(fid, '%s', 1), 'POINTS'), error('Incompatible Mesh Data Format!'); end
	simMesh_.numNodes = fscanf(fid, '%d', 1);
	if ~strcmp(fscanf(fid, '%s', 1), 'double'), error('Incompatible Mesh Data Format!'); end
	simMesh_.nodeCoords = fscanf(fid, '%f %f %f', [3, simMesh_.numNodes])';
	if ~strcmp(fscanf(fid, '%s', 1), 'CELLS'), error('Incompatible Mesh Data Format!'); end
	simMesh_.numElements = fscanf(fid, '%d', 1);
	if 9~=fscanf(fid, '%d', 1)/simMesh_.numElements, error('Incompatible Mesh Data Format!'); end
	simMesh_.eNodMat = fscanf(fid, '%d %d %d %d %d %d %d %d %d', [9, simMesh_.numElements])';
	simMesh_.eNodMat(:,1) = []; 
	simMesh_.eNodMat = simMesh_.eNodMat + 1;
	fclose(fid);
	
	%%Extract Boundary Info of Mesh
	[simMesh_.boundaryNodeCoords, simMesh_.boundaryPatchNodMat, simMesh_.nodeState, ~] = ...
			Common_ExtractBoundaryInfoFromSolidMesh(simMesh_.nodeCoords, simMesh_.eNodMat);
	surfMesh_.nodeCoords = simMesh_.boundaryNodeCoords;
	surfMesh_.eNodMat = simMesh_.boundaryPatchNodMat(:,[1 2 3 3 4 1])';
	surfMesh_.eNodMat = reshape(surfMesh_.eNodMat(:), 3, numel(surfMesh_.eNodMat)/3)';	
	simMesh_.meshType = 'HEX';
	surfMesh_.numNodes = size(surfMesh_.nodeCoords,1);
	surfMesh_.numElements = size(surfMesh_.eNodMat,1);
	simMesh_.state = 1;
	surfMesh_.state = 1;	
end

function IO_ImportSolidMesh_Format_msh(fileName)
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
	simMesh_.nodeCoords = fscanf(fid, '%d %f %f %f', [4, simMesh_.numNodes])';
	simMesh_.nodeCoords(:,1) = [];
	if ~strcmp(fscanf(fid, '%s', 1), '$EndNodes'), error('Incompatible Mesh Data Format!'); end
	if ~strcmp(fscanf(fid, '%s', 1), '$Elements'), error('Incompatible Mesh Data Format!'); end
	simMesh_.numElements = fscanf(fid, '%d', 1);
	simMesh_.eNodMat = fscanf(fid, '%d %d %d %d %d %d %d', [7, simMesh_.numElements])';
	simMesh_.eNodMat(:,[1 2 3]) = [];
	fclose(fid);
	
	%%Extract Boundary Info of Mesh
	[simMesh_.boundaryNodeCoords, simMesh_.boundaryPatchNodMat, simMesh_.nodeState, ~] = ...
			Common_ExtractBoundaryInfoFromSolidMesh(simMesh_.nodeCoords, simMesh_.eNodMat);
	surfMesh_.nodeCoords = simMesh_.boundaryNodeCoords;
	surfMesh_.eNodMat = simMesh_.boundaryPatchNodMat;	
	simMesh_.meshType = 'TET';
	surfMesh_.numNodes = size(surfMesh_.nodeCoords,1);
	surfMesh_.numElements = size(surfMesh_.eNodMat,1);
	simMesh_.state = 1;
	surfMesh_.state = 1;		
end

function [reOrderedBoundaryNodeCoords, reOrderedBoundaryFaceNodMat, nodState, eleState] = ...
			Common_ExtractBoundaryInfoFromSolidMesh(nodeCoords, eNodMat)
	
	numNodes = size(nodeCoords,1);
	[numEles, numNodesPerEle] = size(eNodMat);
	switch numNodesPerEle
		case 4
			numNodesPerFace = 3;
			numFacesPerEle = 4;
			numEdgesPerEle = 6;
			patchIndices = eNodMat(:, [3 2 1  1 2 4  2 3 4  3 1 4])';
		case 8
			numNodesPerFace = 4;
			numFacesPerEle = 6;
			numEdgesPerEle = 12;
			patchIndices = eNodMat(:, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
	end
	patchIndices = reshape(patchIndices(:), numNodesPerFace, numFacesPerEle*numEles)';	
	tmp = sort(patchIndices,2);
	[uniqueFaces, ia, ic] = unique(tmp, 'stable', 'rows');
	leftFaceIDs = (1:numFacesPerEle*numEles)'; leftFaceIDs = setdiff(leftFaceIDs, ia);
	leftFaces = tmp(leftFaceIDs,:);
	[surfFaces, surfFacesIDsInUniqueFaces] = setdiff(uniqueFaces, leftFaces, 'rows');
	boundaryFaceNodMat = patchIndices(ia(surfFacesIDsInUniqueFaces),:);
	boundaryNodes = unique(boundaryFaceNodMat);
	nodState = zeros(numNodes,1); nodState(boundaryNodes) = 1;	
	eleState = numEdgesPerEle*ones(numEles,1);	
	
	allNodes = zeros(numNodes, 1);
	numBoundaryNodes = numel(boundaryNodes);
	allNodes(boundaryNodes,1) = (1:numBoundaryNodes)';
	reOrderedBoundaryFaceNodMat = allNodes(boundaryFaceNodMat);
	reOrderedBoundaryNodeCoords = nodeCoords(boundaryNodes,:);
end