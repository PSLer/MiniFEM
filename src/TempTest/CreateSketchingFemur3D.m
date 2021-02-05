%%nelx_ = 120; nely_ = 100; nelz_ = 150;
eleCentX = nodeCoords_(:,1); eleCentX = eleCentX(eNodMat_);
eleCentY = nodeCoords_(:,2); eleCentY = eleCentY(eNodMat_);
eleCentZ = nodeCoords_(:,3); eleCentZ = eleCentZ(eNodMat_);
eleCentroidList_ = [sum(eleCentX,2) sum(eleCentY,2) sum(eleCentZ,2)]/8;

allEleList = (1:numEles_)';
tarEles = [];
eles2Bdiscard = [];

%%z=0 -> 100
iEles2Bdiscard = find(eleCentroidList_(:,3)<=100);
iEles2Bdiscard = iEles2Bdiscard(find(eleCentroidList_(iEles2Bdiscard,1)<=20));
eles2Bdiscard = [eles2Bdiscard; iEles2Bdiscard];

iEles2Bdiscard = find(eleCentroidList_(:,3)<=100);
iEles2Bdiscard = iEles2Bdiscard(find(eleCentroidList_(iEles2Bdiscard,1)>85));
eles2Bdiscard = [eles2Bdiscard; iEles2Bdiscard];

iEles2Bdiscard = find(eleCentroidList_(:,3)<=100);
iEles2Bdiscard = iEles2Bdiscard(find(eleCentroidList_(iEles2Bdiscard,2)<=20));
eles2Bdiscard = [eles2Bdiscard; iEles2Bdiscard];

iEles2Bdiscard = find(eleCentroidList_(:,3)<=100);
iEles2Bdiscard = iEles2Bdiscard(find(eleCentroidList_(iEles2Bdiscard,2)>80));
eles2Bdiscard = [eles2Bdiscard; iEles2Bdiscard];

%%z=101 -> 200
iEles2Bdiscard1 = find(eleCentroidList_(:,3)>100);
iEles2Bdiscard2 = iEles2Bdiscard1(find(eleCentroidList_(iEles2Bdiscard1,1)>40));
iEles2Bdiscard = iEles2Bdiscard2(find(eleCentroidList_(iEles2Bdiscard2,1)<=60));
eles2Bdiscard = [eles2Bdiscard; iEles2Bdiscard];

iEles2Bdiscard = find(eleCentroidList_(:,3)>130);
iEles2Bdiscard = iEles2Bdiscard(find(eleCentroidList_(iEles2Bdiscard,1)<=40));
eles2Bdiscard = [eles2Bdiscard; iEles2Bdiscard];

iEles2Bdiscard1 = find(eleCentroidList_(:,3)>100);
iEles2Bdiscard2 = iEles2Bdiscard1(find(eleCentroidList_(iEles2Bdiscard1,1)<=40));
iEles2Bdiscard = iEles2Bdiscard2(find(eleCentroidList_(iEles2Bdiscard2,2)<=10));
eles2Bdiscard = [eles2Bdiscard; iEles2Bdiscard];

iEles2Bdiscard1 = find(eleCentroidList_(:,3)>100);
iEles2Bdiscard2 = iEles2Bdiscard1(find(eleCentroidList_(iEles2Bdiscard1,1)<=40));
iEles2Bdiscard = iEles2Bdiscard2(find(eleCentroidList_(iEles2Bdiscard2,2)>90));
eles2Bdiscard = [eles2Bdiscard; iEles2Bdiscard];

eles2Bdiscard = unique(eles2Bdiscard);
tarEles = setdiff(allEleList, eles2Bdiscard);
numTarEles = length(tarEles)

%%

ctr1 = [100 45 150]; rad1 = 7;
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
ctr2 = [25 55 130]; rad2 = 5;
load2 = [1/2 0 sqrt(3)/2];

