%% ----MiniFEM----
%% Author: Junpeng Wang  
%% Copyright (c) All rights reserved.
%% Create date:		24.07.2019
%% Update date:		23.04.2021
%% Release date:	13.07.2025
%% E-mail: junpeng.wang@tum.de

clear all; clc;
addpath('./APP');
addpath('./Common');
addpath('./Modeling');
addpath('./Kernel');
addpath('./Visualization');
GlobalVariables;
outPath_ = 'D:/MyProjects/MiniFEM/out/'; if ~exist(outPath_, 'dir'), mkdir(outPath_); end

%%1. Set Material Properties
SetMaterialProperty("Aluminium"); %% "Unit", "Steel", "Aluminium", "Concrete", "Wood"

%%2. Create Geometrical Model
tStart = tic;
ModelingOpt = 'Mdl_MiniFEM';
switch ModelingOpt
	case 'Mdl_MiniFEM' %% Exclusive Data Format
		MdlName = '../data/Demo_Solid_Hex.MiniFEM';
		CreateMdl_ExclusiveFormat(MdlName);
    case 'Mdl_TSV' %% This is to re-do simuation of FEM models used for 3D-TSV
		MdlName = '../data/Demo_2D.TSV';
		CreateMdl_TSVData(MdlName);		
    case 'Mdl_TopVoxel' %% This is for conprehensive evaluation of topology-optimized shapes from SGLDBench (low resolution)
		MdlName = '../data/Demo_TopOpt_3D.TopVoxel';
		extractThreshold = 0.1;
		CreateMdl_TopVoxelData(MdlName, extractThreshold, 1);		
	case 'Mdl_Built_in'
		SetElement('Plane144'); %% 'Plane144', 'Plane133', 'Solid188', 'Solid144'
		if strcmp(eleType_.eleName, 'Plane144') || strcmp(eleType_.eleName, 'Plane133')
			CreateRectangle([100, 50], [0 0; 1 0.5]);
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


