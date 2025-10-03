%%Convert the Surface Quad-mesh file in standard .mesh format into the tailored format .MiniFEM format
clear all; clc;

ifileName = 'D:\wSpace\Paper_2025_TSVshell\log\20251002_saddleSurface\saddleSurface_quad.mesh';
oFileName = '..\..\out\Data4MiniFEM.MiniFEM';

%% Read
fid = fopen(ifileName, 'r');
fgetl(fid); tmp = fscanf(fid, '%s', 1); tmp = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1); 
numNodes_ = fscanf(fid, '%d', 1);
nodeCoords_ = fscanf(fid, '%f %f %f  %f', [4, numNodes_]); 
nodeCoords_ = nodeCoords_'; nodeCoords_(:,4) = [];
tmp = fscanf(fid, '%s', 1);
numEles_ = fscanf(fid, '%d', 1);
eNodMat_ = fscanf(fid, '%d %d %d %d %d', [5, numEles_]); 
eNodMat_ = eNodMat_'; eNodMat_(:,end) = []; 
fclose(fid);

materialIndicatorField_ = ones(numEles_,1);
shellThicknessList_ = ones(numEles_,1) .* 0.02;

%% Write
fid = fopen(oFileName, 'w');
fprintf(fid, '%s ', 'Version');
fprintf(fid, '%.1f\n', 2.0);
fprintf(fid, '%s %s ', 'Shell Quad');
fprintf(fid, '%d\n', 1);

fprintf(fid, '%s ', 'Vertices:');
fprintf(fid, '%d\n', numNodes_);		
fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

fprintf(fid, '%s ', 'Elements:');
fprintf(fid, '%d \n', numEles_);
fprintf(fid, '%d %d %d %d %d %16.6e\n', [eNodMat_ materialIndicatorField_ shellThicknessList_]');

fprintf(fid, '%s %s ', 'Node Forces:'); 
fprintf(fid, '%d\n',0);
fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', 0);
fclose(fid);

disp('......Done with Format Conversion!');