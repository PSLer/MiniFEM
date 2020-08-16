function CreateModelTopOptiSrc(srcName, extractThreshold, featureSize)	
	global domainType_;
	global vtxLowerBound_; global vtxUpperBound_;
	global nelx_; global nely_; global nelz_;
	global boundaryCond_;
	global loadingCond_;
	
	fid = fopen(srcName, 'r');
	fgetl(fid);
	tmp = fscanf(fid, '%s %s', 2);
	tmp = fscanf(fid, '%s', 1);
	if ~strcmp(tmp, domainType_), error('Wrong domain type!'); end
	tmp = fscanf(fid, '%s', 1);
	switch domainType_
		case '2D'
			tmp = fscanf(fid, '%d %d', 3);
			nelx_ = tmp(1); nely_ = tmp(2);
			tmp = fscanf(fid, '%s %s %s', 3);
			numEleDD = fscanf(fid, '%d', 1);
			eleList = fscanf(fid, '%d %f', [2 numEleDD])';
			tmp = fscanf(fid, '%s %s', 2);
			numFixedNodes = fscanf(fid, '%d', 1);
			boundaryCond_ = fscanf(fid, '%d', [1 numFixedNodes])';
			tmp = fscanf(fid, '%s %s', 2);
			numLoadedNodes = fscanf(fid, '%d', 1);	
			loadingCond_ = fscanf(fid, '%d %e %e', [3 numLoadedNodes])';			
			vtxLowerBound_ = [0 0];
			vtxUpperBound_ = featureSize*[nelx_ nely_]/max([nelx_ nely_]);
		case '3D'
			tmp = fscanf(fid, '%d %d %d', 3);
			nelx_ = tmp(1); nely_ = tmp(2); nelz_ = tmp(3);		
			tmp = fscanf(fid, '%s %s %s', 3);
			numEleDD = fscanf(fid, '%d', 1);
			eleList = fscanf(fid, '%d %f', [2 numEleDD])';
			tmp = fscanf(fid, '%s %s', 2);
			numFixedNodes = fscanf(fid, '%d', 1);
			boundaryCond_ = fscanf(fid, '%d', [1 numFixedNodes])';
			tmp = fscanf(fid, '%s %s', 2);
			numLoadedNodes = fscanf(fid, '%d', 1);	
			loadingCond_ = fscanf(fid, '%d %e %e %e', [4 numLoadedNodes])';
			vtxLowerBound_ = [0 0 0];
			vtxUpperBound_ = featureSize*[nelx_ nely_ nelz_]/max([nelx_ nely_ nelz_]);				
	end
	fclose(fid);
	DiscretizeDesignDomain();
	validElements = eleList(find(eleList(:,2)>=extractThreshold),1);
	CuttingDesignDomain(validElements); 
end
