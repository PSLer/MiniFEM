function ApplyingExternalFixations(fixationFile)
	global eleType_;
	global fixingCond_;
	global numNodes_;
	global nodeCoords_;
	global boundaryNodes_;
	externalFixationInfo = load(fixationFile);
	
	allNodes = zeros(numNodes_,1);
	switch eleType_.eleName
		case 'Beam123'
			fixingCond_ = zeros(numNodes_, 1+6); 
		case 'Solid144'
			fixingCond_ = zeros(numNodes_, 1+3); 
		case 'Solid188'
			fixingCond_ = zeros(numNodes_, 1+3); 
	end
	
	boundaryNodeCoords = nodeCoords_(boundaryNodes_,:);
	for ii=1:size(externalFixationInfo,1)
		iLoad = externalFixationInfo(ii,:);
		iCoord = iLoad(1:3);
		iFixation = iLoad(4:end);
		[~, tarNode] = min(vecnorm(iCoord-boundaryNodeCoords, 2, 2));
		switch eleType_.eleName
			case 'Beam123'
				iTarNodesGlobal = tarNode;
			case 'Solid144'
				iTarNodesGlobal = boundaryNodes_(tarNode);
			case 'Solid188'
				iTarNodesGlobal = boundaryNodes_(tarNode);
		end
		
		fixingCond_(iTarNodesGlobal,1) = iTarNodesGlobal;
		fixingCond_(iTarNodesGlobal,2:end) = iFixation;
		allNodes(iTarNodesGlobal) = allNodes(iTarNodesGlobal) + 1;
	end
	reaFixedNodes = find(allNodes);
	fixingCond_ = fixingCond_(reaFixedNodes,:);
end