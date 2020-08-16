eleNodCoordListX = nodeCoords_(:,1); eleNodCoordListX = eleNodCoordListX(eNodMat_);
eleNodCoordListX = sum(eleNodCoordListX,2);
eleNodCoordListY = nodeCoords_(:,2); eleNodCoordListY = eleNodCoordListY(eNodMat_);
eleNodCoordListY = sum(eleNodCoordListY,2);
eleNodCoordListZ = nodeCoords_(:,3); eleNodCoordListZ = eleNodCoordListZ(eNodMat_);
eleNodCoordListZ = sum(eleNodCoordListZ,2);
eleCentroidList_ = [eleNodCoordListX eleNodCoordListY eleNodCoordListZ]/eleType_.numNode;

validElements1 = load('../ioWD/validElement_femur.txt');
eleCentroidList_ = floor(eleCentroidList_);
validEleCoords = eleCentroidList_(validElements1,:);
sliceCoord = validEleCoords(46==validEleCoords(:,2),:);
plot(sliceCoord(:,1), sliceCoord(:,3), '.b'); axis equal
validEleIndex = nelz_-sliceCoord(:,3) + (sliceCoord(:,1)-1)*nelz_;