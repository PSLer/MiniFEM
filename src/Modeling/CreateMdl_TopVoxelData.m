function CreateMdl_TopVoxelData(fileName, extractThreshold, varargin)
	%% CreateMdl_TopVoxelData(fileName, extractThreshold); 
	%% CreateMdl_TopVoxelData(fileName, extractThreshold, sizeScaling); 
	global eleType_;
	global nelx_; global nely_; global nelz_; global boundingBox_;
	global fixingCond_; global loadingCond_;
	global carNodMapBack_;
	global carNodMapForward_;
	global numEles_;
    global materialIndicatorField_;

	
	
	SetElement('Solid188');
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	fid = fopen(fileName, 'r');
	fileHead = fscanf(fid, '%s %s %s %s', 4);
	versionHead = fscanf(fid, '%s', 1);
	versionID = fscanf(fid, '%f', 1);
	switch versionID
		case 1.0
			if ~strcmp(fscanf(fid, '%s', 1), 'Resolution:'), error('Incompatible Mesh Data Format!'); end
			resolutions = fscanf(fid, '%d %d %d', 3);
			nelx_ = resolutions(1); nely_ = resolutions(2); nelz_ = resolutions(3);
			densityValuesCheck = fscanf(fid, '%s %s', 2);
			checkDensityValuesIncluded = fscanf(fid, '%d', 1);
			startReadSolidVoxels = fscanf(fid, '%s %s', 2);
			numEles = fscanf(fid, '%d', 1);
			if checkDensityValuesIncluded
				eleList = fscanf(fid, '%d %e', [2 numEles])';
				solidVoxels = eleList(:,1);
				densityLayout = eleList(:,2);
			else
				solidVoxels = fscanf(fid, '%d', [1 numEles])';
				densityLayout = ones(size(solidVoxels));
			end
			if ~strcmp(fscanf(fid, '%s', 1), 'Passive'), error('Incompatible Mesh Data Format!'); end
			if ~strcmp(fscanf(fid, '%s', 1), 'elements:'), error('Incompatible Mesh Data Format!'); end
			numPassiveElements = fscanf(fid, '%d', 1);
			passiveElements = fscanf(fid, '%d', [1 numPassiveElements])';
			if ~strcmp(fscanf(fid, '%s', 1), 'Fixations:'), error('Incompatible Mesh Data Format!'); end
			numFixedNodes = fscanf(fid, '%d', 1);
			if numFixedNodes>0		
				fixingCond_ = fscanf(fid, '%d %d %d %d', [4 numFixedNodes])';		
			end
			if ~strcmp(fscanf(fid, '%s', 1), 'Loads:'), error('Incompatible Mesh Data Format!'); end
			numLoadedNodes = fscanf(fid, '%d', 1);	
			if numLoadedNodes>0
				loadingCond_ = fscanf(fid, '%d %e %e %e', [4 numLoadedNodes])';								
			end
			
		otherwise
			warning('Unsupported Data!'); fclose(fid); return;
	end
	fclose(fid);
	
	if 2==nargin
		boundingBox_ = [0 0 0; nelx_ nely_ nelz_];
	else
		boundingBox_ = [0 0 0; varargin{1}*[nelx_ nely_ nelz_]/max([nelx_ nely_ nelz_])];
	end	
	allEles = zeros(nelx_*nely_*nelz_,1); 
	qualifiedEles = solidVoxels(find(densityLayout>=extractThreshold),1);
	allEles(qualifiedEles) = 1;
	GenerateCartesianMesh3D(reshape(allEles, nely_, nelx_, nelz_));
	rawFixingPos = fixingCond_(:,1);
	[~, realFixingPos] = intersect(rawFixingPos, carNodMapBack_);
	fixingCond_ = fixingCond_(realFixingPos,:);
	fixingCond_(:,1) = carNodMapForward_(fixingCond_(:,1));
	loadingCond_(:,1) = carNodMapForward_(loadingCond_(:,1));
	materialIndicatorField_ = ones(numEles_,1);
	EvaluateMeshQuality();	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% fid = fopen(fileName, 'r');
	% fgetl(fid);
	% tmp = fscanf(fid, '%s %s', 2);
	% domainType = fscanf(fid, '%s', 1);
	% %if ~strcmp(eleType_.eleName, 'Solid188'), error('Unmatched Mesh and Data Set! Please Use Solid188 Element'); end
	% SetElement('Solid188');
	% tmp = fscanf(fid, '%s', 1);
	% tmp = fscanf(fid, '%d %d %d', 3);
	% nelx_ = tmp(1); nely_ = tmp(2); nelz_ = tmp(3);
	% if 2==nargin
		% boundingBox_ = [0 0 0; nelx_ nely_ nelz_];
	% else
		% boundingBox_ = [0 0 0; varargin{1}*[nelx_ nely_ nelz_]/max([nelx_ nely_ nelz_])];
	% end
	% tmp = fscanf(fid, '%s %s %s', 3);
	% numEles = fscanf(fid, '%d', 1);
	% eleList = fscanf(fid, '%d %f', [2 numEles])';
	% tmp = fscanf(fid, '%s %s', 2);
	% numFixedNodes = fscanf(fid, '%d', 1);
	% fixingCond_ = fscanf(fid, '%d %d %d %d', [4 numFixedNodes])';
	% tmp = fscanf(fid, '%s %s', 2);
	% numLoadedNodes = fscanf(fid, '%d', 1);	
	% loadingCond_ = fscanf(fid, '%d %e %e %e', [4 numLoadedNodes])';
	
	% allEles = zeros(nelx_*nely_*nelz_,1); 
	% qualifiedEles = eleList(find(eleList(:,2)>=extractThreshold),1);
	% allEles(qualifiedEles) = 1;
	% GenerateCartesianMesh3D(reshape(allEles, nely_, nelx_, nelz_));
	% rawFixingPos = fixingCond_(:,1);
	% [~, realFixingPos] = intersect(rawFixingPos, carNodMapBack_);
	% fixingCond_ = fixingCond_(realFixingPos,:);
	% fixingCond_(:,1) = carNodMapForward_(fixingCond_(:,1));
	% loadingCond_(:,1) = carNodMapForward_(loadingCond_(:,1));
	% fclose(fid);
	% materialIndicatorField_ = ones(numEles_,1);
	% EvaluateMeshQuality();
end