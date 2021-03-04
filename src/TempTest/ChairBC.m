
%%characterize = 1;
boundaryNodesCoords = nodeCoords_(nodesOutline_,:);
chairTopX0 = 0.2; chairTopX1 = 0.7;
chairTopY0 = 0.0; chairTopY1 = 0.5;
chairTopZ = 0.5;

chairBackX0 = 0.2;
chairBackY0 = 0.0; chairBackY1 = 0.5;
chairBackZ0 = 0.5; chairBackZ1 = 0.91;

rButt = 0.15;
buttPos = [0.6 0.25 0.5];

rBack = 0.2;
backPos = [0.2 0.25 1.0];

force = [0 0 -1; -1 0 0];

loadedNodesTemp1 = find(boundaryNodesCoords(:,1)>=chairTopX0);
loadedNodesTemp2 = loadedNodesTemp1(find(boundaryNodesCoords(loadedNodesTemp1,1)<=chairTopX1));
loadedNodes = loadedNodesTemp2(find(vecnorm(buttPos-boundaryNodesCoords(loadedNodesTemp2,:),2,2)<=rButt));
loadedNodes = nodesOutline_(loadedNodes);
numLoadedNodes = size(loadedNodes,1);
loadingCond_ = [loadedNodes repmat(force(1,:), numLoadedNodes, 1)];

loadedNodesTemp1 = find(boundaryNodesCoords(:,3)>=chairBackZ0);
loadedNodesTemp2 = loadedNodesTemp1(find(boundaryNodesCoords(loadedNodesTemp1,3)<=chairBackZ1));
loadedNodes = loadedNodesTemp2(find(vecnorm(backPos-boundaryNodesCoords(loadedNodesTemp2,:),2,2)<=rBack));
loadedNodes = nodesOutline_(loadedNodes);
numLoadedNodes = size(loadedNodes,1);
loadingCond_(end+1:end+numLoadedNodes,:) = [loadedNodes repmat(force(2,:), numLoadedNodes, 1)];

loadingCond_(:,2:end) = loadingCond_(:,2:end)*1000;