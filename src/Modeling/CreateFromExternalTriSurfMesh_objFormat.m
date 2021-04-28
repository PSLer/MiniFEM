function CreateFromExternalTriSurfMesh_objFormat(fileName)
	global eleType_;
	global boundingBox_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global numNodsAroundEleVec_;
	if ~strcmp(eleType_.eleName, 'Shell133')
		error('Only Works with Shell133 Element!');
	end
	
	nodeCoords_ = []; eNodMat_ = [];
	fid = fopen(fileName, 'r');
	while 1
		tline = fgetl(fid);
		if ~ischar(tline), break; end  % exit at end of file 
		ln = sscanf(tline,'%s',1); % line type 
		switch ln
			case 'v'
				nodeCoords_(end+1,1:3) = sscanf(tline(2:end), '%e')';
			case 'f'
				eNodMat_(end+1,1:3) = sscanf(tline(2:end), '%d')';
		end
	end
	fclose(fid);
	eNodMat_ = int32(eNodMat_);
	numNodes_ = size(nodeCoords_,1); 
	numEles_ = size(eNodMat_,1);	
	
	%%Initialize Additional Mesh Info
	numDOFs_ = 6*numNodes_;
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	tmp = 6*eNodMat_;
	eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
	eDofMat_ = eDofMat_(:,[1 4 7 10 13 16  2 5 8 11 14 17  3 6 9 12 15 18]);	
end