%%Convert the Surface Tri-mesh file in standard .obj format into the tailored format .MiniFEM format
clear all; clc;

ifileName = 'D:\BaiduSyncdisk\MyDataSets\TriSurfMesh_obj\deformed_armadillo.obj';
oFileName = '..\..\out\Data4MiniFEM.MiniFEM';

%% Read
nodeCoords_ = []; eNodMat_ = [];
fid = fopen(ifileName, 'r');
while 1
	tline = fgetl(fid);
	if ~ischar(tline), break; end  % exit at end of file 
	ln = sscanf(tline,'%s',1); % line type 
	switch ln
		case 'v'
			nodeCoords_(end+1,1:3) = sscanf(tline(2:end), '%e')';
		case 'f'
			eNodMat_(end+1,1:3) = sscanf(tline(2:end), '%d')';
	end
end
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