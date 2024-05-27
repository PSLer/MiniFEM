function ApplyingExternalLoads(loadFile)
	global loadingCond_;
	global numNodes_;
	global nodeCoords_;
	global boundaryNodes_;
	externalLoadInfo = load(loadFile);
	
	allNodes = zeros(numNodes_,1);
	loadingCond_ = zeros(numNodes_, 1+3); %%Solid
	boundaryNodeCoords = nodeCoords_(boundaryNodes_,:);
	for ii=1:size(externalLoadInfo,1)
		iLoad = externalLoadInfo(ii,:);
		iCoord = iLoad(1:3);
		iForce = iLoad(4:end);
		[~, tarNode] = min(vecnorm(iCoord-boundaryNodeCoords, 2, 2));
		iTarNodesGlobal = boundaryNodes_(tarNode);
		loadingCond_(iTarNodesGlobal,1) = iTarNodesGlobal;
		loadingCond_(iTarNodesGlobal,2:end) = loadingCond_(iTarNodesGlobal,2:end) + iForce;
		allNodes(iTarNodesGlobal) = allNodes(iTarNodesGlobal) + 1;
	end
	reaLoadedNodes = find(allNodes);
	loadingCond_ = loadingCond_(reaLoadedNodes,:);
end