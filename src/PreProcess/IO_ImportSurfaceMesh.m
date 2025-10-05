function IO_ImportSurfaceMesh(fileName)
	global simMesh_;
	global boundingBox_;
	simMesh_ = Data_ArbitraryMeshStruct();
	[~,~,dataType] = fileparts(fileName);
	switch dataType
		case '.obj'
			IO_ImportSurfaceMesh_Format_obj(fileName);
		case '.ply'
			IO_ImportSurfaceMesh_Format_ply(fileName);
		case '.stl'
			IO_ImportSurfaceMesh_Format_stl(fileName);
		case '.mesh'
			IO_ImportSurfaceMesh_Format_mesh(fileName);			
	end
	boundingBox_ = [min(simMesh_.nodeCoords,[],1); max(simMesh_.nodeCoords,[],1)];
end

function IO_ImportSurfaceMesh_Format_obj(fileName)
	global simMesh_;
	nodeCoords = []; eNodMat = [];
	fid = fopen(fileName, 'r');
	while 1
		tline = fgetl(fid);
		if ~ischar(tline), break; end  % exit at end of file 
		ln = sscanf(tline,'%s',1); % line type 
		switch ln
			case 'v'
				nodeCoords(end+1,1:3) = sscanf(tline(2:end), '%e')';
			case 'f'
				eNodMat(end+1,1:3) = sscanf(tline(2:end), '%d')';
		end
	end
	fclose(fid);
	
	simMesh_.meshType = 'TRI';
	simMesh_.numNodes = size(nodeCoords,1); simMesh_.nodeCoords = nodeCoords;
	simMesh_.numElements = size(eNodMat,1); simMesh_.eNodMat = eNodMat;

	eleCharacterSizeList = zeros(simMesh_.numElements,1);
	for ii=1:simMesh_.numElements
		iNodesPerEle = eNodMat(ii,1:3);
		edgePerEle = [1 2; 2 3; 3 1];
		iEleNodeCoords = nodeCoords(iNodesPerEle,:);
		iEleEdgeLengths = vecnorm(iEleNodeCoords(edgePerEle(:,2),:)-iEleNodeCoords(edgePerEle(:,1),:),2,2);
		eleCharacterSizeList(ii) = min(iEleEdgeLengths);
	end
	simMesh_.refSize = mean(eleCharacterSizeList);
end

function IO_ImportSurfaceMesh_Format_ply(fileName)
	global simMesh_;

	fid = fopen(fileName, 'r');
	text_ply = fscanf(fid, '%s', 1);
	text_formatascii = fscanf(fid, '%s %s %s', 3); 
	text_elementvertex = fscanf(fid, '%s %s', 2);
	numNodes_ = fscanf(fid, '%d', 1);
	text_propertyfloatx = fscanf(fid, '%s %s %s', 3); 
	text_propertyfloaty = fscanf(fid, '%s %s %s', 3); 
	text_propertyfloatz = fscanf(fid, '%s %s %s', 3);
	text_elementface = fscanf(fid, '%s %s', 2);
	numEles = fscanf(fid, '%d', 1);
	text_propertylistucharuintvertex_indices = fscanf(fid, '%s %s %s %s %s', 5);
	text_end_header = fscanf(fid, '%s', 1);
	nodeCoords = fscanf(fid,'%f %f %f',[3,numNodes_])';
	eNodMat = NaN(numEles,4);
	eleTypeList = 3*ones(numEles,1);
	for ii=1:numEles
		iEleType = fscanf(fid, '%d', 1);
		switch iEleType
			case 3
				iEle = fscanf(fid,'%d %d %d',[1,3]);
				eNodMat(ii,1:3) = iEle;
			case 4
				iEle = fscanf(fid,'%d %d %d %d',[1,4]);
				eNodMat(ii,1:4) = iEle;
				eleTypeList(ii) = iEleType;
		end
	end
	if 3*numEles==sum(eleTypeList)
		simMesh_.meshType = 'TRI';
		eNodMat(:,4) = [];
	elseif 4*numEles==sum(eleTypeList)
		simMesh_.meshType = 'QUAD';
	end
	eNodMat = eNodMat + 1;
	fclose(fid);

	simMesh_.numNodes = size(nodeCoords,1); simMesh_.nodeCoords = nodeCoords;
	simMesh_.numElements = size(eNodMat,1); simMesh_.eNodMat = eNodMat;

	eleCharacterSizeList = zeros(simMesh_.numElements,1);
	for ii=1:simMesh_.numElements
		switch simMesh_.meshType
			case 'TRI'
				iNodesPerEle = eNodMat(ii,1:3);
				edgePerEle = [1 2; 2 3; 3 1];			
			case 'QUAD'
				iNodesPerEle = eNodMat(ii,1:4);
				edgePerEle = [1 2; 2 3; 3 4; 4 1];					
		end
		iEleNodeCoords = nodeCoords(iNodesPerEle,:);
		iEleEdgeLengths = vecnorm(iEleNodeCoords(edgePerEle(:,2),:)-iEleNodeCoords(edgePerEle(:,1),:),2,2);
		eleCharacterSizeList(ii) = min(iEleEdgeLengths);
	end
	simMesh_.refSize = mean(eleCharacterSizeList);	
