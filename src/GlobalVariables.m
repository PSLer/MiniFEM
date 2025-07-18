%% This script declares some global variables

%% FEA Model 
global material_;
global eleType_;
global meshType_; meshType_ = 'ARBITRARY';
global nelx_; global nely_; global nelz_;
global boundingBox_;
global numEles_; global eNodMat_; global eDofMat_; 
global numNodes_; global numDOFs_; global nodeCoords_;
global carEleMapBack_; global carEleMapForward_;
global carNodMapBack_; global carNodMapForward_;
global boundaryNodes_;
global boundaryFaceNodMat_;
global boundaryEdgeNodMat_;
global fixingCond_; global loadingCond_;
global diameterList_;
global meshQualityJacobianRatio_;
global freeDOFs_; freeDOFs_ = [];
global materialIndicatorField_; materialIndicatorField_ = [];
global K_;
global M_;
global F_;

%% Solving Opt
global GPU_; GPU_ = 'ON';				
global tol_; tol_ = 1.0e-6;
global maxIT_; maxIT_ = 20000;

%% Output
global U_; U_ = [];
global cartesianStressField_; cartesianStressField_ = [];
global vonMisesStressField_; vonMisesStressField_ = [];
global principalStressField_; principalStressField_ = [];
global naturalFrequencyList_; naturalFrequencyList_ = [];
global modeSpace_; modeSpace_ = [];
global displacmentHistory_; displacmentHistory_ = [];
global velocityHistory_; velocityHistory_ = [];	
global accelerationHistory_; accelerationHistory_ = [];	
global timeAxis_; timeAxis_ = [];

%% Interaction
global outPath_;
global hdPickedNode_; hdPickedNode_ = [];
global pickedNodeCache_; pickedNodeCache_ = [];
