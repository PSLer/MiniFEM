function ConvertSolid2Frame(framType, varargin)
	global eleType_;
	global outPath_;
	global boundingBox_;
	global numEles_; global eNodMat_; global eDofMat_; 
	global numNodes_; global numDOFs_; global nodeCoords_;
	global boundaryNodes_;
	global numNodsAroundEleVec_;
	global nodState_;
	global fixingCond_;
	global loadingCond_;
	global diameterList_;
	global eleCrossSecAreaList_;
	global eleLengthList_;
	
	
	if ~(strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144') || strcmp(eleType_.eleName, 'Solid144') || ...
			strcmp(eleType_.eleName, 'Solid188') || strcmp(eleType_.eleName, 'Shell133')  || strcmp(eleType_.eleName, 'Shell144'))
		warning('No need for conversion!'); return; 
	end

	%% Convert
	[eNodMat_frame, nodState_frame, ~, nodeForces, nodeFixations] = ConductConversion(framType);
	numNodes_frame = numNodes_;
	nodeCoords_frame = nodeCoords_;
	numEles_frame = size(eNodMat_frame,1);
	materialIndicatorField_frame = ones(numEles_frame,1);
	if 1==nargin
		scalingEdgeThickness = 200;
	else
		scalingEdgeThickness = varargin{1};
	end
	refDiameter = max(boundingBox_(2,:) - boundingBox_(1,:))/scalingEdgeThickness;
	diameterList_ = repmat(refDiameter, size(eNodMat_frame,1), 1);
	% eleLengthList_ = vecnorm(nodeCoords_frame(eNodMat_frame(:,2),:)-nodeCoords_frame(eNodMat_frame(:,1),:),2,2);
	% iSphereVolume = 4/3*pi*(sum(diameterList_)/numEles_/2)^3/2; 
	% %iSphereVolume = 0;
	% frameVolume = pi/4 * (eleLengthList_(:)' * diameterList_.^2) - (sum(numNodsAroundEleVec_)-numNodes_)*iSphereVolume;
	% disp(['Frame Volume: ', sprintf('%.6f', frameVolume)]);

	%%Vis.
	figure;
	[gridX, gridY, gridZ, gridC] = Extend3DMeshEdges2Tubes(nodeCoords_frame, eNodMat_frame, diameterList_);
	hd = surf(gridX, gridY, gridZ, gridC);
	axis('equal'); axis('tight'); axis('on');
	set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
	xlabel('X'); ylabel('Y'); zlabel('Z');
	view(3); 
	camproj('perspective');
	lighting('gouraud');
	material('dull'); %%shiny; dull; metal	
	camlight('headlight','infinite');
	
	%%Write
	switch framType
		case 'Beam'
			if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
				tmpEleType = 'Beam122';
			else
				tmpEleType = 'Beam123';
			end
		case 'Truss'
			if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
				tmpEleType = 'Truss122';
			else
				tmpEleType = 'Truss123';
			end		
	end	
	fileName = strcat(outPath_, 'Data4MiniFEM.MiniFEM');
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'Version');
	fprintf(fid, '%.1f\n', 2.0);
	if strcmp(tmpEleType, 'Truss122') || strcmp(tmpEleType, 'Beam122')
		if strcmp(tmpEleType, 'Truss122')
			fprintf(fid, '%s %s ', 'Frame Truss2D');
		else
			fprintf(fid, '%s %s ', 'Frame Beam2D');
		end
		fprintf(fid, '%d\n', 1);
		
		fprintf(fid, '%s ', 'Vertices:');
		fprintf(fid, '%d\n', numNodes_frame);		
		fprintf(fid, '%.6e %.6e\n', nodeCoords_frame');			
	else
		if strcmp(tmpEleType, 'Truss123')
			fprintf(fid, '%s %s ', 'Frame Truss3D');
		else
			fprintf(fid, '%s %s ', 'Frame Beam3D');
		end
		fprintf(fid, '%d\n', 1);
		
		fprintf(fid, '%s ', 'Vertices:');
		fprintf(fid, '%d\n', numNodes_frame);		
		fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_frame');		
	end
	fprintf(fid, '%s ', 'Elements:');
	fprintf(fid, '%d \n', numEles_frame);
	fprintf(fid, '%d %d %.6e %d\n', [double(eNodMat_frame) diameterList_ materialIndicatorField_frame]');	

	fprintf(fid, '%s %s ', 'Node State: ');
	fprintf(fid, '%d\n', numel(nodState_frame));
	fprintf(fid, '%d\n', nodState_frame);

	fprintf(fid, '%s %s ', 'Node Forces:'); 
	fprintf(fid, '%d\n', size(nodeForces,1));
	if ~isempty(nodeForces)
		switch tmpEleType
			case 'Truss122'
				fprintf(fid, '%d %.6e %.6e\n', nodeForces');
			case 'Truss123'
				fprintf(fid, '%d %.6e %.6e %.6e\n', nodeForces');
			case 'Beam122'
				fprintf(fid, '%d %.6e %.6e %.6e\n', nodeForces');
			case 'Beam123'
				fprintf(fid, '%d %.6e %.6e %.6e %.6e %.6e %.6e\n', nodeForces');
		end	
	end

	fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
	fprintf(fid, '%d\n', size(nodeFixations,1));
	if ~isempty(nodeFixations)
		switch tmpEleType
			case 'Truss122'
				fprintf(fid, '%d %d %d\n', nodeFixations');
			case 'Truss123'
				fprintf(fid, '%d %d %d %d\n', nodeFixations');
			case 'Beam122'
				fprintf(fid, '%d %d %d %d\n', nodeFixations');
			case 'Beam123'
				fprintf(fid, '%d %d %d %d %d %d %d\n', nodeFixations');
		end	
	end		
	fclose(fid);
end

function [edgeNodMat, nodState, boundaryNodes, nodeForces, nodeFixations] = ConductConversion(framType)
	global eleType_;
	global numNodes_;
	global numEles_;
	global eNodMat_;
	global fixingCond_;
	global loadingCond_;	
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
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
		edgeNodMat = uniqueEdges;		
	elseif strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		switch eleType_.eleName
			case 'Solid144'
				numNodesPerFace = 3;
				numFacesPerEle = 4;
				numEdgesPerEle = 6;
				patchIndices = eNodMat_(:, [3 2 1  1 2 4  2 3 4  3 1 4])';
				edgeIndices = eNodMat_(:, [1 2  2 3  3 1  1 4  2 4  3 4])';	
			case 'Solid188'
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
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
		
	end
	
	switch eleType_.eleName
		case 'Plane133'
			if strcmp(framType, 'Beam')
				nodeForces = [loadingCond_ zeros(size(loadingCond_,1), 1)];
				nodeFixations = [fixingCond_ ones(size(fixingCond_,1), 1)];
			end
		case 'Plane144'
			if strcmp(framType, 'Beam')
				nodeForces = [loadingCond_ zeros(size(loadingCond_,1), 1)];
				nodeFixations = [fixingCond_ ones(size(fixingCond_,1), 1)];
			end		
		case 'Solid144'
			if strcmp(framType, 'Beam')
				nodeForces = [loadingCond_ zeros(size(loadingCond_,1), 3)];
				nodeFixations = [fixingCond_ ones(size(fixingCond_,1), 3)];
			end	
		case 'Solid188'
			if strcmp(framType, 'Beam')
				nodeForces = [loadingCond_ zeros(size(loadingCond_,1), 3)];
				nodeFixations = [fixingCond_ ones(size(fixingCond_,1), 3)];
			end	
		case 'Shell133'
			if strcmp(framType, 'Truss')
				nodeForces = loadingCond_(:,1:4);
				nodeFixations = fixingCond_(:,1:4);
			end
		case 'Shell144'
			if strcmp(framType, 'Truss')
				nodeForces = loadingCond_(:,1:4);
				nodeFixations = fixingCond_(:,1:4);
			end		
	end
end