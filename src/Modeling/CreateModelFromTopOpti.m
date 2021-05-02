function CreateModelFromTopOpti(fileName, extractThreshold, varargin)
	%% CreateModelFromTopOpti(fileName, extractThreshold); 
	%% CreateModelFromTopOpti(fileName, extractThreshold, sizeScaling); 
	global eleType_;
	global nelx_; global nely_; global nelz_; global boundingBox_;
	global fixingCond_; global loadingCond_;
	global carNodMapBack_;
	global carNodMapForward_;
	if ~(strcmp(eleType_.eleName, 'Plane144') || strcmp(eleType_.eleName, 'Solid188'))
		error('Only Works with 2D Plane144 or 3D Solid188 Element!');
	end
	fid = fopen(fileName, 'r');
	fgetl(fid);
	tmp = fscanf(fid, '%s %s', 2);
	domainType = fscanf(fid, '%s', 1);
	switch domainType
		case '2D'
			if ~strcmp(eleType_.eleName, 'Plane144'), error('Unmatched Mesh and Data Set! Please Use Plane144 Element'); end
			tmp = fscanf(fid, '%s', 1);
			tmp = fscanf(fid, '%d %d', 3);
			nelx_ = tmp(1); nely_ = tmp(2);
			if 2==nargin
				boundingBox_ = [0 0; nelx_ nely_];
			else
				boundingBox_ = [0 0; varargin{1}*[nelx_ nely_]/max([nelx_ nely_])];
			end
			tmp = fscanf(fid, '%s %s %s', 3);
			numEles = fscanf(fid, '%d', 1);
			eleList = fscanf(fid, '%d %f', [2 numEles])';
			tmp = fscanf(fid, '%s %s', 2);
			numFixedNodes = fscanf(fid, '%d', 1);
			fixingCond_ = fscanf(fid, '%d', [1 numFixedNodes])';
			tmp = fscanf(fid, '%s %s', 2);
			numLoadedNodes = fscanf(fid, '%d', 1);	
			loadingCond_ = fscanf(fid, '%d %e %e', [3 numLoadedNodes])';
			allEles = zeros(nelx_*nely_,1); 
			qualifiedEles = eleList(find(eleList(:,2)>=extractThreshold),1);
			allEles(qualifiedEles) = 1;
			GenerateCartesianMesh2D(reshape(allEles, nely_, nelx_));
			fixingCond_ = intersect(fixingCond_, carNodMapBack_);
			fixingCond_ = carNodMapForward_(fixingCond_);
			loadingCond_(:,1) = carNodMapForward_(loadingCond_(:,1));
		case '3D'
			if ~strcmp(eleType_.eleName, 'Solid188'), error('Unmatched Mesh and Data Set! Please Use Solid188 Element'); end
			tmp = fscanf(fid, '%s', 1);
			tmp = fscanf(fid, '%d %d %d', 3);
			nelx_ = tmp(1); nely_ = tmp(2); nelz_ = tmp(3);
			if 2==nargin
				boundingBox_ = [0 0 0; nelx_ nely_ nelz_];
			else
				boundingBox_ = [0 0 0; varargin{1}*[nelx_ nely_ nelz_]/max([nelx_ nely_ nelz_])];
			end
			tmp = fscanf(fid, '%s %s %s', 3);
			numEles = fscanf(fid, '%d', 1);
			eleList = fscanf(fid, '%d %f', [2 numEles])';
			tmp = fscanf(fid, '%s %s', 2);
			numFixedNodes = fscanf(fid, '%d', 1);
			fixingCond_ = fscanf(fid, '%d', [1 numFixedNodes])';
			tmp = fscanf(fid, '%s %s', 2);
			numLoadedNodes = fscanf(fid, '%d', 1);	
			loadingCond_ = fscanf(fid, '%d %e %e %e', [4 numLoadedNodes])';
			allEles = zeros(nelx_*nely_*nelz_,1); 
			qualifiedEles = eleList(find(eleList(:,2)>=extractThreshold),1);
			allEles(qualifiedEles) = 1;
			GenerateCartesianMesh3D(reshape(allEles, nely_, nelx_, nelz_));
			fixingCond_ = intersect(fixingCond_, carNodMapBack_);
			fixingCond_ = carNodMapForward_(fixingCond_);
			loadingCond_(:,1) = carNodMapForward_(loadingCond_(:,1));			
	end
	fclose(fid);
	EvaluateMeshQuality();
end