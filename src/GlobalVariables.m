%% This script declares some global variables
global outPath_;
global domainType_; 			%% '2D' or '3D'
global eleType_;				%% 'Plane144', 'Solid188'
global GPU_;					%% 'ON', 'OFF', for Modal Analysis
global structureState_;  		%% 'STATIC', 'DYNAMIC'
global modelSource_;			%% 'SelfDef', 'TopOpti', 'ExtMesh'
global advancedSolvingOpt_;		%% 'TimePriority'; 'SpacePriority'
global preCond_;				%% 'ON', 'OFF'
global tol_; tol_ = 1.0e-6;
global maxIT_; maxIT_ = 20000;
global moduls_; 				
global poissonRatio_; 			
global density_;				

global vtxLowerBound_; 			 
global vtxUpperBound_; 
global nelx_; 
global nely_; 
global nelz_; 
global numEles_; 
global numNodes_; 
global numDOFs_;
global eleSize_;
global opt_CUTTING_DESIGN_DOMAIN_;

global nodeStruct_;
global nodeCoords_;
global eNodMat_;
global edofMat_; 
global numNod2ElesVec_;
global nodesOutline_;
global nodeMap4CutBasedModel_;
global originalValidNodeIndex_;
global validElements_;

global Ke_;
global K_;
global Kq_;
global Me_;
global M_;
global Mq_;
global T_;
global Te_;
global Lp_;
global Up_;

global dShape_; 
global invJ_;
global JacobianRatio_;
global eleD_;
global eleB_;

global loadingCond_;
global boundaryCond_;
global loadedNodes_;
global nodeLoadVec_;
global F_;
global Fq_;
global fixeddofs_;
global fixedNodes_;
global freeNodes_;
global freeDofs_;

global freqRange_;
global freqSweepStep_;
global freqSweepSamplings_;
global iFreq_;
global solSpace_;
global numNaturalFreqs_;

global U_; 
global cartesianStressField_;
global vonMisesStressField_;
global principalStressField_;

global modalSpace_;
global naturalFreqs_;
global gpuK_;

global patchIndices_; 

global PickedNodeCache_; PickedNodeCache_ = [];
