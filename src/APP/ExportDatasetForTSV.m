function ExportDatasetForTSV(varargin)
	global eleType_;
	global meshType_;
	global outPath_;
	global cartesianStressField_;
	if ~(strcmp(eleType_.eleName, 'Plane144') || strcmp(eleType_.eleName, 'Solid188'))
		error('Only Works with 2D Plane144 and 3D Solid188 Elements!');
	end
	if isempty(cartesianStressField_)
		warning('No Cartesian Stress Available!'); return;
	end
	
	if 0==nargin
		if strcmp(meshType_, 'Any')
			fileName = strcat(outPath_, 'dataset_TSV.vtk');
			ExportDataSimulatedOnUnstructuredMesh_vtk(fileName);
		else
			fileName = strcat(outPath_, 'dataset_TSV.carti');
			ExportDataSimulatedOnCartesianMesh_carti(fileName);
		end
	elseif 1==nargin
		switch varargin{1}
			case 'vtk'
				fileName = strcat(outPath_, 'dataset_TSV.vtk');
				ExportDataSimulatedOnUnstructuredMesh_vtk(fileName);
			case 'mesh'
				fileName = strcat(outPath_, 'dataset_TSV.mesh');
				ExportDataSimulatedOnUnstructuredMesh_mesh(fileName);
			otherwise
				error('Wrong Input!');
		end
	else
		error('Wrong Input!');
	end
end

