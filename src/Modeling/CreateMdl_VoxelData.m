function CreateMdl_VoxelData(fileName, varargin)
	%% CreateFromWrappedVoxelFEAmodel(fileName); 
	%% CreateFromWrappedVoxelFEAmodel(fileName, sizeScaling); 
	global eleType_;
	global nelx_; global nely_; global nelz_; global boundingBox_;
	global numEles_;
	global fixingCond_; global loadingCond_;
	global carNodMapForward_;
	global materialIndicatorField_;

	fid = fopen(fileName, 'r');
	tmp = fscanf(fid, '%s %s', 2);
	domainType = fscanf(fid, '%s', 1);
	switch domainType
		case '2D'
			SetElement('Plane144');
			tmp = fscanf(fid, '%s', 1);
			tmp = fscanf(fid, '%d %d', 3);
			nelx_ = tmp(1); nely_ = tmp(2);
			if 1==nargin
				boundingBox_ = [0 0; nelx_ nely_];
			else
				boundingBox_ = [0 0; varargin{1}*[nelx_ nely_]/max([nelx_ nely_])];
			end
			tmp = fscanf(fid, '%s %s', 2);
			numEles = fscanf(fid, '%d', 1);
			eleList = fscanf(fid, '%d', [1 numEles])';
			tmp = fscanf(fid, '%s %s', 2);
			numFixedNodes = fscanf(fid, '%d', 1);
			if numFixedNodes>0
				fixingCond_ = fscanf(fid, '%d %d %d', [3 numFixedNodes])';
			end
			tmp = fscanf(fid, '%s %s', 2);
			numLoadedNodes = fscanf(fid, '%d', 1);	
			if numLoadedNodes>0
				loadingCond_ = fscanf(fid, '%d %e %e', [3 numLoadedNodes])';
			end
			allEles = zeros(nelx_*nely_,1); allEles(eleList) = 1;
			GenerateCartesianMesh2D(reshape(allEles, nely_, nelx_));
			if numFixedNodes>0
				fixingCond_(:,1) = carNodMapForward_(fixingCond_(:,1));
			end
			if numLoadedNodes>0
				loadingCond_(:,1) = carNodMapForward_(loadingCond_(:,1));
			end		
		case '3D'
			SetElement('Solid188');
			tmp = fscanf(fid, '%s', 1);
			tmp = fscanf(fid, '%d %d %d', 3);
			nelx_ = tmp(1); nely_ = tmp(2); nelz_ = tmp(3);
			if 1==nargin
				boundingBox_ = [0 0 0; nelx_ nely_ nelz_];
			else
				boundingBox_ = [0 0 0; varargin{1}*[nelx_ nely_ nelz_]/max([nelx_ nely_ nelz_])];
			end
			tmp = fscanf(fid, '%s %s', 2);
			numEles = fscanf(fid, '%d', 1);
			eleList = fscanf(fid, '%d', [1 numEles])';
			tmp = fscanf(fid, '%s %s', 2);
			numFixedNodes = fscanf(fid, '%d', 1);
			if numFixedNodes>0
				fixingCond_ = fscanf(fid, '%d %d %d %d', [4 numFixedNodes])';
			end
			tmp = fscanf(fid, '%s %s', 2);
			numLoadedNodes = fscanf(fid, '%d', 1);	
			if numLoadedNodes>0
				loadingCond_ = fscanf(fid, '%d %e %e %e', [4 numLoadedNodes])';
			end
			allEles = zeros(nelx_*nely_*nelz_,1); allEles(eleList) = 1;
			GenerateCartesianMesh3D(reshape(allEles, nely_, nelx_, nelz_));
			if numFixedNodes>0
				fixingCond_(:,1) = carNodMapForward_(fixingCond_(:,1));
			end			
			if numLoadedNodes>0
				loadingCond_(:,1) = carNodMapForward_(loadingCond_(:,1));
			end									
	end
	fclose(fid);
	materialIndicatorField_ = ones(numEles_,1);
	EvaluateMeshQuality();
end