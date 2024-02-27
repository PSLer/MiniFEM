%%Convert the Hex-mesh file in standard .vtk format into the tailored format .MiniFEM format
clear all; clc;

ifileName = 'D:\BaiduSyncdisk\MyDataSets\HexMesh_vtk\3002_hexa.vtk';
oFileName = '..\..\out\Data4MiniFEM.MiniFEM';

%%1. read file header
fid = fopen(ifileName, 'r');
fgetl(fid); fgetl(fid); fgetl(fid); fgetl(fid);

%%2. read node coordinates
tmp = fscanf(fid, '%s', 1); 
numNodes_ = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
nodeCoords_ = fscanf(fid, '%f %f %f', [3, numNodes_]); nodeCoords_ = nodeCoords_'; 

%%3. read element
tmp = fscanf(fid, '%s', 1);
numEles_ = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%d', 1);
eNodMat_ = fscanf(fid, '%d %d %d %d %d %d %d %d %d', [9, numEles_]); 
eNodMat_ = eNodMat_'; eNodMat_(:,1) = []; eNodMat_ = eNodMat_+1; 

%%4. read element type 
tmp = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%d', 1);
eleState_ = fscanf(fid, '%d', [1 tmp])'; 

%%5. identify node type (interior or not)
tmp = fscanf(fid, '%s %s', 2);
tmp = fscanf(fid, '%s %s %s', 3);
tmp = fscanf(fid, '%s %s', 2);
nodState_ = fscanf(fid, '%d', [1 numNodes_])'; 	
fclose(fid);

materialIndicatorField_ = ones(numEles_,1);

%% Write
fid = fopen(oFileName, 'w');
fprintf(fid, '%s ', 'Version');
fprintf(fid, '%.1f\n', 2.0);
fprintf(fid, '%s %s ', 'Solid Hex');
fprintf(fid, '%d\n', 1);

fprintf(fid, '%s ', 'Vertices:');
fprintf(fid, '%d\n', numNodes_);		
fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

fprintf(fid, '%s ', 'Elements:');
fprintf(fid, '%d \n', numEles_);
fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

fprintf(fid, '%s %s ', 'Node Forces:'); 
fprintf(fid, '%d\n',0);
fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', 0);
fclose(fid);

disp('......Done with Format Conversion!');