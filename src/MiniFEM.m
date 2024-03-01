%% ----MiniFEM----
%% Author: Junpeng Wang  
%% Copyright (c) All rights reserved.
%% Create date:	24.07.2019
%% Update date:	23.04.2021
%% E-mail: junpeng.wang@tum.de

clear all; clc;
addpath('./APP');
addpath('./Common');
addpath('./Modeling');
addpath('./Kernel');
addpath('./Visualization');
addpath('./TempTest');
GlobalVariables;
outPath_ = 'D:/MyProjects/MiniFEM/out/'; if ~exist(outPath_, 'dir'), mkdir(outPath_); end

%%1. Set Material Properties
SetMaterialProperty(["Concrete", "Steel"]); %% "Unit", "Steel", "Aluminium", "Concrete"

%%2. Create Geometrical Model
tStart = tic;
ModelingOpt = 'Mdl_Exclusive';
switch ModelingOpt
	case 'Mdl_Exclusive' %% ".miniFEM"
		MdlName = 'D:\wSpace\ReinforcedConcreteStruct\log\20240226_forExchange\testBeam2\DeHomo\Data4MiniFEM.MiniFEM';
		CreateMdl_ExclusiveFormat(MdlName);
	case 'Mdl_Stress' %% ".stress"
		MdlName = 'D:\wSpace\MeshStructDesign\log\20240219_Femur3D\femurHigher_Junpeng.stress';
		CreateMdl_StressData(MdlName);		
	case 'Mdl_Voxel' %% ".txt"
		MdlName = 'D:\BaiduSyncdisk\MyDataSets\FEA_Models_voxel\femur3D\femur_R184.txt';
		CreateMdl_VoxelData(MdlName, 1);
	case 'Mdl_TopOpti' %% ".topopti"
		MdlName = 'D:\wSpace\ReinforcedConcreteStruct\log\20240226_forExchange\testBeam2\G\optimizedModel.topopti';
		extractThreshold = 0.1;
		CreateMdl_TopOptiData(MdlName, extractThreshold, 20);
	case 'Mdl_Built_in'
		SetElement('Plane144'); %% 'Plane144', 'Plane133', 'Solid188', 'Solid144'
		if strcmp(eleType_.eleName, 'Plane144') || strcmp(eleType_.eleName, 'Plane133')
			CreateRectangle([60, 30], [0 0; 1 0.5]);
		elseif strcmp(eleType_.eleName, 'Solid188') || strcmp(eleType_.eleName, 'Solid144')
			CreateCuboid([40, 20, 20], [0 0 0; 1 0.5 0.5]);
		else
			error('Un-suppported Input!');
		end
end

disp(['Create FEA Model Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
ShowBoundaryCondition();

%%3. (Interactively) Apply For Boundary Condition
%% ...
%% ...