function ExportDataSimulatedOnCartesianMesh_carti(fileName)
	global eleType_;
	global nelx_; 
    global nely_; 
    global nelz_;
	global boundingBox_;
	global numEles_; 
	global numNodes_; 
	global carEleMapBack_;
	global carNodMapBack_; 	
	global fixingCond_; global loadingCond_;
	global cartesianStressField_;

	fid = fopen(fileName, 'w');
	fprintf(fid, '%s %s', 'DATASET CARTESIAN_GRID'); 
	fprintf(fid, '\n');
	fprintf(fid, '%s', 'Resolution:');
	if strcmp(eleType_.eleName, 'Plane144')
		%%2.2 mesh description
		fprintf(fid, ' %d %d\n', [nelx_ nely_]);
		fprintf(fid, '%s', 'LowerBound:');
		fprintf(fid, ' %.6f %.6f\n', boundingBox_(1,:));
		fprintf(fid, '%s', 'UpperBound:');
		fprintf(fid, ' %.6f %.6f\n', boundingBox_(2,:));	
		fprintf(fid, '%s', 'ELEMENTS');
		fprintf(fid, ' %d', numEles_);
		fprintf(fid, ' %s \n', 'int');	
		fprintf(fid, '%d\n', carEleMapBack_-1);
		%%2.2 Cartesian Stress 
		fprintf(fid, '%s %s %s %s ', 'Number of Stress Fields:');
		fprintf(fid, '%d\n', 1);
		fprintf(fid, '%s %s ', 'Node Forces:'); 
		fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f\n', [double(carNodMapBack_(loadingCond_(:,1)))-1 loadingCond_(:,2:end)]');
		end
		fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', carNodMapBack_(fixingCond_(:,1))-1);
		end
		fprintf(fid, '%s %s ', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);
		fprintf(fid, '%.6e %.6e %.6e\n', cartesianStressField_');				
	else
		%%2.2 mesh description
		fprintf(fid, ' %d %d %d\n', [nelx_ nely_ nelz_]);
		fprintf(fid, '%s', 'LowerBound:');
		fprintf(fid, ' %.6f %.6f %.6f\n', boundingBox_(1,:));
		fprintf(fid, '%s', 'UpperBound:');
		fprintf(fid, ' %.6f %.6f %.6f\n', boundingBox_(2,:));	
		fprintf(fid, '%s', 'ELEMENTS');
		fprintf(fid, ' %d', numEles_);
		fprintf(fid, ' %s \n', 'int');	
		fprintf(fid, '%d\n', carEleMapBack_-1);
		%%2.2 Cartesian Stress 
		fprintf(fid, '%s %s %s %s ', 'Number of Stress Fields:');
		fprintf(fid, '%d\n', 1);
		fprintf(fid, '%s %s ', 'Node Forces:'); 
		fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f %.6f\n', [double(carNodMapBack_(loadingCond_(:,1)))-1 loadingCond_(:,2:end)]');
		end
		fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', carNodMapBack_(fixingCond_(:,1))-1);
		end
		fprintf(fid, '%s %s ', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);
		fprintf(fid, '%.6e %.6e %.6e %.6e %.6e %.6e\n', cartesianStressField_');				
	end	
	fclose(fid);
end

function ExportDataSimulatedOnUnstructuredMesh_vtk(fileName)
	global eleType_;
	global numEles_; 
    global eNodMat_; 
	global numNodes_; 
    global nodeCoords_; 	
	global fixingCond_; 
    global loadingCond_;
	global boundaryNodes_;
	global cartesianStressField_;
	
	fid = fopen(fileName, 'w');
	%%write in .vtk style	
	%%1.1 file header (ignore 'volume mesh' for 2D)
	fprintf(fid, '%s %s %s %s', '# vtk DataFile Version');
	fprintf(fid, '%.1f\n', 3.0);
	fprintf(fid, '%s %s', 'Volume mesh'); 
	fprintf(fid, '\n');
	fprintf(fid, '%s \n', 'ASCII');
	fprintf(fid, '%s %s', 'DATASET UNSTRUCTURED_GRID'); 
	fprintf(fid, '\n');
	fprintf(fid, '%s', 'POINTS');
	fprintf(fid, ' %d', numNodes_);
	fprintf(fid, ' %s \n', 'double');
	if strcmp(eleType_.eleName, 'Plane144')
		%%1.2 node coordinates
		fprintf(fid, '%.6e %.6e\n', nodeCoords_');
		%%1.3 Cells
		fprintf(fid, '%s', 'CELLS');
		fprintf(fid, ' %d %d\n', [numEles_ 5*numEles_]);
		fprintf(fid, '%d %d %d %d %d\n', [4*ones(numEles_,1) eNodMat_-1]');
		%%1.4 cell type
		fprintf(fid, '%s', 'CELL_TYPES');
		fprintf(fid, ' %d\n', numEles_);
		fprintf(fid, ' %d\n', 4*ones(1, numEles_));
		%%1.5 node positions
		fprintf(fid, '%s', 'POINT_DATA'); 
		fprintf(fid, ' %d\n', numNodes_);
		fprintf(fid, '%s %s %s', 'SCALARS fixed int'); fprintf(fid, '\n');
		fprintf(fid, '%s %s', 'LOOKUP_TABLE default'); fprintf(fid, '\n');
		tmp = zeros(numNodes_,1); tmp(boundaryNodes_) = 1;
		fprintf(fid, ' %d\n', tmp');
		%%1.6 Cartesian Stress
		fprintf(fid, '%s %s %s %s ', 'Number of Stress Fields:'); fprintf(fid, '%d\n', 1);
		fprintf(fid, '%s %s ', 'Node Forces:'); fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f\n', [loadingCond_(:,1)-1 loadingCond_(:,2:end)]');
		end        
		fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', fixingCond_(:,1)-1);
		end								
		fprintf(fid, '%s %s', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);		
		fprintf(fid, '%.6e %.6e %.6e\n', cartesianStressField_');			
	else
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
		%%1.6 Cartesian Stress
		fprintf(fid, '%s %s %s %s ', 'Number of Stress Fields:'); fprintf(fid, '%d\n', 1);
		fprintf(fid, '%s %s ', 'Node Forces:'); fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f %.6f\n', [loadingCond_(:,1)-1 loadingCond_(:,2:end)]');
		end
		fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', fixingCond_(:,1)-1);						
		end
		fprintf(fid, '%s %s', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);
		fprintf(fid, '%.6e %.6e %.6e %.6e %.6e %.6e\n', cartesianStressField_');			
	end	
	fclose(fid);	
end

function ExportDataSimulatedOnUnstructuredMesh_mesh(fileName)
	global eleType_;
	global numEles_; 
	global eNodMat_; 
	global numNodes_; 
	global nodeCoords_;	
	global fixingCond_; 
	global loadingCond_;
	global cartesianStressField_;
	
	fid = fopen(fileName, 'w');
	%%write in .mesh style	
	%%1.1 file header (ignore 'volume mesh' for 2D)
	fprintf(fid, '%s ', 'MeshVersionFormatted');
	fprintf(fid, '%d\n', 1);
	fprintf(fid, '%s ', 'Dimension'); 
	if strcmp(eleType_.eleName, 'Plane144')
		%%1.2 node coordinates
		fprintf(fid, '%d\n', 2);
		fprintf(fid, '%s ', 'Vertices');
		fprintf(fid, '%d\n', numNodes_);		
		fprintf(fid, '%.6e %.6e %d\n', [nodeCoords_ zeros(numNodes_,1)]');
		%%1.3 Cells
		fprintf(fid, '%s ', 'Hexahedra');
		fprintf(fid, '%d \n', numEles_);
		fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ zeros(numEles_,1)]');
		fprintf(fid, '%s', 'End');
		%%1.4 Cartesian Stress
		fprintf(fid, '%s %s %s %s ', 'Number of Stress Fields:'); fprintf(fid, '%d\n', 1);
		fprintf(fid, '%s %s ', 'Node Forces:'); fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f\n', [loadingCond_(:,1)-1 loadingCond_(:,2:end)]');
		end        
		fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', fixingCond_(:,1)-1);
		end								
		fprintf(fid, '%s %s', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);		
		fprintf(fid, '%.6e %.6e %.6e\n', cartesianStressField_');			
	else
		%%1.2 node coordinates
		fprintf(fid, '%d\n', 3);
		fprintf(fid, '%s ', 'Vertices');
		fprintf(fid, '%d\n', numNodes_);		
		fprintf(fid, '%.6e %.6e %.6e %d\n', [nodeCoords_ zeros(numNodes_,1)]');
		%%1.3 Cells
		fprintf(fid, '%s ', 'Hexahedra');
		fprintf(fid, '%d \n', numEles_);
		fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [eNodMat_ zeros(numEles_,1)]');
		fprintf(fid, '%s', 'End');
		%%1.4 Cartesian Stress
		fprintf(fid, '%s %s %s %s ', 'Number of Stress Fields:'); fprintf(fid, '%d\n', 1);
		fprintf(fid, '%s %s ', 'Node Forces:'); fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f %.6f\n', [loadingCond_(:,1)-1 loadingCond_(:,2:end)]');
		end
		fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', fixingCond_(:,1)-1);						
		end
		fprintf(fid, '%s %s', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);
		fprintf(fid, '%.6e %.6e %.6e %.6e %.6e %.6e\n', cartesianStressField_');			
	end	
	fclose(fid);	
end