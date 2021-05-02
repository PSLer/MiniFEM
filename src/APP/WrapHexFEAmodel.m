function WrapHexFEAmodel()
	global eleType_;
	global meshType_;
	global outPath_;
	global numEles_; global eNodMat_; 
	global numNodes_; global nodeCoords_;
	global fixingCond_; global loadingCond_;
	global boundaryNodes_;

	if ~strcmp(eleType_.eleName, 'Solid188')
		error('Only Works with 3D Solid188 Elements!');
	end
	if strcmp(meshType_, 'Cartesian')
		warning('Cartesian Mesh. Recomend to WrapVoxelFEAmodel(). Enter to Continue!'); pause;
	end
	
	fileName = strcat(outPath_, 'wrappedHexFEAmodel.vtk');
	fid = fopen(fileName, 'w');	
	%%write in .vtk style	
	%%1.1 file header (ignore 'volume mesh' for 2D)
	fprintf(fid, '%s %s %s %s', '# vtk DataFile Version');
	fprintf(fid, '%.1f\n', 3.0);
	fprintf(fid, '%s %s', 'Volume mesh'); fprintf(fid, '\n');
	fprintf(fid, '%s \n', 'ASCII');
	fprintf(fid, '%s %s', 'DATASET UNSTRUCTURED_GRID'); fprintf(fid, '\n');
	fprintf(fid, '%s', 'POINTS');
	fprintf(fid, ' %d', numNodes_);
	fprintf(fid, ' %s \n', 'double');
	
	%%1.2 node coordinates
	fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');
	%%1.3 Cells
	fprintf(fid, '%s', 'CELLS');
	fprintf(fid, ' %d %d\n', [numEles_ 9*numEles_]);
	fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [8*ones(numEles_,1) eNodMat_-1]');
	%%1.4 cell type
	fprintf(fid, '%s', 'CELL_TYPES');
	fprintf(fid, ' %d\n', numEles_);
	fprintf(fid, ' %d\n', 12*ones(1, numEles_));
	%%1.5 node positions
	fprintf(fid, '%s', 'POINT_DATA'); 
	fprintf(fid, ' %d\n', numNodes_);
	fprintf(fid, '%s %s %s', 'SCALARS fixed int'); fprintf(fid, '\n');
	fprintf(fid, '%s %s', 'LOOKUP_TABLE default'); fprintf(fid, '\n');
	tmp = zeros(numNodes_,1); tmp(boundaryNodes_) = 1;
	fprintf(fid, ' %d\n', tmp');
	%%1.6 boundary condition
	fprintf(fid, '%s %s ', 'fixed position:'); fprintf(fid, '%d\n', length(fixingCond_));
	if ~isempty(fixingCond_)
		fprintf(fid, '%d\n', fixingCond_-1);						
	end
	fprintf(fid, '%s %s ', 'loading condition:'); fprintf(fid, '%d\n', size(loadingCond_,1));
	if ~isempty(loadingCond_)
		fprintf(fid, '%d %.6f %.6f %.6f\n', [loadingCond_(:,1)-1 loadingCond_(:,2:end)]');
	end	
	fclose(fid);
end