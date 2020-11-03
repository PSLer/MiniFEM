%% ----MiniFEM----
%% Author: Junpeng Wang  
%% Copyright (c) All rights reserved.
%% Create date:	24.07.2019
%% Update date:	29.03.2020
%% E-mail: junpeng.wang@tum.de
%% Successfully tested in MATLAB R2018b Academic use Ed.

clear all; clc

addpath('./APP');
addpath('./DataStruct');
addpath('./Common');
addpath('./Kernel');
addpath('./Solving');
addpath('./TempTest');
addpath('./Visualization');
addpath('../data');

GlobalVariables;
outPath_ = 'D:/MyProjects/MiniFEM/out'; %recommend to use absolute path direction
if ~exist(outPath_, 'dir'), mkdir(outPath_); end

%% 1. initialization
crtFEModelStart = cputime; 
domainType_ = '2D'; 
if strcmp(domainType_, '2D'), eleType_ = Plane144(); 
elseif strcmp(domainType_, '3D'), eleType_ = Solid188(); 
else, error('Critical ERROR! Wrong element type!!!'); end

structureState_ = 'STATIC'; %% 'STATIC', 'DYNAMIC'
if strcmp(structureState_, 'DYNAMIC'), 
	iFreq_ = 500; %%computing frequency response 
	freqSweepStep_ = 5; freqRange_ = [1 100];  %%frequency sweep
	numNaturalFreqs_ = 20; %%for modal analysis
end

%% 'TimePriority'; 'SpacePriority' (not available for modal analysis)
advancedSolvingOpt_ = 'TimePriority';
%% 'ON', 'OFF', only available for modal analysis
GPU_ = 'ON';
%% 'ON', OFF. Only valid for iteratively solving the linear system in 'TimePriority' way
preCond_ = 'ON'; 

moduls_ = 1;  poissonRatio_ = 0.3;  density_ = 1; %%academic use
%moduls_ = 2.1e11;  poissonRatio_ = 0.3;  density_ = 7900; %%steel
%moduls_ = 7.0e10;  poissonRatio_ = 0.3;  density_ = 2700; %%aluminium
%moduls_ = 3.7e9;  poissonRatio_ = 0.3;  density_ = 1200; %%artificial bone

%% 2. create geometrical model
modelSource_ = 'SelfDef'; %% 'SelfDef', 'TopOpti', 'ExtMesh'
switch modelSource_
	case 'SelfDef'
		switch domainType_
			case '2D'
				vtxLowerBound_ = [0 0];
				nelx_ = 300; nely_ = 250; featureSize = max([nelx_,nely_]);
				%nelx_ = 140; nely_ = 182; featureSize = max([nelx_,nely_]);; %femur 2D 
				vtxUpperBound_ = featureSize*[nelx_ nely_]/max([nelx_ nely_]);
			case '3D'
				vtxLowerBound_ = [0 0 0];
 				nelx_ = 100; nely_ = 50; nelz_ = 50; featureSize = max([nelx_,nely_, nelz_]);
				%nelx_ = 140; nely_ = 92; nelz_ = 182; featureSize = max([nelx_,nely_, nelz_]);  %%femur 3D				
				vtxUpperBound_ = featureSize*[nelx_ nely_ nelz_]/max([nelx_ nely_ nelz_]);			
		end
		opt_CUTTING_DESIGN_DOMAIN_ = 'OFF'; %% 'ON', 'OFF'
		DiscretizeDesignDomain();		
		if strcmp(opt_CUTTING_DESIGN_DOMAIN_, 'ON')
			%fileName = 'D:/MyDataSets/ClippingMdls/femur3D_140_92_182.txt';
			fileName = '../data/demo-DataSet-CroppingModel.txt';
			CuttingDesignDomain(LoadClipModel(fileName)); 
		end
	case 'TopOpti'
		%srcName = 'D:/MyDataSets/TopOptiMdls4FEA/roof3D.topopti';	
		srcName = '../data/demo-DataSet-TopoOpti2D.topopti';	
		extractThreshold = 0.5;
		featureSize = []; %% scalar or empty
		CreateModelTopOptiSrc(srcName, extractThreshold, featureSize);
	case 'ExtMesh'
		%srcName = 'D:/MyDataSets/ExternalMdls4FEA/dragonStand1_hexa_FEA.vtk';
		srcName = '../data/demo-DataSet-ExternalInputMeshVTK.vtk';
		CreateModelExtMeshSrc(srcName);
	otherwise
		error('VitaL ERROR! Failed to create geometrical model!!!')
