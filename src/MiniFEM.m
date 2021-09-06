%% ----MiniFEM----
%% Author: Junpeng Wang  
%% Copyright (c) All rights reserved.
%% Create date:	24.07.2019
%% Update date:	23.04.2021
%% E-mail: junpeng.wang@tum.de

clear all; clc
addpath('./APP');
addpath('./Common');
addpath('./Modeling');
addpath('./Kernel');
addpath('./Visualization');
GlobalVariables;
outPath_ = 'D:/MyProjects/MiniFEM/out/'; if ~exist(outPath_, 'dir'), mkdir(outPath_); end

%%1. Set Material Properties
SetMaterialProperty('Unit'); %% 'Unit', 'Steel', 'Aluminium'

%%2. Create Geometrical Model (Pick the desirable one from the following options)
tStart = tic;
ModelingOpt = 3;
switch ModelingOpt
	case 1	
		SetElement('Plane144'); %% 'Plane133' or 'Plane144'
		CreateRectangle([100, 50], [0 0; 1 0.5]);
	case 2
		SetElement('Solid188'); %% 'Solid188'
		CreateCuboid([100, 50, 50], [0 0 0; 1 0.5 0.5]);
	case 3
		SetElement('Solid188'); %% 'Plane144' or 'Solid188'
		CreateFromWrappedVoxelFEAmodel('D:/MyDataSets/FEA_Models_voxel/kitten_132_115_200.txt');	
	case 4
		SetElement('Solid188'); %% 'Plane144' or 'Solid188'
		CreateModelFromTopOpti('D:/MyDataSets/FEA_Models_topOpti/bridge3D_4.topopti', 0.5);
	case 5
		SetElement('Solid188'); %% 'Solid188'
		CreateCartesianHexMeshFromTriFaceMesh_plyFormat('D:/MyDataSets/TriSurfMesh_ply/bird.ply', 256); 
	case 6
		SetElement('Solid188'); %% 'Solid188'
		CreateFromWrappedHexFEAmodel_vtkFormat('D:/MyDataSets/FEA_Models_vtk/bunny_hexa_FEA.vtk');
	case 7
		SetElement('Solid188'); %% 'Solid188'
		CreateFromExternalHexMesh_vtkFormat('D:/MyDataSets/HexMesh_vtk/holes10_hexa.vtk'); 
	case 8
		SetElement('Solid188'); %% 'Solid188'
		CreateFromExternalHexMesh_meshFormat('D:/MyDataSets/HexMesh_mesh/Bearing.mesh');
	case 9 %%unavailable yet
		SetElement('Solid144'); %% 'Solid144'
		CreateFromExternalTetMesh_meshFormat('D:/MyDataSets/TetMesh_mesh/airplane1_output_tet.mesh');		
	case 10 %%unavailable yet
		SetElement('Shell133'); %% 'Shell133'
		CreateFromExternalTriSurfMesh_plyFormat('D:/MyDataSets/TriPolyMesh_ply/chineseLion.ply');
	case 11 %%unavailable yet
		SetElement('Shell133'); %% 'Shell133'
		CreateFromExternalTriSurfMesh_objFormat('D:/MyDataSets/TriPolyGraph_obj/58009_sf.obj');
	case 12 %%unavailable yet
		SetElement('Shell144'); %% 'Shell144'
		CreateFromExternalQuadSurfMesh_meshFormat('D:/MyDataSets/QuadSurfMesh_mesh/3_octa-flower.mesh');
	otherwise
		error('Unsupported Modeling Option!');
end
disp(['Create FEA Model Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
ShowBoundaryCondition();

%%3. (Interactively) Apply For Boundary Condition
%% ...
%% ...