end

function IO_ImportSurfaceMesh_Format_stl(fileName)
	global simMesh_;
	FV = stlread(fileName);
	nodeCoords = FV.Points;
	eNodMat = FV.ConnectivityList;
	
	simMesh_.meshType = 'TRI';
	simMesh_.numNodes = size(nodeCoords,1); simMesh_.nodeCoords = nodeCoords;
	simMesh_.numElements = size(eNodMat,1); simMesh_.eNodMat = eNodMat;

	eleCharacterSizeList = zeros(simMesh_.numElements,1);
	for ii=1:simMesh_.numElements
		iNodesPerEle = eNodMat(ii,1:3);
		edgePerEle = [1 2; 2 3; 3 1];
		iEleNodeCoords = nodeCoords(iNodesPerEle,:);
		iEleEdgeLengths = vecnorm(iEleNodeCoords(edgePerEle(:,2),:)-iEleNodeCoords(edgePerEle(:,1),:),2,2);
		eleCharacterSizeList(ii) = min(iEleEdgeLengths);
	end
	simMesh_.refSize = mean(eleCharacterSizeList);	
end

function IO_ImportSurfaceMesh_Format_mesh(fileName)
    global simMesh_;	
    
    fid = fopen(fileName, 'r');
	fgetl(fid); tmp = fscanf(fid, '%s', 1); tmp = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%s', 1); 
	numNodes_ = fscanf(fid, '%d', 1);
	nodeCoords = fscanf(fid, '%f %f %f  %f', [4, numNodes_]); 
	nodeCoords = nodeCoords'; nodeCoords(:,4) = [];
	tmp = fscanf(fid, '%s', 1);
	numEles_ = fscanf(fid, '%d', 1);
	eNodMat = fscanf(fid, '%d %d %d %d %d', [5, numEles_]); 
	eNodMat = eNodMat'; eNodMat(:,end) = []; 
	fclose(fid);

	simMesh_.meshType = 'QUAD';
	simMesh_.numNodes = size(nodeCoords,1); simMesh_.nodeCoords = nodeCoords;
	simMesh_.numElements = size(eNodMat,1); simMesh_.eNodMat = eNodMat;

	eleCharacterSizeList = zeros(simMesh_.numElements,1);
	for ii=1:simMesh_.numElements
		iNodesPerEle = eNodMat(ii,1:4);
		edgePerEle = [1 2; 2 3; 3 4; 4 1];
		iEleNodeCoords = nodeCoords(iNodesPerEle,:);
		iEleEdgeLengths = vecnorm(iEleNodeCoords(edgePerEle(:,2),:)-iEleNodeCoords(edgePerEle(:,1),:),2,2);
		eleCharacterSizeList(ii) = min(iEleEdgeLengths);
	end
	simMesh_.refSize = mean(eleCharacterSizeList);		
end