end

%%3. create physical model
%%3.1 assemble system matrix
AssembleSystemMatrices();

%%3.2 Apply boundary condition
%% argin = [fixedNodes_] (approximate coordinates also acceptable) OR
%% 'X', 'Y', 'Z' (only valid for the self-defined model, and 'Z' for 3D) OR
boundaryCond_ = 'X';
ApplyBoundaryCondition(); 

%3.3 Loading 
loadingCond_ = [vtxUpperBound_(1) vtxUpperBound_(2)/2 0 -1];
ApplyLoads();

%%4. visualize FEM model
%% argin = 'EleVis', (direct volume rendering, available for any) OR
%%  		'NodVis', (point cloud without rendering) OR 
%% 			'outlineVis', (unavailable for external mesh)
VisualizingProblemDescription('outlineVis');
disp(['Creating FEM model costs totally: ' sprintf('%10.3g',cputime-crtFEModelStart) 's'])


%% BENCHMARK
%common loading condition in 2D cantilever
%[vtxUpperBound_(1) vtxUpperBound_(2)/2 0 -1]  (ex-iLoad==3)
%[vtxUpperBound_(1) vtxLowerBound_(2) 0 -1] (ex-iLoad==4)
%[vtxUpperBound_(1) vtxUpperBound_(2)/2 1 0; vtxUpperBound_(1)/2 vtxLowerBound_(2) 0 -1] (ex-iLoad==5)
%[vtxUpperBound_(1) vtxUpperBound_(2)/2 1 0; vtxUpperBound_(1)/2 vtxUpperBound_(2) 1 0] (ex-iLoad==6)
% loadingNodeCoord = nodeCoords_(vtxUpperBound_(1)==nodeCoords_(:,1),:); 
% numLoadedNodes = size(loadingNodeCoord,1);
% LoadingVec = zeros(numLoadedNodes,2); LoadingVec(:,2) = -1/numLoadedNodes; 
% loadingCond_ = [loadingNodeCoord LoadingVec]; %(ex-iLoad==7)
% iLoad 5 500Hz %(ex-iLoad==8)

%common loading condition in 3D cantilever
%[vtxUpperBound_(1) vtxUpperBound_(2)/2 vtxUpperBound_(3)/2 0.0 0.0 -1] ((ex-iLoad==3))
%[vtxUpperBound_(1) vtxUpperBound_(2)/2 vtxLowerBound_(3) 0.0 0.0 -1] ((ex-iLoad==4))
%[vtxUpperBound_(1) vtxLowerBound_(2) vtxLowerBound_(3) 0.0 0.0 -1] ((ex-iLoad==5))
% force = [0.0 0.0 -1];
% loadingNodeIndex_1 = find(vtxUpperBound_(1)==nodeCoords_(:,1));
% loadingNodeIndex_2 = find(vtxLowerBound_(3)==nodeCoords_(loadingNodeIndex_1,3));
% loadingNodeIndex = loadingNodeIndex_1(loadingNodeIndex_2);
% force = force/length(loadingNodeIndex);
% LoadingVec = repmat(force, size(loadingNodeIndex,1), 1); 
% loadingCond_ = [loadingNodeIndex LoadingVec]; %(ex-iLoad==6, line loading)
% force = [0.0 0.0 -1];
% loadingNodeIndex = find(vtxUpperBound_(1)==nodeCoords_(:,1));
% force = force/length(loadingNodeIndex);
% LoadingVec = repmat(force, size(loadingNodeIndex,1), 1);
% loadingCond_ = [loadingNodeIndex LoadingVec]; %(ex-iLoad==7, surface loading)
% force = [0.0 0.0 -1];
% loadingNodeIndex_1 = find(vtxUpperBound_(1)==nodeCoords_(:,1));
% loadingNodeIndex_2 = find(vtxLowerBound_(2)==nodeCoords_(loadingNodeIndex_1,2));
% loadingNodeIndex = loadingNodeIndex_1(loadingNodeIndex_2);
% force = force/length(loadingNodeIndex);
% LoadingVec = repmat(force, size(loadingNodeIndex,1), 1); 
% loadingCond_ = [loadingNodeIndex LoadingVec]; %(ex-iLoad==8, line loading, torsion)

