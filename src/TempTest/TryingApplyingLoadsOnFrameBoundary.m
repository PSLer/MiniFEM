function TryingApplyingLoadsOnFrameBoundary()
	global loadingCond_;
	global numNodes_;
	global nodeCoords_;
	externalLoadInfo = load('D:\wSpace\MeshStructDesign\log\20240219_Femur3D\loadsFile4Beam.loads');
	
	allNodes = zeros(numNodes_,1);
	loadingCond_ = zeros(numNodes_, 1+6); %%Beam123
	for ii=1:size(externalLoadInfo,1)
		iLoad = externalLoadInfo(ii,:);
		iCoord = iLoad(1:3);
		iForce = iLoad(4:end);
		[~, tarNode] = min(vecnorm(iCoord-nodeCoords_, 2, 2));
		loadingCond_(tarNode,1) = tarNode;
		loadingCond_(tarNode,2:end) = loadingCond_(tarNode,2:end) + iForce;
		allNodes(tarNode) = allNodes(tarNode) + 1;
	end
	reaLoadedNodes = find(allNodes);
	loadingCond_ = loadingCond_(reaLoadedNodes,:);
end