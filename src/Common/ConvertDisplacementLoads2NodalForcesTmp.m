function loadingCondNew = ConvertDisplacementLoads2NodalForcesTmp()
	global numNodes_ nodeCoords_ freeDOFs_ numDOFs_ loadingCond_ K_;
	
	alpha = 15/180*pi;
	
	loadedNodes = loadingCond_(:,1);
	allDOFs = (1:numDOFs_)';
	fixedDOFsActual = setdiff(allDOFs, freeDOFs_);	
	tmp = 6*loadedNodes;
	xxx = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp]'; xxx = xxx(:);	
	fixingState = zeros(size(loadingCond_(:,2:end))); fixingState(:,2:4)=1; fixingState = fixingState';
	fixedDOFsTmp = xxx(find(fixingState(:)));
	
	fixedDOFsNew = [fixedDOFsActual; fixedDOFsTmp];
	freeDOFsNew = setdiff(allDOFs, fixedDOFsNew);	
	
	K_ff = K_(freeDOFsNew, freeDOFsNew);
	K_fc = K_(freeDOFsNew, fixedDOFsNew); K_cf = K_fc';
	K_cc = K_(fixedDOFsNew, fixedDOFsNew);
	
	loadedNodeCoords = nodeCoords_(loadedNodes,:);
	iCtr = sum(loadedNodeCoords,1) / size(loadedNodeCoords,1);
	U0 = zeros(numNodes_,6);
	U0(loadedNodes,2) = -alpha*(loadedNodeCoords(:,3)-iCtr(3));
	U0(loadedNodes,3) = alpha*(loadedNodeCoords(:,2)-iCtr(2));
	U0(loadedNodes,4) = alpha; 
	U1 = U0'; U1 = U1(:);
	
	U1_c = U1(fixedDOFsNew,:);
	U1_f = -K_ff\(K_fc*U1_c);
	r_c = -(K_cf*U1_f + K_cc*U1_c);
	
	f0 = zeros(numDOFs_,1); 
	f0(fixedDOFsNew) = -r_c;
	f0(fixedDOFsActual) = 0;
	f1 = reshape(f0,6,numNodes_)'; 
	
	loadedDOFs = find(f0);
	allNodes = zeros(numNodes_,1);
	for ii=1:numel(loadedDOFs)
		iDOF = loadedDOFs(ii);
		if 0==mod(iDOF,6)
			iNode = iDOF/6;
		else
			iNode = floor(iDOF/6) + 1;
		end
		allNodes(iNode) = 1;
	end
	loadedNodesNew = find(allNodes);
	loadingCondNew = [loadedNodesNew f1(loadedNodesNew,:)];
end