%%% femur 2D
%%ex-iLoad==1
%%----------------------------unscaled
% load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
% ctr1 = [33 151]; rad1 = 9;
% load2 = [1/2 0 sqrt(3)/2];
% ctr2 = [126 167]; rad2 = 13; %%ex-iLoad==1
%%----------------------------scaled, featureSize = 1
% load1 = [-1/sqrt(2) -1/sqrt(2)];
% ctr1 = [0.18 0.83]; rad1 = 0.02;
% load2 = [1/2 sqrt(3)/2];
% ctr2 = [0.69 0.94]; rad2 = 0.03; %%ex-iLoad==1, featureSize=1
%%================================================
% loadedNode1 = nodesOutline_(find(vecnorm(ctr1-nodeCoords_(nodesOutline_,:),2,2)<rad1));
% LoadedVec1 = repmat(load1,size(loadedNode1,1),1);
% loadedNode2 = nodesOutline_(find(vecnorm(ctr2-nodeCoords_(nodesOutline_,:),2,2)<rad2));
% LoadedVec2 = repmat(load2,size(loadedNode2,1),1);
% loadingCond_ = [[loadedNode1; loadedNode2] [LoadedVec1; LoadedVec2]];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%% femur 3D
%%ex-iLoad==1
%%----------------------------unscaled
% load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
% ctr1 = [131 25 169]; rad1 = 15;
% load2 = [1/2 0 sqrt(3)/2];
% ctr2 = [36 64 153]; rad2 = 12; %%ex-iLoad==1
%%----------------------------scaled, featureSize = 2
% load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
% ctr1 = [1.44 0.2747 1.857]; rad1 = 0.165;
% load2 = [1/2 0 sqrt(3)/2];
% ctr2 = [0.3956 0.7033 1.677]; rad2 = 0.132; %%ex-iLoad==1, featureSize=2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%ex-iLoad==5
%%----------------------------unscaled
% load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
% ctr1 = [132 41 169]; rad1 = 15;
% load2 = [1/2 0 sqrt(3)/2];
% ctr2 = [22 50 152]; rad2 = 12; %%ex-iLoad==5
%%----------------------------scaled, featureSize = 2
% load1 = [-1/sqrt(2) 0 -1/sqrt(2)];
% ctr1 = [1.452 0.451 1.859]; rad1 = 0.165;
% load2 = [1/2 0 sqrt(3)/2];
% ctr2 = [0.242 0.55 1.672]; rad2 = 0.132; %%ex-iLoad==5, featureSize=2
%%================================================
% loadedNode1 = nodesOutline_(find(vecnorm(ctr1-nodeCoords_(nodesOutline_,:),2,2)<rad1));
% LoadedVec1 = repmat(load1,size(loadedNode1,1),1);
% loadedNode2 = nodesOutline_(find(vecnorm(ctr2-nodeCoords_(nodesOutline_,:),2,2)<rad2));
% LoadedVec2 = repmat(load2,size(loadedNode2,1),1);
% loadingCond_ = [[loadedNode1; loadedNode2] [LoadedVec1; LoadedVec2]];


%% 7. output FEM model and cartesian stress field for vis. based on LLGP
%OutputStressFieldInfo_vtk('../../IO/DATASETs_StressVis/cantilever3D_100_50_50_case3');
%OutputStressFieldInfo_Binary('../../IO/DATASETs_StressVis/cantilever3D_100_50_50_case3_');