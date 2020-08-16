function DiscretizeDesignDomain()	
	global domainType_;
	global nelx_; global nely_; global nelz_; 
	global vtxLowerBound_; global vtxUpperBound_;
	global numEles_; global numNodes_; global numDOFs_; global eleType_; global eleSize_;
	global nodeCoords_; global edofMat_; global eNodMat_; 
	global numNod2ElesVec_; global nodesOutline_;
	global originalValidNodeIndex_; 
	global opt_CUTTING_DESIGN_DOMAIN_;
	
	switch domainType_
		case '2D'
			%    __ x
			%   / 
			%  -y         
			%		4--------3
			%	    |		 |		
			%		|		 |
			%		1--------2
			%	rectangular element
			numEles_ = nelx_*nely_;
			numNodes_ = (nelx_+1)*(nely_+1);
			eleSize_ = min((vtxUpperBound_(1)-vtxLowerBound_(1))/nelx_, ...
				(vtxUpperBound_(2)-vtxLowerBound_(2))/nely_);
			nodenrs = reshape(1:(1+nelx_)*(1+nely_),1+nely_,1+nelx_);
			edofVec = reshape(eleType_.numNodeDOFs*nodenrs(1:end-1,1:end-1)+1,nelx_*nely_,1);
			edofMat_ = repmat(edofVec,1, eleType_.numNode*eleType_.numNodeDOFs)+...
				repmat([0 1 2*nely_+[2 3 0 1] -2 -1],nelx_*nely_,1);
			[xCoord yCoord] = NodalizeDesignDomain([nelx_ nely_], [vtxLowerBound_; vtxUpperBound_]);
			nodeCoords_ = [xCoord, yCoord];				
		case '3D'
			%    z
			%    |__ x
			%   / 
			%  -y                            
			%            8--------------7      	
			%			/ |			   /|	
			%          5-------------6	|
			%          |  |          |  |
			%          |  |          |  |	
			%          |  |          |  |   
			%          |  4----------|--3  
			%     	   | /           | /
			%          1-------------2             
			%			Hexahedral element
			numEles_ = nelx_*nely_*nelz_;
			numNodes_ = (nelx_+1)*(nely_+1)*(nelz_+1);			
			eleSize_ = min([(vtxUpperBound_(1)-vtxLowerBound_(1))/nelx_, (vtxUpperBound_(2)-...
				vtxLowerBound_(2))/nely_, (vtxUpperBound_(3)-vtxLowerBound_(3))/nelz_]);
			nodenrs = reshape(1:(1+nelx_)*(1+nely_)*(1+nelz_), 1+nely_, 1+nelx_, 1+nelz_);
			edofVec = reshape(eleType_.numNodeDOFs*nodenrs(1:end-1,1:end-1,1:end-1)+1, ...
				nelx_*nely_*nelz_, 1);
			edofMat_ = repmat(edofVec,1,eleType_.numNode*eleType_.numNodeDOFs)+...
				repmat([0 1 2 3*nely_+[3 4 5 0 1 2] -3 -2 -1 3*(nely_+1)*(nelx_+1)+...
					[0 1 2 3*nely_+[3 4 5 0 1 2] -3 -2 -1] ], nelx_*nely_*nelz_,1);			
			[xCoord yCoord zCoord] = NodalizeDesignDomain([nelx_ nely_ nelz_], ...
				[vtxLowerBound_; vtxUpperBound_]);	
			nodeCoords_ = [xCoord, yCoord, zCoord];	
	end
	numDOFs_ = eleType_.numNodeDOFs * numNodes_;
	originalValidNodeIndex_ = (1:numNodes_)';
	eNodMat_ = edofMat_(:,eleType_.numNodeDOFs*(1:eleType_.numNode))/eleType_.numNodeDOFs;

	if strcmp(opt_CUTTING_DESIGN_DOMAIN_, 'OFF')
		global numNod2ElesVec_; numNod2ElesVec_ = zeros(numNodes_,1);
		global nodesOutline_;
		for ii=1:1:numEles_
			for jj=1:1:eleType_.numNode
				numNod2ElesVec_(eNodMat_(ii,jj)) = numNod2ElesVec_(eNodMat_(ii,jj))+1;
			end
		end
		nodesOutline_ = find(numNod2ElesVec_<eleType_.numNode);
	end
	
	%clear nodenrs edofVec
end
