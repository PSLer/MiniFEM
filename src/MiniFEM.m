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
SetMaterialProperty('Unit'); %% 'Unit', 'Steel', 'Aluminium'

%%2. Create Geometrical Model (Pick the desirable one from the following options)
tStart = tic;
ModelingOpt = 0;
switch ModelingOpt
	case 0 %%Unified Mesh Format (.stress v2) for arbitrary mesh (Quad, Tri, Hex, Tet)
		CreateFromArbitraryMesh_unifiedStressFormat('D:\wSpace\MeshStructDesign\log\20240214_eva2D_1stRun\femur2D\femur2D_domain_Tri.stress');
	case 1	
		SetElement('Plane144'); %% 'Plane133' or 'Plane144'
		CreateRectangle([60, 30], [0 0; 1 0.5]);
	case 2
		SetElement('Solid188'); %% 'Solid188'
		CreateCuboid([40, 20, 20], [0 0 0; 1 0.5 0.5]);
	case 3
		SetElement('Solid188'); %% 'Plane144' or 'Solid188'
		CreateFromWrappedVoxelFEAmodel('D:\BaiduSyncdisk\MyDataSets\FEA_Models_voxel\femur3D\femur_R184.txt');	
	case 4
		SetElement('Solid188'); %% 'Plane144' or 'Solid188'
		CreateModelFromTopOpti('D:\wSpace\MeshStructDesign\log\20240216_XIfengTest\canti3D_3_R100/optimizedModel.topopti', 0.1);
	case 5
		SetElement('Solid188'); %% 'Solid188'
		CreateCartesianHexMeshFromTriFaceMesh_plyFormat('D:/MyDataSets/TriSurfMesh_ply/bird.ply', 256); 
	case 6
		SetElement('Solid188'); %% 'Solid188'
		CreateFromWrappedHexFEAmodel_vtkFormat('D:\wSpace\MeshStructDesign\log\20240126_evaluation3D\Fertility_Hex/wrappedHexFEAmodel.vtk');
	case 7
		SetElement('Solid188'); %% 'Solid188'
		CreateFromExternalHexMesh_vtkFormat('D:/MyDataSets/HexMesh_vtk/airplane1_hexa.vtk'); 
	case 8
		SetElement('Solid188'); %% 'Solid188'
		CreateFromExternalHexMesh_meshFormat('D:\wSpace\MeshStructDesign\log\20240213_eva3D_1stRun\femurHigh\HexDesign.mesh');
	case 9
		SetElement('Solid144'); %% 'Solid144'
		CreateFromExternalTetMesh_meshFormat('D:\wSpace\MeshStructDesign\data\spot_Dennis/spot_Dennis.mesh');
	case 10
		SetElement('Solid144'); %% 'Solid144'
		CreateFromWrappedTetFEAmodel_meshFormat('D:\wSpace\MeshStructDesign\log\20240213_eva3D_1stRun\femurHigh\Solid_Tet_FEA.mesh');		
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
		SetElement('Beam123'); %% 'Truss122', 'Truss123', 'Beam122', 'Beam123'
		CreateFrameFromExternalArbitraryMesh('D:\wSpace\MeshStructDesign\log\20240216_XIfengTest\femurHigh\JunXifeng\graphByXifeng.frame');		
	otherwise
		error('Unsupported Modeling Option!');
end
disp(['Create FEA Model Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
ShowBoundaryCondition();

%%3. (Interactively) Apply For Boundary Condition
%% ...
%% ...


