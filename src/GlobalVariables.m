%% This script declares some global variables
%% FEA Model 
global material_;
global eleType_;
global meshType_; meshType_ = 'Any';
global nelx_; global nely_; global nelz_;
global boundingBox_;
global numEles_; global eNodMat_; global eDofMat_; 
global numNodes_; global numDOFs_; global nodeCoords_;
global carEleMapBack_; global carEleMapForward_;
global carNodMapBack_; global carNodMapForward_;
global numNodsAroundEleVec_; %%to be moved
global boundaryNodes_;
global fixingCond_; global loadingCond_;
global meshQualityJacobianRatio_;
global matrixD_; %%to be moved
global matrixB_; %%to be moved
% global outPath_;
% global domainType_; 			%% '2D' or '3D'
% global material_;
% global eleType_;				%% 'Plane144', 'Solid188'
% global meshType_; meshType_ = 'Any';
global GPU_; GPU_ = 'OFF';				
% global structureState_;  		%% 'STATIC', 'DYNAMIC'
% global modelSource_;			%% 'SelfDef', 'TopOpti', 'ExtMesh'
% global advancedSolvingOpt_;		%% 'TimePriority'; 'SpacePriority'
%% Solving Opt
% global preCond_;				%% 'ON', 'OFF'
global tol_; tol_ = 1.0e-6;
global maxIT_; maxIT_ = 20000;
% global moduls_; 				
% global poissonRatio_; 			
% global density_;				

% global vtxLowerBound_; 			 
% global vtxUpperBound_; 
% global nelx_; 
% global nely_; 
% global nelz_;
% global boundingBox_; 
% global numEles_; 
% global numNodes_; 
% global numDOFs_;
% global eleSize_;
% global eleState_;
% global nodState_;	
% global opt_CUTTING_DESIGN_DOMAIN_;

% global nodeStruct_;
% global nodeCoords_;
% global eNodMat_;
% global edofMat_; 
% global numNod2ElesVec_;
% global nodesOutline_;
% global nodeMap4CutBasedModel_;
% global originalValidNodeIndex_;
% global validElements_;

% global Ke_;
global K_;
% global Kq_;
% global Me_;
global M_;

global F_;
% global Mq_;
% global T_;
% global Te_;
% global Lp_;
% global Up_;

% global dShape_; 
% global invJ_;
% global JacobianRatio_;
% global eleD_;
% global eleB_;

% global loadingCond_;
% global fixingCond_;
% global loadedNodes_;
% global nodeLoadVec_;

% global Fq_;
% global fixeddofs_;
% global fixedNodes_;
% global freeNodes_;
global freeDOFs_; freeDOFs_ = [];

% global freqRange_;
% global freqSweepStep_;
% global freqSweepSamplings_;
% global iFreq_;
% global solSpace_;
% global numNaturalFreqs_;

global U_; U_ = [];
global cartesianStressField_; cartesianStressField_ = [];
global vonMisesStressField_; vonMisesStressField_ = [];
global principalStressField_; principalStressField_ = [];
global natureFrequencyList_; natureFrequencyList_ = [];
global modeSpace_; modeSpace_ = [];

% global modeSpace_;
% global naturalFreqs_;
% global gpuK_;

% global patchIndices_; 
%% Interaction
global outPath_;
global hdPickedNode_; hdPickedNode_ = [];
global PickedNodeCache_; PickedNodeCache_ = [];
