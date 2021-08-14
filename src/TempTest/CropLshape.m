function ele2Bkept = CropLshape(corner)
	global nelx_; 
	global nely_;
	global eNodMat_;
	global nodeCoords_;
	eleNodCoordListX = nodeCoords_(:,1); eleNodCoordListX = eleNodCoordListX(eNodMat_);
	eleNodCoordListY = nodeCoords_(:,2); eleNodCoordListY = eleNodCoordListY(eNodMat_);
	eleCentroidList_ = [sum(eleNodCoordListX,2) sum(eleNodCoordListY,2)]/4;
	
	ele2Bremoved = find(eleCentroidList_(:,1)>corner(1));
	ele2Bremoved = ele2Bremoved(find(eleCentroidList_(ele2Bremoved,2)>corner(2)));
	allEle = (1:nelx_*nely_)';
	ele2Bkept = setdiff(allEle,ele2Bremoved); ele2Bkept = unique(ele2Bkept);
end