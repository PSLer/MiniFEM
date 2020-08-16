

%%common loading condition in 2D femur
% [28 152 0 1; 103 177 0 -1] ((ex-iLoad==1))
% [28 152 1/sqrt(2) 1/sqrt(2); 103 177 -1/sqrt(2) -1/sqrt(2)] ((ex-iLoad==2))
% [28 152 1/2 sqrt(3)/2; 103 177 -1/sqrt(2) -1/sqrt(2)] ((ex-iLoad==3))
load1 = [-1/sqrt(2) -1/sqrt(2)];
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
loadingNodeCoord1 = nodeOnOutlineCoords(165<=nodeOnOutlineCoords(:,2),:);
loadingNodeCoord1 = loadingNodeCoord1(105<=loadingNodeCoord1(:,1),:);
numNodes1 = size(loadingNodeCoord1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 sqrt(3)/2];
loadingNodeCoord2 = nodeOnOutlineCoords(147<=nodeOnOutlineCoords(:,2),:);
loadingNodeCoord2 = loadingNodeCoord2(50>loadingNodeCoord2(:,1),:);
numNodes2 = size(loadingNodeCoord2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeCoord = [loadingNodeCoord1; loadingNodeCoord2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==4))

% load1 = [-1/sqrt(2) -1/sqrt(2)];
% nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
% loadingNodeCoord1 = nodeOnOutlineCoords(174<=nodeOnOutlineCoords(:,2),:);
% loadingNodeCoord1 = loadingNodeCoord1(87<=loadingNodeCoord1(:,1),:);
% numNodes1 = size(loadingNodeCoord1,1); LoadingVec1 = repmat(load1, numNodes1, 1); 
% load2 = [1/2 sqrt(3)/2];
% loadingNodeCoord2 = nodeOnOutlineCoords(147<=nodeOnOutlineCoords(:,2),:);
% loadingNodeCoord2 = loadingNodeCoord2(50>loadingNodeCoord2(:,1),:);
% numNodes2 = size(loadingNodeCoord2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
% loadingNodeCoord = [loadingNodeCoord1; loadingNodeCoord2];
% LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==5))

% load1 = [-1/2 -sqrt(3)/2];
% nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
% loadingNodeCoord1 = nodeOnOutlineCoords(174<=nodeOnOutlineCoords(:,2),:);
% loadingNodeCoord1 = loadingNodeCoord1(87<=loadingNodeCoord1(:,1),:);
% numNodes1 = size(loadingNodeCoord1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
% load2 = [1/2 sqrt(3)/2];
% loadingNodeCoord2 = nodeOnOutlineCoords(147<=nodeOnOutlineCoords(:,2),:);
% loadingNodeCoord2 = loadingNodeCoord2(50>loadingNodeCoord2(:,1),:);
% numNodes2 = size(loadingNodeCoord2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
% loadingNodeCoord = [loadingNodeCoord1; loadingNodeCoord2];
% LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==6))

%%common loading condition in 2D transom
loadingNodeIndex = find(nodeCoords_(:,2)==vtxUpperBound_(2));
LoadingVec = zeros(length(loadingNodeIndex),2); LoadingVec(:,2) = -1;
[loadingNodeIndex LoadingVec]


%common loading condition in 3D femur
%[132 41 169 -1/sqrt(2) 0 -1/sqrt(2); 22 58 152 -1/sqrt(2) 0 1/sqrt(2)] ((ex-iLoad==1))
%%---------------------------------------------------------------------------
%[123 20 174 -1/2 0 -sqrt(3)/2; 21 50 146 1/sqrt(2) 0 1/sqrt(2)] ((ex-iLoad==2))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
ctr1 = [125 28 175]; radius1 = 15;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
ctr2 = [26 62 152]; radius2 = 12;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==3))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
loadingNodeIndex1_1 = find(165<=nodeOnOutlineCoords(:,3));
loadingNodeIndex1_2 = find(105<=nodeOnOutlineCoords(loadingNodeIndex1_1,1));
loadingNodeIndex1 = nodesOutline_(loadingNodeIndex1_1(loadingNodeIndex1_2));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
loadingNodeIndex2_1 = find(147<=nodeOnOutlineCoords(:,3));
loadingNodeIndex2_2 = find(50>nodeOnOutlineCoords(loadingNodeIndex2_1,1));
loadingNodeIndex2 = nodesOutline_(loadingNodeIndex2_1(loadingNodeIndex2_2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==4))
aa=[loadingNodeIndex LoadingVec];
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
ctr1 = [132 41 169]; radius1 = 15;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
ctr2 = [22 50 152]; radius2 = 12;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==5))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
ctr1 = [132 45 169]; radius1 = 15;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
ctr2 = [22 45 152]; radius2 = 12;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2];%((ex-iLoad==6))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
ctr1 = [132 35 169]; radius1 = 20;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
ctr2 = [22 55 152]; radius2 = 18;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==7))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
ctr1 = [123 30 177]; radius1 = 20;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
ctr2 = [30 60 152]; radius2 = 18;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==8))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [0 0 -1];
ctr1 = [123 30 177]; radius1 = 20;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [0 0 1];
ctr2 = [30 60 152]; radius2 = 18;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==9))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
ctr1 = [113 40 177]; radius1 = 20;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
ctr2 = [30 50 152]; radius2 = 18;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==10))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/2 0 -sqrt(3)/2];
ctr1 = [113 40 177]; radius1 = 20;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
ctr2 = [30 50 152]; radius2 = 18;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==11))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-0.36 0 -0.93];
ctr1 = [120 40 177]; radius1 = 20;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [0 0 1];
ctr2 = [30 50 152]; radius2 = 18;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==12))
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-0.36 0 -0.93];
ctr1 = [120 40 177]; radius1 = 20;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [0 0 1];
ctr2 = [30 60 152]; radius2 = 18;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==13)) 
%%---------------------------------------------------------------------------
nodeOnOutlineCoords = nodeCoords_(nodesOutline_,:);
load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
ctr1 = [136 27 170]; radius1 = 30;
loadingNodeIndex1 = nodesOutline_(find(vecnorm(ctr1-nodeOnOutlineCoords,2,2)<=radius1));
numNodes1 = size(loadingNodeIndex1,1); LoadingVec1 = repmat(load1, numNodes1, 1);
load2 = [1/2 0 sqrt(3)/2];
ctr2 = [22 64 150]; radius2 = 25;
loadingNodeIndex2 = nodesOutline_(find(vecnorm(ctr2-nodeOnOutlineCoords,2,2)<=radius2));
numNodes2 = size(loadingNodeIndex2,1); LoadingVec2 = repmat(load2, numNodes2, 1);
loadingNodeIndex = [loadingNodeIndex1; loadingNodeIndex2];
LoadingVec = [LoadingVec1; LoadingVec2]; %((ex-iLoad==14)) 