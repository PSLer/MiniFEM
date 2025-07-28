function CreateMdl_ExclusiveFormat(fileName)
	global boundingBox_;
	global eleType_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global diameterList_;
	global eleCrossSecAreaList_;
	global eleLengthList_;	
	global materialIndicatorField_;
	global shellThicknessList_;
	global boundaryNodes_;
	global boundaryFaceNodMat_;
	global numNodsAroundEleVec_;
	global nodState_; global eleState_;
	global fixingCond_;
	global loadingCond_;
	
	%%1. read file header
	fid = fopen(fileName, 'r');
	fgetl(fid);
	domainType = fscanf(fid, '%s', 1);
	meshType = fscanf(fid, '%s', 1);
	meshOrder = fscanf(fid, '%d', 1);
	
	if 1~=meshOrder, error('Un-supported Mesh!'); end
	startReadingVertices = fscanf(fid, '%s', 1);	
	if ~strcmp(startReadingVertices, 'Vertices:'), error('Un-supported Data!'); end
	%%2. read node coordinates
	numNodes_ = fscanf(fid, '%d', 1);	
	switch domainType
		case 'Plane'
			nodeCoords_ = fscanf(fid, '%e %e', [2, numNodes_])';
			numDOFs_ = 2*numNodes_;
			%%3. read element
			startReadingElements = fscanf(fid, '%s', 1);
			if ~strcmp(startReadingElements, 'Elements:'), error('Un-supported Data!'); end
			numEles_ = fscanf(fid, '%d', 1);
			switch meshType
				case 'Tri'
					switch meshOrder
						case 1							
							SetElement('Plane133');
							meshInfo = fscanf(fid, '%d %d %d %d', [4, numEles_])';
							eNodMat_ = meshInfo(:,1:end-1);
							materialIndicatorField_ = meshInfo(:,end);								
						otherwise
							error('Un-supported Mesh!');
					end
				case 'Quad'
					switch meshOrder
						case 1
							SetElement('Plane144');
							meshInfo = fscanf(fid, '%d %d %d %d %d', [5, numEles_])'; 
							eNodMat_ = meshInfo(:,1:end-1);
							materialIndicatorField_ = meshInfo(:,end);							
						otherwise
							error('Un-supported Mesh!');
					end				
				otherwise
					error('Un-supported Mesh!');
			end

			%%4. Read boundary condition
			startReadingLoads = fscanf(fid, '%s %s', 2); 
			if ~strcmp(startReadingLoads, 'NodeForces:'), error('Un-supported Data!'); end
			numLoadedNodes = fscanf(fid, '%d', 1);
			if numLoadedNodes>0	
				loadingCond_ = fscanf(fid, '%d %e %e', [3, numLoadedNodes])'; 
			else
				loadingCond_ = []; 
			end
			startReadingFixations = fscanf(fid, '%s %s', 2);
			if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
			numFixedNodes = fscanf(fid, '%d', 1);
			if numFixedNodes
				fixingCond_ = fscanf(fid, '%d %d %d', [3, numFixedNodes])'; 
			else
				fixingCond_ = [];
			end
		case 'Solid'
			nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';	
			numDOFs_ = 3*numNodes_;
			%%3. read element
			startReadingElements = fscanf(fid, '%s', 1);
			if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
			numEles_ = fscanf(fid, '%d', 1);
			switch meshType
				case 'Tet'
					switch meshOrder
						case 1							
							SetElement('Solid144');
							meshInfo = fscanf(fid, '%d %d %d %d %d', [5, numEles_])';
							eNodMat_ = meshInfo(:,1:end-1);
							materialIndicatorField_ = meshInfo(:,end);							
						otherwise
							error('Un-supported Mesh!');
					end
				case 'Hex'
					switch meshOrder
						case 1
							SetElement('Solid188');
							meshInfo = fscanf(fid, '%d %d %d %d %d %d %d %d %d', [9, numEles_])';
							eNodMat_ = meshInfo(:,1:end-1);
							materialIndicatorField_ = meshInfo(:,end);									
						otherwise
							error('Un-supported Mesh!');
					end				
				otherwise
					error('Un-supported Mesh!');
			end

			%%4. Read boundary condition
			startReadingLoads = fscanf(fid, '%s %s', 2); 
			if ~strcmp(startReadingLoads, 'NodeForces:'), error('Un-supported Data!'); end
			numLoadedNodes = fscanf(fid, '%d', 1);
			if numLoadedNodes>0	
				loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])';
			else
				loadingCond_ = []; 
			end
			startReadingFixations = fscanf(fid, '%s %s', 2);
			if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
			numFixedNodes = fscanf(fid, '%d', 1);
			if numFixedNodes
				fixingCond_ = fscanf(fid, '%d %d %d %d', [4, numFixedNodes])';
			else
				fixingCond_ = [];
			end			
		case 'Shell'
			nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';
			numDOFs_ = 6*numNodes_;
			%%3. read element
			startReadingElements = fscanf(fid, '%s', 1);
			if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
			numEles_ = fscanf(fid, '%d', 1);
			switch meshType
				case 'Tri'
					switch meshOrder
						case 1
							SetElement('Shell133');
							meshInfo = fscanf(fid, '%d %d %d %d %e', [5, numEles_])';
							eNodMat_ = meshInfo(:,1:end-2);
							materialIndicatorField_ = meshInfo(:,end-1);
							shellThicknessList_ = meshInfo(:,end);
						otherwise
							error('Un-supported Mesh!');
					end
				case 'Quad'
					switch meshOrder
						case 1
							SetElement('Shell144');
							meshInfo = fscanf(fid, '%d %d %d %d %d %e', [6, numEles_])'; 
							eNodMat_ = meshInfo(:,1:end-2);
							materialIndicatorField_ = meshInfo(:,end-1);
							shellThicknessList_ = meshInfo(:,end);							
						otherwise
							error('Un-supported Mesh!');
					end				
				otherwise
					error('Un-supported Mesh!');
			end

			%%4. Read boundary condition
			startReadingLoads = fscanf(fid, '%s %s', 2); 
			if ~strcmp(startReadingLoads, 'NodeForces:'), error('Un-supported Data!'); end
			numLoadedNodes = fscanf(fid, '%d', 1);
			if numLoadedNodes>0	
				loadingCond_ = fscanf(fid, '%d %e %e %e %e %e %e', [7, numLoadedNodes])';
			else
				loadingCond_ = []; 
			end
			startReadingFixations = fscanf(fid, '%s %s', 2);
			if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
			numFixedNodes = fscanf(fid, '%d', 1);
			if numFixedNodes
				fixingCond_ = fscanf(fid, '%d %d %d %d %d %d %d', [7, numFixedNodes])';
			else
				fixingCond_ = [];
			end			
		case 'Frame3D'
			nodeCoords_ = fscanf(fid, '%e %e %e', [3, numNodes_])';			
			%%3. read element
			startReadingElements = fscanf(fid, '%s', 1);
			if ~strcmp(startReadingElements, 'Elements:'), warning('Un-supported Data!'); return; end
			numEles_ = fscanf(fid, '%d', 1);			
			switch meshType
				case 'Truss'
					numDOFs_ = 3*numNodes_;
					switch meshOrder
						case 1
							SetElement('Truss123');
							meshInfo = fscanf(fid, '%d %d %e %d', [4, numEles_])';
							eNodMat_ = meshInfo(:,1:2);
							diameterList_ = meshInfo(:,3);
							materialIndicatorField_ = meshInfo(:,end);  							
						otherwise
							error('Un-supported Mesh!');
					end
					startReadingBoundaryNodes = fscanf(fid, '%s %s', 2);
					numNodesAgain = fscanf(fid, '%d', 1);
					nodState_ = fscanf(fid, '%d', [1 numNodesAgain]); nodState_ = nodState_(:);
					boundaryNodes_ = find(nodState_);
		
					%%4. Read boundary condition
					startReadingLoads = fscanf(fid, '%s %s', 2); 
					if ~strcmp(startReadingLoads, 'NodeForces:'), error('Un-supported Data!'); end
					numLoadedNodes = fscanf(fid, '%d', 1);
					if numLoadedNodes>0	
						loadingCond_ = fscanf(fid, '%d %e %e %e', [4, numLoadedNodes])';
					else
						loadingCond_ = []; 
					end
					startReadingFixations = fscanf(fid, '%s %s', 2);
					if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
					numFixedNodes = fscanf(fid, '%d', 1);
					if numFixedNodes
						fixingCond_ = fscanf(fid, '%d %d %d %d', [4, numFixedNodes])';
					else
						fixingCond_ = [];
					end					
				case 'Beam'
					numDOFs_ = 6*numNodes_;
					switch meshOrder
						case 1
							SetElement('Beam123');
							meshInfo = fscanf(fid, '%d %d %e %d', [4, numEles_])';
							eNodMat_ = meshInfo(:,1:2);
							diameterList_ = meshInfo(:,3);
							materialIndicatorField_ = meshInfo(:,end);							
						otherwise
							error('Un-supported Mesh!');
					end
					startReadingBoundaryNodes = fscanf(fid, '%s %s', 2);
					numNodesAgain = fscanf(fid, '%d', 1);
					nodState_ = fscanf(fid, '%d', [1 numNodesAgain]); nodState_ = nodState_(:);
					boundaryNodes_ = find(nodState_);
					
					%%4. Read boundary condition
					startReadingLoads = fscanf(fid, '%s %s', 2); 
					if ~strcmp(startReadingLoads, 'NodeForces:'), error('Un-supported Data!'); end
					numLoadedNodes = fscanf(fid, '%d', 1);
					if numLoadedNodes>0	
						loadingCond_ = fscanf(fid, '%d %e %e %e %e %e %e', [7, numLoadedNodes])';
					else
						loadingCond_ = []; 
					end
					startReadingFixations = fscanf(fid, '%s %s', 2);
					if ~strcmp(startReadingFixations, 'FixedNodes:'), warning('Un-supported Data!'); return; end
					numFixedNodes = fscanf(fid, '%d', 1);
					if numFixedNodes
						fixingCond_ = fscanf(fid, '%d %d %d %d %d %d %d', [7, numFixedNodes])';
					else
						fixingCond_ = [];
					end						
				otherwise
					error('Un-supported Mesh!');
			end			
		case 'Frame2D'
			error('Un-supported Domain!');
	end
	fclose(fid);
	
	%%4. Initialize Additional Mesh Info
	boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	numNodsAroundEleVec_ = zeros(numNodes_,1);
	switch eleType_.eleName
		case 'Plane133'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromPlaneMesh();
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 4  2 5  3 6]);
			EvaluateMeshQuality();
		case 'Plane144'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromPlaneMesh();
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 2*eNodMat_; eDofMat_ = [tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5  2 6  3 7  4 8]);
			EvaluateMeshQuality();
		case 'Solid144'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromSolidMesh();
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5 9  2 6 10  3 7 11  4 8 12]);
			EvaluateMeshQuality();			
		case 'Solid188'
			[boundaryFaceNodMat_, nodState_, eleState_, boundaryNodes_] = ExtractBoundaryInfoFromSolidMesh();
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);
			EvaluateMeshQuality();
		case 'Shell133'
			boundaryFaceNodMat_ = eNodMat_;
			nodState_ = ones(numNodes_,1);
			boundaryNodes_ = (1:numNodes_)';
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 6*eNodMat_; eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 4 7 10 13 16  2 5 8 11 14 17  3 6 9 12 15 18]);
			EvaluateMeshQuality();
		case 'Shell144'
			boundaryFaceNodMat_ = eNodMat_;
			nodState_ = ones(numNodes_,1);
			boundaryNodes_ = (1:numNodes_)';
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 6*eNodMat_; eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 5 9 13 17 21  2 6 10 14 18 22  3 7 11 15 19 23  4 8 12 16 20 24]);
			EvaluateMeshQuality();
		case 'Beam123'
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 6*eNodMat_; eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 5 7 9 11 2 4 6 8 10 12]);		
			eleLengthList_ = vecnorm(nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,1),:),2,2);
			
			%%Volume Evaluation
			eleCrossSecAreaList_ = pi/2 * (diameterList_/2).^2;
			iSphereVolume = 4/3*pi*(sum(diameterList_)/numEles_/2)^3/2;
			frameVolume = pi/4 * (eleLengthList_(:)' * diameterList_.^2) - (sum(numNodsAroundEleVec_)-numNodes_)*iSphereVolume;
			%%disp(['Frame Volume: ', sprintf('%.6f', frameVolume)]);			
		case 'Truss123'
			for ii=1:numEles_
				iNodes = eNodMat_(ii,:);
				numNodsAroundEleVec_(iNodes,1) = numNodsAroundEleVec_(iNodes,1) + 1;
			end
			tmp = 3*eNodMat_; eDofMat_ = [tmp-2 tmp-1 tmp];
			eDofMat_ = eDofMat_(:,[1 3 5 2 4 6]);
			eleLengthList_ = vecnorm(nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,1),:),2,2);
			
			%%Volume Evaluation
			eleCrossSecAreaList_ = pi/2 * (diameterList_/2).^2;
			iSphereVolume = 4/3*pi*(sum(diameterList_)/numEles_/2)^3/2;
			frameVolume = pi/4 * (eleLengthList_(:)' * diameterList_.^2) - (sum(numNodsAroundEleVec_)-numNodes_)*iSphereVolume;
			%%disp(['Frame Volume: ', sprintf('%.6f', frameVolume)]);			
	end
end