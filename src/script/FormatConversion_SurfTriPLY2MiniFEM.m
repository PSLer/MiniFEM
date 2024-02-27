%%Convert the Surface Tri-mesh file in standard .ply format into the tailored format .MiniFEM format
clear all; clc;

ifileName = 'D:\BaiduSyncdisk\MyDataSets\TriSurfMesh_ply\3002.ply';
oFileName = '..\..\out\Data4MiniFEM.MiniFEM';

%% Read
fid = fopen(ifileName, 'r');
text_ply = fscanf(fid, '%s', 1);
text_formatascii1.0 = fscanf(fid, '%s %s %s', 3); 
text_elementvertex = fscanf(fid, '%s %s', 2);
numNodes_ = fscanf(fid, '%d', 1);
text_propertyfloatx = fscanf(fid, '%s %s %s', 3); 
text_propertyfloaty = fscanf(fid, '%s %s %s', 3); 
text_propertyfloatz = fscanf(fid, '%s %s %s', 3);
text_elementface = fscanf(fid, '%s %s', 2);
numEles_ = fscanf(fid, '%d', 1);
text_propertylistucharuintvertex_indices = fscanf(fid, '%s %s %s %s %s', 5);
text_end_header = fscanf(fid, '%s', 1);
nodeCoords_ = fscanf(fid,'%f %f %f',[3,numNodes_])'; 
eNodMat_ = fscanf(fid,'%d %d %d %d',[4,numEles_]); 
eNodMat_(1,:) = []; 
eNodMat_ = eNodMat_' + 1;
fclose(fid);
numNodes_ = size(nodeCoords_,1); 
numEles_ = size(eNodMat_,1);
materialIndicatorField_ = ones(numEles_,1);

%% Write
fid = fopen(oFileName, 'w');
fprintf(fid, '%s ', 'Version');
fprintf(fid, '%.1f\n', 2.0);
fprintf(fid, '%s %s ', 'Shell Tri');
fprintf(fid, '%d\n', 1);

fprintf(fid, '%s ', 'Vertices:');
fprintf(fid, '%d\n', numNodes_);		
fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

fprintf(fid, '%s ', 'Elements:');
fprintf(fid, '%d \n', numEles_);
fprintf(fid, '%d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

fprintf(fid, '%s %s ', 'Node Forces:'); 
fprintf(fid, '%d\n',0);
fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', 0);
fclose(fid);

disp('......Done with Format Conversion!');