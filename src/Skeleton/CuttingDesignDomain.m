function CuttingDesignDomain(validElements)
	global numEles_; global numNodes_; global numDOFs_; global eleType_;
	global nodeCoords_; global edofMat_; global eNodMat_; 
	global numNod2ElesVec_; global nodesOutline_;
	global originalValidNodeIndex_;
	global nodeMap4CutBasedModel_;
	global boundaryCond_;
	%%1. load valid elements
	validElements = sort(validElements);
	
	%%2. remove unrelated elements and nodes
	validNodes = eNodMat_(validElements,:); 
	validNodes = reshape(validNodes', size(validNodes,1)*size(validNodes,2), 1);
	validNodes = unique(validNodes); originalValidNodeIndex_ = validNodes;
	validDofs = edofMat_(validElements,:);
	validDofs = reshape(validDofs', size(validDofs,1)*size(validDofs,2), 1);
	validDofs = unique(validDofs);	
	edofMat_ = edofMat_(validElements,:);
	eNodMat_ = eNodMat_(validElements,:);
	numNod2ElesVec_ = zeros(length(validNodes), 1);
	nodeCoords_ = nodeCoords_(validNodes,:);	
	%%3. reorder elements and nodes
	nodeMap4CutBasedModel_ = (1:1:numNodes_)'; currentNodSerials = (1:1:length(validNodes))';
	nodeMap4CutBasedModel_(validNodes) = currentNodSerials;
	eNodMat_ = nodeMap4CutBasedModel_(eNodMat_);
	oringinalDofSerials = (1:1:numDOFs_)'; currentDofSerials = (1:1:length(validDofs))';
	oringinalNofSerials(validDofs) = currentDofSerials;	
	edofMat_ = oringinalNofSerials(edofMat_);
	for ii=1:1:length(validElements)
		for jj=1:1:eleType_.numNode
			numNod2ElesVec_(eNodMat_(ii,jj)) = numNod2ElesVec_(eNodMat_(ii,jj))+1;
		end
	end
	nodesOutline_ = find(numNod2ElesVec_<eleType_.numNode);
	
	%%4. update parameters
	numEles_ = size(eNodMat_,1);
	numNodes_ = length(validNodes);
	numDOFs_ = length(validDofs);
	[invalidFixtion ia] = setdiff(boundaryCond_, validNodes);
	boundaryCond_(ia) = [];	
	%clear validElements validNodes validDofs currentNodSerials oringinalDofSerials currentDofSerials
end
