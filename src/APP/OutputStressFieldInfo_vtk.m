function OutputStressFieldInfo_vtk(fileName)
	global domainType_; global eleSize_;
	global numNodes_; global nodeCoords_; 
	global numEles_; global eNodMat_;
	global cartesianStressField_;
	global originalValidNodeIndex_;
	
	%%1. output file header
	meshInfoName = strcat(fileName, '_CSF_Info.vtk'); %%CSF -- cartesian stress field
	fid = fopen(meshInfoName, 'w');			
	fprintf(fid, '%s %s %s %s', '# vtk DataFile Version');
	fprintf(fid, '%.1f\n', 3.0);
	fprintf(fid, '%s %s', 'Volume mesh'); fprintf(fid, '\n');
	fprintf(fid, '%s \n', 'ASCII');
	fprintf(fid, '%s %s', 'DATASET UNSTRUCTURED_GRID'); fprintf(fid, '\n');
	fprintf(fid, '%s', 'POINTS');
	fprintf(fid, ' %d', numNodes_);
	fprintf(fid, ' %s \n', 'double');	
	switch domainType_
		case '2D'		
			%%2. node coordinates
			fprintf(fid, '%.6f %.6f\n', nodeCoords_');
			%%3. Cells
			fprintf(fid, '%s', 'CELLS');
			fprintf(fid, ' %d %d\n', [numEles_ 5*numEles_]);
			fprintf(fid, '%d %d %d %d %d\n', [4*ones(numEles_,1) eNodMat_-1]');
			%%4. original valid node indexs (in case the FEM model is from a cut process)
			fprintf(fid, '%s', 'Original_Valid_Node_Indices');
			fprintf(fid, ' %d\n', numNodes_);
			fprintf(fid, '%d\n', (originalValidNodeIndex_-1)');
			%%5. cartesian stress field
			fprintf(fid, '%s', 'Cartesian_Stress_Field');
			fprintf(fid, ' %d %d\n', [numNodes_ 3*numEles_]);
			fprintf(fid, '%.6f %.6f %.6f\n', cartesianStressField_'); %% [sigma_x sigma_y tau_xy] 
			fclose(fid);			
		case '3D'
			%%2. node coordinates
			fprintf(fid, '%.6f %.6f %.6f\n', nodeCoords_');
			%%3. Cells
			fprintf(fid, '%s', 'CELLS');
			fprintf(fid, ' %d %d\n', [numEles_ 9*numEles_]);
			fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [8*ones(numEles_,1) eNodMat_-1]');
			%%4. original valid node indexs (in case the FEM model is from a cut process)
			fprintf(fid, '%s', 'Original_Valid_Node_Indices');
			fprintf(fid, ' %d\n', numNodes_);
			fprintf(fid, '%d\n', (originalValidNodeIndex_-1)');		
			%%5. cartesian stress field
			fprintf(fid, '%s', 'Cartesian_Stress_Field');
			fprintf(fid, ' %d %d\n', [numNodes_ 6*numEles_]);			
			fprintf(fid, '%.6f %.6f %.6f %.6f %.6f %.6f\n', cartesianStressField_'); %% [sigma_x sigma_y tau_xy] 
			fclose(fid);				
	end
end