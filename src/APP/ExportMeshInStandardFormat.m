function ExportMeshInStandardFormat(nameFormat)
	global outPath_;
	global eleType_;
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global nodState_;
	
	if ~(strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144') || ...
			strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')), return; end
	
	switch eleType_.eleName
		case 'Shell133'
			switch nameFormat
				case '.ply'
					fileName = strcat(outPath_, 'exportedMesh.ply');
					fid = fopen(fileName, 'w');
					fprintf(fid, '%s\n', 'ply');
					fprintf(fid, '%s %s', 'format ascii'); fprintf(fid, '%.1f\n', 1.0);
					fprintf(fid, '%s %s', 'element vertex'); fprintf(fid, ' %d\n', numNodes_);
					fprintf(fid, '%s %s %s', 'property float x'); fprintf(fid, '\n');
					fprintf(fid, '%s %s %s', 'property float y'); fprintf(fid, '\n'); 
					fprintf(fid, '%s %s %s', 'property float z'); fprintf(fid, '\n');
					fprintf(fid, '%s %s', 'element face'); fprintf(fid, ' %d\n', numEles_);
					fprintf(fid, '%s %s %s %s %s', 'property list uchar uint vertex_indices'); fprintf(fid, '\n');
					fprintf(fid, '%s\n', 'end_header');
					fprintf(fid, '%.6f %.6f %.6f\n', nodeCoords_');
					fprintf(fid, '%d %d %d %d\n', [repmat(3,size(eNodMat_,1),1) eNodMat_-1]');						
				case '.obj'
					fileName = strcat(outPath_, 'exportedMesh.obj');
					fid = fopen(fileName, 'w');
					for ii=1:size(nodeCoords_,1)
						fprintf(fid, '%s ', 'v');
						fprintf(fid, '%.6f %.6f %.6f\n', nodeCoords_(ii,:));
					end
					for ii=1:size(eNodMat_,1)
						fprintf(fid, '%s ', 'f');
						fprintf(fid, '%d %d %d\n', eNodMat_(ii,:));
					end					
				otherwise
					error('Un-supported input!');
			end
		case 'Shell144'
			switch nameFormat
				case '.mesh'
					fileName = strcat(outPath_, 'exportedMesh.mesh');
					fid = fopen(fileName, 'w');
					%%header
					fprintf(fid, '%s ', 'MeshVersionFormatted');
					fprintf(fid, '%d\n', 1);
					fprintf(fid, '%s ', 'Dimension'); 
					fprintf(fid, '%d\n', 3);
					fprintf(fid, '%s ', 'Vertices');
					fprintf(fid, '%d\n', numNodes_);
					%%nodes
					fprintf(fid, '%.6e %.6e %.6e %d\n', [nodeCoords_ zeros(numNodes_,1)]');
					%%Cells
					fprintf(fid, '%s ', 'Quadra');
					fprintf(fid, '%d \n', numEles_);
					fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ zeros(numEles_,1)]');
					fprintf(fid, '%s', 'End');					
				case '.obj'
					fileName = strcat(outPath_, 'exportedMesh.obj');
					fid = fopen(fileName, 'w');
					for ii=1:size(nodeCoords_,1)
						fprintf(fid, '%s ', 'v');
						fprintf(fid, '%.6f %.6f %.6f\n', nodeCoords_(ii,:));
					end
					for ii=1:size(eNodMat_,1)
						fprintf(fid, '%s ', 'f');
						fprintf(fid, '%d %d %d %d\n', eNodMat_(ii,:));
					end						
				otherwise
					error('Un-supported input!');
			end			
		case 'Solid144'
			switch nameFormat
				case '.mesh'
					fileName = strcat(outPath_, 'exportedMesh.mesh');
					fid = fopen(fileName, 'w');
					%%header
					fprintf(fid, '%s ', 'MeshVersionFormatted');
					fprintf(fid, '%d\n', 1);
					fprintf(fid, '%s ', 'Dimension'); 
					fprintf(fid, '%d\n', 3);
					fprintf(fid, '%s ', 'Vertices');
					fprintf(fid, '%d\n', numNodes_);
					%%nodes
					fprintf(fid, '%.6e %.6e %.6e %d\n', [nodeCoords_ zeros(numNodes_,1)]');
					%%Cells
					fprintf(fid, '%s ', 'Tetrahedra');
					fprintf(fid, '%d \n', numEles_*4);
					fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ zeros(numEles_,1)]');
					fprintf(fid, '%s', 'End');					
				otherwise
					error('Un-supported input!');
			end			
		case 'Solid188'
			switch nameFormat
				case '.mesh'
					fileName = strcat(outPath_, 'exportedMesh.mesh');
					fid = fopen(fileName, 'w');
					%%header
					fprintf(fid, '%s ', 'MeshVersionFormatted');
					fprintf(fid, '%d\n', 1);
					fprintf(fid, '%s ', 'Dimension'); 
					fprintf(fid, '%d\n', 3);
					fprintf(fid, '%s ', 'Vertices');
					fprintf(fid, '%d\n', numNodes_);
					%%nodes
					fprintf(fid, '%.6e %.6e %.6e %d\n', [nodeCoords_ zeros(numNodes_,1)]');
					%%Cells
					fprintf(fid, '%s ', 'Hexahedra');
					fprintf(fid, '%d \n', numEles_);
					fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [eNodMat_ zeros(numEles_,1)]');
					fprintf(fid, '%s', 'End');					
				case '.vtk'
					fileName = strcat(outPath_, 'exportedMesh.vtk');
					fid = fopen(fileName, 'w');
					%%header
					fprintf(fid, '%s %s %s %s', '# vtk DataFile Version');
					fprintf(fid, '%.1f\n', 3.0);
					fprintf(fid, '%s %s', 'Volume mesh'); fprintf(fid, '\n');
					fprintf(fid, '%s \n', 'ASCII');
					fprintf(fid, '%s %s', 'DATASET UNSTRUCTURED_GRID'); fprintf(fid, '\n');
					fprintf(fid, '%s', 'POINTS');
					fprintf(fid, ' %d', numNodes_);
					fprintf(fid, ' %s \n', 'double');	
					%%nodes
					fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');
					%%Cells
					fprintf(fid, '%s', 'CELLS');
					fprintf(fid, ' %d %d\n', [numEles_ 9*numEles_]);
					fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [8*ones(numEles_,1) eNodMat_-1]');
					%%cell type
					fprintf(fid, '%s', 'CELL_TYPES');
					fprintf(fid, ' %d\n', numEles_);
					fprintf(fid, ' %d\n', 12*ones(1, numEles_));
					%%node positions
					fprintf(fid, '%s', 'POINT_DATA'); 
					fprintf(fid, ' %d\n', numNodes_);
					fprintf(fid, '%s %s %s', 'SCALARS fixed int'); fprintf(fid, '\n');
					fprintf(fid, '%s %s', 'LOOKUP_TABLE default'); fprintf(fid, '\n');
					fprintf(fid, ' %d\n', nodState_');					
				otherwise
					error('Un-supported input!');
			end		
	end
	fclose(fid);
end