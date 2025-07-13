function CreateMdl_ExclusiveFormat(fileName)
	global boundingBox_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global diameterList_;
	global eleCrossSecAreaList_;
	global eleLengthList_;	
	global materialIndicatorField_;
	global boundaryNodes_;
	global boundaryFaceNodMat_;
	global numNodsAroundEleVec_;
	global nodState_; global eleState_;
	global fixingCond_;
	global loadingCond_;
	
	%%1. read file header
	fid = fopen(fileName, 'r');
	fgetl(fid);
	geoType = fscanf(fid, '%s', 1);
	% if ~(strcmp(geoType, 'Plane') || strcmp(geoType, 'Solid')), warning('Un-supported Data!'); return; end
	meshType = fscanf(fid, '%s', 1);
	meshOrder = fscanf(fid, '%d', 1);
	
	
	if 1~=meshOrder, error('Un-supported Mesh!'); end
	startReadingVertices = fscanf(fid, '%s', 1);
	if ~strcmp(startReadingVertices, 'Vertices:'), warning('Un-supported Data!'); return; end	
	%%2. read node coordinates
	numNodes_ = fscanf(fid, '%d', 1);
	switch geoType
		case 'Plane'
			numDOFs_ = 2*numNodes_;
			nodeCoords_ = fscanf(fid, '%e %e', [2, numNodes_])'; 
		case 'Solid'
			numDOFs_ = 3*numNodes_;
			nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';
		case 'Shell'
			numDOFs_ = 6*numNodes_;
			nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';
		case 'Frame'
			switch meshType
				case 'Beam2D'
					numDOFs_ = 2*numNodes_;
					nodeCoords_ = fscanf(fid, '%e %e', [2, numNodes_])';
				case 'Truss2D'
					numDOFs_ = 3*numNodes_;
					nodeCoords_ = fscanf(fid, '%e %e', [2, numNodes_])';
				case 'Beam3D'
					numDOFs_ = 6*numNodes_;
					nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';
				case 'Truss3D'
					numDOFs_ = 3*numNodes_;
					nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';			
			end
	end
	%%3. read element
	startReadingElements = fscanf(fid, '%s', 1);
	if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
	numEles_ = fscanf(fid, '%d', 1);
	if strcmp(geoType, 'Frame')
        switch meshType
			case 'Truss2D'
                SetElement('Truss122');	
                error('Un-supported Data!');
			case 'Truss3D'
                SetElement('Truss123');
                meshInfo = fscanf(fid, '%d %d %e %d', [4, numEles_])';
                eNodMat_ = meshInfo(:,1:2);
                diameterList_ = meshInfo(:,3);
                materialIndicatorField_ = meshInfo(:,end);
                % meshInfo = fscanf(fid, '%d %d', [2, numEles_])';
                % eNodMat_ = meshInfo(:,1:2);
                % diameterList_ = 0.01*ones(size(eNodMat_,1),1);
                % materialIndicatorField_ = ones(size(eNodMat_,1),1);                
			case 'Beam2D'
                SetElement('Beam122');	
            	error('Un-supported Data!');
			case 'Beam3D'
                SetElement('Beam123');
                meshInfo = fscanf(fid, '%d %d %e %d', [4, numEles_])';
                eNodMat_ = meshInfo(:,1:2);
                diameterList_ = meshInfo(:,3);
                materialIndicatorField_ = meshInfo(:,end);
        end		
		startReadingBoundaryNodes = fscanf(fid, '%s %s', 2);
		numNodesAgain = fscanf(fid, '%d', 1);
		nodState_ = fscanf(fid, '%d', [1 numNodesAgain]); nodState_ = nodState_(:);
		boundaryNodes_ = find(nodState_);
	else
		switch meshType
			case 'Quad'
				SetElement('Plane144');
				meshInfo = fscanf(fid, '%d %d %d %d %d', [5, numEles_])'; 
				eNodMat_ = meshInfo(:,1:end-1);
				materialIndicatorField_ = meshInfo(:,end);
			case 'Tri'
				SetElement('Plane133');
				meshInfo = fscanf(fid, '%d %d %d %d', [4, numEles_])';
				eNodMat_ = meshInfo(:,1:end-1);
				materialIndicatorField_ = meshInfo(:,end);			
			case 'Hex'
				SetElement('Solid188');
				meshInfo = fscanf(fid, '%d %d %d %d %d %d %d %d %d', [9, numEles_])';
				eNodMat_ = meshInfo(:,1:end-1);
				materialIndicatorField_ = meshInfo(:,end);			
			case 'Tet'
				SetElement('Solid144');
				meshInfo = fscanf(fid, '%d %d %d %d %d', [5, numEles_])';
				eNodMat_ = meshInfo(:,1:end-1);
				materialIndicatorField_ = meshInfo(:,end);
		end
	end
	
	%%4. Read boundary condition
	startReadingLoads = fscanf(fid, '%s %s', 2); 
	if ~strcmp(startReadingLoads, 'NodeForces:'), warning('Un-supported Data!'); return; end
	numLoadedNodes = fscanf(fid, '%d', 1);
	if numLoadedNodes>0	
		switch geoType
			case 'Plane'
				loadingCond_ = fscanf(fid, '%d %e %e', [3, numLoadedNodes])'; 
			case 'Solid'
				loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])';
			case 'Shell'
				loadingCond_ = fscanf(fid, '%d %e %e %e %e %e %e', [7, numLoadedNodes])';
			case 'Frame'
				switch meshType
					case 'Truss2D'
						loadingCond_ = fscanf(fid, '%d %e %e', [3, numLoadedNodes])';
					case 'Truss3D'
						loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])';
					case 'Beam2D'
						loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])'; 						
					case 'Beam3D'
						loadingCond_ = fscanf(fid, '%d %e %e %e %e %e %e', [7, numLoadedNodes])';
				end
		end		
	else 
		loadingCond_ = []; 
	end

	startReadingFixations = fscanf(fid, '%s %s', 2);
    if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
	numFixedNodes = fscanf(fid, '%d', 1);
	if numFixedNodes>0
		switch geoType
			case 'Plane'
				fixingCond_ = fscanf(fid, '%d %d %d', [3, numFixedNodes])'; 
			case 'Solid'
				fixingCond_ = fscanf(fid, '%d %d %d %d', [4, numFixedNodes])';
			case 'Shell'
				fixingCond_ = fscanf(fid, '%d %d %d %d %d %d %d', [7, numFixedNodes])';
			case 'Frame'
				switch meshType
					case 'Truss2D'
						fixingCond_ = fscanf(fid, '%d %d %d', [3, numFixedNodes])'; 
					case 'Truss3D'
						fixingCond_ = fscanf(fid, '%d %d %d %d', [4, numFixedNodes])';						
					case 'Beam2D'
						fixingCond_ = fscanf(fid, '%d %d %d %d', [4, numFixedNodes])';						
					case 'Beam3D'
						fixingCond_ = fscanf(fid, '%d %d %d %d %d %d %d', [7, numFixedNodes])';
				end			
			
		end	
	else
		fixingCond_ = []; 
	end
	fclose(fid);

	%%4. Initialize Additional Mesh Info	
	switch geoType
		case 'Plane'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromPlaneMesh();
		case 'Solid'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromSolidMesh();
		case 'Shell'
			boundaryFaceNodMat_ = eNodMat_;
			nodState_ = ones(numNodes_,1);
			boundaryNodes_ = (1:numNodes_)';
	end	
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		numNodsAroundEleVec_(iEleNodes,1) = numNodsAroundEleVec_(iEleNodes,1) + 1;
	end
	switch meshType
		case 'Quad'
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5  2 6  3 7  4 8]);
		case 'Tri'
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 4  2 5  3 6]);
		case 'Hex'
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);			
		case 'Tet'
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5 9  2 6 10  3 7 11  4 8 12]);	 
		case 'Truss2D'
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 2 4]);
		case 'Truss3D'
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 5 2 4 6]);		
		case 'Beam2D'
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 5 2 4 6]);				
		case 'Beam3D'
			tmp = 6*eNodMat_; eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 5 7 9 11 2 4 6 8 10 12]);		
	end
	
	if strcmp(geoType, 'Frame')
		eleLengthList_ = vecnorm(nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,1),:),2,2);
		if strcmp(meshType, 'Truss3D') || strcmp(meshType, 'Beam3D')
			eleCrossSecAreaList_ = pi/2 * (diameterList_/2).^2;
			iSphereVolume = 4/3*pi*(sum(diameterList_)/numEles_/2)^3/2;
			frameVolume = pi/4 * (eleLengthList_(:)' * diameterList_.^2) - (sum(numNodsAroundEleVec_)-numNodes_)*iSphereVolume;
			disp(['Frame Volume: ', sprintf('%.6f', frameVolume)]);
		else
			
		end
	end
	
	EvaluateMeshQuality();
end