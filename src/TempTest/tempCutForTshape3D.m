function validElements = tempCutForTshape3D(pilarThickness, roofThickness)
	global nodeCoords_;
	global eNodMat_;
	global eleType_;
	global nelx_;
	global nely_;
	global nelz_;
	global numEles_;
	
	eleNodCoordListX = nodeCoords_(:,1); eleNodCoordListX = eleNodCoordListX(eNodMat_);
	eleNodCoordListX = sum(eleNodCoordListX,2);
	eleNodCoordListY = nodeCoords_(:,2); eleNodCoordListY = eleNodCoordListY(eNodMat_);
	eleNodCoordListY = sum(eleNodCoordListY,2);
	eleNodCoordListZ = nodeCoords_(:,3); eleNodCoordListZ = eleNodCoordListZ(eNodMat_);
	eleNodCoordListZ = sum(eleNodCoordListZ,2);	
	eleCentroidList = [eleNodCoordListX eleNodCoordListY eleNodCoordListZ]/eleType_.nEleNodes;	
	
	eles2Bdiscarded1 = find(eleCentroidList(:,3)<nelz_-roofThickness);
	eles2Bdiscarded2 = find(eleCentroidList(:,1)<(nelx_-pilarThickness)/2);
	eles2Bdiscarded3 = find(eleCentroidList(:,1)>(nelx_+pilarThickness)/2);
	eles2BdiscardedAll = [intersect(eles2Bdiscarded1, eles2Bdiscarded2); intersect(eles2Bdiscarded1, eles2Bdiscarded3)];
	allEles = (1:numEles_)';
	allEles(eles2BdiscardedAll) = [];
	validElements = allEles;
end