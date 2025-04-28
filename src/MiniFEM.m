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
SetMaterialProperty("Unit"); %% "Unit", "Steel", "Aluminium", "Concrete", "Wood"

%%2. Create Geometrical Model
tStart = tic;
ModelingOpt = 'Mdl_Built_in';
switch ModelingOpt
	case 'Mdl_Exclusive' %% ".miniFEM"
		MdlName = 'D:\MyProjects\LanguerreTO\data/Cantilever3D.MiniFEM';
		CreateMdl_ExclusiveFormat(MdlName);
	case 'Mdl_Stress' %% ".stress"
		MdlName = 'D:\MyProjects\3D-TSV-authorOnly\data\femurHigh2D.stress';
		CreateMdl_StressData(MdlName);		
	case 'Mdl_Voxel' %% ".txt"
		MdlName = 'D:\wSpace\2024_pp_Summary3D\figs\2D\femur\femurHigh2D_R1168_B.txt';
		CreateMdl_VoxelData(MdlName, 1);
	case 'Mdl_TopOpti' %% ".topopti"
		MdlName = 'D:\wSpace\2024_pp_Summary3D\figs\Chair\PSLsGuided\optimizedModel.topopti';
		extractThreshold = 0.1;
		CreateMdl_TopOptiData(MdlName, extractThreshold);
	case 'Mdl_TopVoxel'
		MdlName = 'D:\wSpace\coAarhus\SGLDBench\data\timber_panel_2.TopVoxel';
		extractThreshold = 0.1;
		CreateMdl_TopVoxelData(MdlName, extractThreshold, 3);		
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


