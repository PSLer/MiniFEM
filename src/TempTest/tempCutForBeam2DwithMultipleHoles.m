eleNodCoordListX = nodeCoords_(:,1); eleNodCoordListX = eleNodCoordListX(eNodMat_);
eleNodCoordListX = sum(eleNodCoordListX,2);
eleNodCoordListY = nodeCoords_(:,2); eleNodCoordListY = eleNodCoordListY(eNodMat_);
eleNodCoordListY = sum(eleNodCoordListY,2);
eleCentroidList_ = [eleNodCoordListX eleNodCoordListY]/eleType_.numNode;

ctr1 = [nelx_/2 nely_/2]; rad1 = nely_/10;
eles2beDiscard1 = find(vecnorm(ctr1-eleCentroidList_,2,2)<=rad1);
ctr2 = [nelx_/4 nely_*3/10]; rad2 = nely_/20;
eles2beDiscard2 = find(vecnorm(ctr2-eleCentroidList_,2,2)<=rad2);
ctr3 = [nelx_/4 nely_*7/10]; rad3 = nely_/20;
eles2beDiscard3 = find(vecnorm(ctr3-eleCentroidList_,2,2)<=rad3);
ctr4 = [nelx_*3/4 nely_*3/10]; rad4 = nely_/20;
eles2beDiscard4 = find(vecnorm(ctr4-eleCentroidList_,2,2)<=rad4);
ctr5 = [nelx_*3/4 nely_*7/10]; rad5 = nely_/20;
eles2beDiscard5 = find(vecnorm(ctr5-eleCentroidList_,2,2)<=rad5);
ctr6 = [nelx_/2 0]; rad6 = nely_/10;
eles2beDiscard6 = find(vecnorm(ctr6-eleCentroidList_,2,2)<=rad6);
ctr7 = [nelx_/2 nely_]; rad7 = nely_/10;
eles2beDiscard7 = find(vecnorm(ctr7-eleCentroidList_,2,2)<=rad7);
eles2beDiscardT = unique([eles2beDiscard1; eles2beDiscard2; eles2beDiscard3; eles2beDiscard4; ...
	eles2beDiscard5; eles2beDiscard6; eles2beDiscard7]);
elesRemained = (1:1:numEles_)'; elesRemained(eles2beDiscardT) = [];

% ctr1 = [0.2 0.15]; rad1 = 0.05;
% eles2beDiscard1 = find(vecnorm(ctr1-eleCentroidList_,2,2)<=rad1);
% ctr2 = [0.2 0.35]; rad2 = 0.05;
% eles2beDiscard2 = find(vecnorm(ctr2-eleCentroidList_,2,2)<=rad2);

% ctr3 = [0.4 0.15]; rad3 = 0.05;
% eles2beDiscard3 = find(vecnorm(ctr3-eleCentroidList_,2,2)<=rad3);
% ctr4 = [0.4 0.35]; rad4 = 0.05;
% eles2beDiscard4 = find(vecnorm(ctr4-eleCentroidList_,2,2)<=rad4);

% ctr5 = [0.6 0.15]; rad5 = 0.05;
% eles2beDiscard5 = find(vecnorm(ctr5-eleCentroidList_,2,2)<=rad5);
% ctr6 = [0.6 0.35]; rad6 = 0.05;
% eles2beDiscard6 = find(vecnorm(ctr6-eleCentroidList_,2,2)<=rad6);

% ctr7 = [0.8 0.15]; rad7 = 0.05;
% eles2beDiscard7 = find(vecnorm(ctr7-eleCentroidList_,2,2)<=rad7);
% ctr8 = [0.8 0.35]; rad8 = 0.05;
% eles2beDiscard8 = find(vecnorm(ctr8-eleCentroidList_,2,2)<=rad8);
% eles2beDiscardT = unique([eles2beDiscard1; eles2beDiscard2; eles2beDiscard3; eles2beDiscard4; ...
	% eles2beDiscard5; eles2beDiscard6; eles2beDiscard7; eles2beDiscard8]);
% elesRemained = (1:1:numEles_)'; elesRemained(eles2beDiscardT) = [];



