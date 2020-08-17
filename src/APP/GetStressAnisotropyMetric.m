function GetStressAnisotropyMetric()
	global domainType_;
    global outPath_;
	global numNodes_;	
	global nodeCoords_;
	global numEles_;
	global eNodMat_;	
	global nodesOutline_;
	global principalStressField_;
	if strcmp(domainType_, '2D'), error('Only supports 3D situation!'); end
	
 	PrincipalStress();

	%%1. output file header		
	fileName = strcat(outPath_, '/StressAnisotropyMetric3D.vtk');
	fid = fopen(fileName, 'w');				
	fprintf(fid, '%s %s %s %s', '# vtk DataFile Version');
	fprintf(fid, '%.1f\n', 3.0);
	fprintf(fid, '%s %s', 'Volume mesh'); fprintf(fid, '\n');
	fprintf(fid, '%s \n', 'ASCII');
	fprintf(fid, '%s %s', 'DATASET UNSTRUCTURED_GRID'); fprintf(fid, '\n');
	fprintf(fid, '%s', 'POINTS');
	fprintf(fid, ' %d', numNodes_);
	fprintf(fid, ' %s \n', 'double');

	%%2. node coordinates
	fprintf(fid, '%.6f %.6f %.6f\n', nodeCoords_');	
	
	%%3. Cells
	fprintf(fid, '%s', 'CELLS');
	fprintf(fid, ' %d %d\n', [numEles_ 9*numEles_]);
	fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [8*ones(numEles_,1) eNodMat_-1]');

	%%4. cell type
	fprintf(fid, '%s', 'CELL_TYPES');
	fprintf(fid, ' %d\n', numEles_);
	fprintf(fid, ' %d\n', 12*ones(1, numEles_));

	%%5. node positions
	fprintf(fid, '%s', 'POINT_DATA'); 
	fprintf(fid, ' %d\n', numNodes_);
	fprintf(fid, '%s %s %s', 'SCALARS fixed int'); fprintf(fid, '\n');
	fprintf(fid, '%s %s', 'LOOKUP_TABLE default'); fprintf(fid, '\n');
	tmp = zeros(numNodes_,1); tmp(nodesOutline_) = 1;
	fprintf(fid, ' %d\n', tmp');

	%%6. node deformation
	fprintf(fid, '%s', 'AnisotropyMetric'); 
	fprintf(fid, ' %d\n', numNodes_);
	fprintf(fid, '%.6e\n', log10(abs(principalStressField_(:,9)./principalStressField_(:,1))));						
	
	fclose(fid);
end