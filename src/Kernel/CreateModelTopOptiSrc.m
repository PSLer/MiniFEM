function CreateModelTopOptiSrc(srcName, extractThreshold, featureSize)	
	global domainType_;
	global vtxLowerBound_; global vtxUpperBound_;
	global nelx_; global nely_; global nelz_;
	global fixingCond_;
	global loadingCond_;
	global nodeMap4CutBasedModel_;
	global opt_CUTTING_DESIGN_DOMAIN_;
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
			fixingCond_ = fscanf(fid, '%d', [1 numFixedNodes])';
			tmp = fscanf(fid, '%s %s', 2);
			numLoadedNodes = fscanf(fid, '%d', 1);	
			loadingCond_ = fscanf(fid, '%d %e %e', [3 numLoadedNodes])';			
			vtxLowerBound_ = [0 0];
			if isempty(featureSize), featureSize = max([nelx_ nely_]); end
			vtxUpperBound_ = featureSize*[nelx_ nely_]/max([nelx_ nely_]);
		case '3D'
			tmp = fscanf(fid, '%d %d %d', 3);
			nelx_ = tmp(1); nely_ = tmp(2); nelz_ = tmp(3);		
			tmp = fscanf(fid, '%s %s %s', 3);
			numEleDD = fscanf(fid, '%d', 1);
			eleList = fscanf(fid, '%d %f', [2 numEleDD])';
			tmp = fscanf(fid, '%s %s', 2);
			numFixedNodes = fscanf(fid, '%d', 1);
			fixingCond_ = fscanf(fid, '%d', [1 numFixedNodes])';
			tmp = fscanf(fid, '%s %s', 2);
			numLoadedNodes = fscanf(fid, '%d', 1);	
			loadingCond_ = fscanf(fid, '%d %e %e %e', [4 numLoadedNodes])';
			vtxLowerBound_ = [0 0 0];
			if isempty(featureSize), featureSize = max([nelx_ nely_ nelz_]); end
			vtxUpperBound_ = featureSize*[nelx_ nely_ nelz_]/max([nelx_ nely_ nelz_]);
% vtxLowerBound_ = [-0.996787000000000	-0.764997000000000	-0.986229000000000];
% vtxUpperBound_ = [0.998007000000000	0.769461000000000	0.976411000000000];		%%for vis2021_bunny2	
	end
	fclose(fid);
	opt_CUTTING_DESIGN_DOMAIN_ = 'ON';
	DiscretizeDesignDomain();
	validElements = eleList(find(eleList(:,2)>=extractThreshold),1);
	CuttingDesignDomain(validElements);
	%% update
	loadingCond_(:,1) = nodeMap4CutBasedModel_(loadingCond_(:,1));
	fixingCond_ = nodeMap4CutBasedModel_(fixingCond_);
	fixingCond_(0==fixingCond_) = [];
end
