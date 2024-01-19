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
GlobalVariables;
outPath_ = 'D:/MyProjects/MiniFEM/out/'; if ~exist(outPath_, 'dir'), mkdir(outPath_); end

%%1. Set Material Properties
SetMaterialProperty('Aluminium'); %% 'Unit', 'Steel', 'Aluminium'

%%2. Create Geometrical Model (Pick the desirable one from the following options)
tStart = tic;
ModelingOpt = 0;
switch ModelingOpt
	case 0 %%Unified Mesh Format (.stress v2) for arbitrary mesh (Quad, Tri, Hex, Tet)
		CreateFromArbitraryMesh_unifiedStressFormat('D:\wSpace\TransientStructOpti\data\femur_Hex.stress');
	case 1	
		SetElement('Plane144'); %% 'Plane133' or 'Plane144'
		CreateRectangle([60, 30], [0 0; 1 0.5]);
	case 2
		SetElement('Solid188'); %% 'Solid188'
		CreateCuboid([40, 20, 20], [0 0 0; 1 0.5 0.5]);
	case 3
		SetElement('Plane144'); %% 'Plane144' or 'Solid188'
		CreateFromWrappedVoxelFEAmodel('D:\wSpace\MeshStructDesign\data\2D\demo\wrappedVoxelFEAmodel.txt', 1);	
	case 4
		SetElement('Solid188'); %% 'Plane144' or 'Solid188'
		CreateModelFromTopOpti('D:/MyDataSets/FEA_Models_topOpti/bridge3D_4.topopti', 0.5);
	case 5
		SetElement('Solid188'); %% 'Solid188'
		CreateCartesianHexMeshFromTriFaceMesh_plyFormat('D:/MyDataSets/TriSurfMesh_ply/bird.ply', 256); 
	case 6
		SetElement('Solid188'); %% 'Solid188'
		CreateFromWrappedHexFEAmodel_vtkFormat('D:\wSpace\MeshStructDesign\data\femur_hexa/wrappedHexFEAmodel.vtk');
	case 7
		SetElement('Solid188'); %% 'Solid188'
		CreateFromExternalHexMesh_vtkFormat('D:/MyDataSets/HexMesh_vtk/airplane1_hexa.vtk'); 
	case 8
		SetElement('Solid188'); %% 'Solid188'
		CreateFromExternalHexMesh_meshFormat('D:/MyDataSets/HexMesh_mesh/Bearing.mesh');
	case 9
		SetElement('Solid144'); %% 'Solid144'
		CreateFromExternalTetMesh_meshFormat('D:\wSpace\MeshStructDesign\data\spot_Dennis/spot_Dennis.mesh');
	case 10
		SetElement('Solid144'); %% 'Solid144'
		CreateFromWrappedTetFEAmodel_meshFormat('D:\wSpace\MeshStructDesign\data\femurHigh_Dennis\wrappedTetFEAmodel.mesh');		
	case 11 %%unavailable yet
		SetElement('Shell133'); %% 'Shell133'
		CreateFromExternalTriSurfMesh_plyFormat('D:/MyDataSets/TriPolyMesh_ply/chineseLion.ply');
	case 12 %%unavailable yet
		SetElement('Shell133'); %% 'Shell133'
		CreateFromExternalTriSurfMesh_objFormat('D:/MyDataSets/TriPolyGraph_obj/58009_sf.obj');
	case 13 %%unavailable yet
		SetElement('Shell144'); %% 'Shell144'
		CreateFromExternalQuadSurfMesh_meshFormat('D:/MyDataSets/QuadSurfMesh_mesh/3_octa-flower.mesh');
	case 14 
% 		SetElement('Beam123'); %% 'Truss122', 'Truss123', 'Beam122', 'Beam123'
		CreateFrameFromExternalArbitraryMesh('D:\BaiduSyncdisk\MyDataSets\frame_data\cantilever_3_beam.frame');		
	otherwise
		error('Unsupported Modeling Option!');
end
disp(['Create FEA Model Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
ShowBoundaryCondition();

%%3. (Interactively) Apply For Boundary Condition
%% ...
%% ...


