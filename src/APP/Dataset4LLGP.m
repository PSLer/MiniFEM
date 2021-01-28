function Dataset4LLGP(opt)
	%0==opt: single stress field under current loading condition
	%1==opt: multiple stress fields under varying loading direction
	global domainType_;
	global outPath_;
	global structureState_;
	global U_;
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global nodesOutline_;
	global cartesianStressField_;
	global nodeLoadVec_; global fixedNodes_;
	
	%%1. write mesh info in .vtk 3.0
	%%1.1 file header (ignore 'volume mesh' for 2D)
	fileName = strcat(outPath_, '/stressField.vtk');
	fid = fopen(fileName, 'w');				
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
			%%1.2. node coordinates
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');
			%%1.3. Cells
			fprintf(fid, '%s', 'CELLS');
			fprintf(fid, ' %d %d\n', [numEles_ 5*numEles_]);
			fprintf(fid, '%d %d %d %d %d\n', [4*ones(numEles_,1) eNodMat_-1]');
			%%1.4. cell type
			fprintf(fid, '%s', 'CELL_TYPES');
			fprintf(fid, ' %d\n', numEles_);
			fprintf(fid, ' %d\n', 4*ones(1, numEles_));
			%%1.5. node positions
			fprintf(fid, '%s', 'POINT_DATA'); 
			fprintf(fid, ' %d\n', numNodes_);
			fprintf(fid, '%s %s %s', 'SCALARS fixed int'); fprintf(fid, '\n');
			fprintf(fid, '%s %s', 'LOOKUP_TABLE default'); fprintf(fid, '\n');
			tmp = zeros(numNodes_,1); tmp(nodesOutline_) = 1;
			fprintf(fid, ' %d\n', tmp');					
		case '3D'
			%%1.2. node coordinates
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');
			%%1.3. Cells
			fprintf(fid, '%s', 'CELLS');
			fprintf(fid, ' %d %d\n', [numEles_ 9*numEles_]);
			fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [8*ones(numEles_,1) eNodMat_-1]');
			%%1.4. cell type
			fprintf(fid, '%s', 'CELL_TYPES');
			fprintf(fid, ' %d\n', numEles_);
			fprintf(fid, ' %d\n', 12*ones(1, numEles_));
			%%1.5. node positions
			fprintf(fid, '%s', 'POINT_DATA'); 
			fprintf(fid, ' %d\n', numNodes_);
			fprintf(fid, '%s %s %s', 'SCALARS fixed int'); fprintf(fid, '\n');
			fprintf(fid, '%s %s', 'LOOKUP_TABLE default'); fprintf(fid, '\n');
			tmp = zeros(numNodes_,1); tmp(nodesOutline_) = 1;
			fprintf(fid, ' %d\n', tmp');				
	end	
	
	%%2. get stress field
    tmp = zeros(size(nodeLoadVec_)); tmp(:,1) = 1;
	switch opt
		case 0
			%%2.1 compute
			Deformation('T');
			cartesianStressField_ = ComputeCartesianStress(U_);
			%%2.2 write
			fprintf(fid, '%s %s %s %s ', 'Number of Stress Fields:'); fprintf(fid, '%d\n', 1);
			switch domainType_
				case '2D'
					fprintf(fid, '%s %s ', 'Node Forces:'); fprintf(fid, '%d\n', size(nodeLoadVec_,1));
                    fprintf(fid, '%d %.6f %6f\n', [nodeLoadVec_(:,1)-1 nodeLoadVec_(:,2:end)]');
					fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', length(fixedNodes_));
					fprintf(fid, '%d\n', fixedNodes_-1);					
					fprintf(fid, '%s %s', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);		
					fprintf(fid, '%.6e %.6e %6e\n', cartesianStressField_');
				case '3D'
					fprintf(fid, '%s %s ', 'Node Forces:'); fprintf(fid, '%d\n', size(nodeLoadVec_,1));
                    fprintf(fid, '%d %.6f %6f %6f\n', [nodeLoadVec_(:,1)-1 nodeLoadVec_(:,2:end)]');
					fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', length(fixedNodes_));
					fprintf(fid, '%d\n', fixedNodes_-1);						
					fprintf(fid, '%s %s', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);
					fprintf(fid, '%.6e %.6e %6e %.6e %.6e %6e\n', cartesianStressField_');
			end	
		case 1
			if strcmp(domainType_, '2D')
				global loadingCond_;
				varyRange = 180;
				loadVaryStep = 20;
				amplitudes = -ones(size(loadingCond_,1),1);
				amplitudes = amplitudes/norm(amplitudes);
				fprintf(fid, '%s %s %s %s ', 'Number of Stress fields:');
				fprintf(fid, '%d\n', floor(varyRange/loadVaryStep)+1);
                
				for ii=0:loadVaryStep:varyRange
					loadingCond_(:,end-1) = amplitudes*sin(ii/180*pi);
					loadingCond_(:,end) = amplitudes*cos(ii/180*pi);
					ApplyLoads();
					%%2.1 compute
					U_ = []; Deformation();
					cartesianStressField_ = ComputeCartesianStress(U_);					
					%%2.2 write														
					switch domainType_
						case '2D'
							fprintf(fid, '%s %s ', 'Node Forces:'); fprintf(fid, '%d\n', size(nodeLoadVec_,1));
                            fprintf(fid, '%d %.6f %6f\n', [nodeLoadVec_(:,1)-1 nodeLoadVec_(:,2:end)]');
							fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', length(fixedNodes_));
							fprintf(fid, '%d\n', fixedNodes_-1);							
							fprintf(fid, '%s %s ', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);			
							fprintf(fid, '%.6f %.6f %6f\n', cartesianStressField_');
						case '3D'
							fprintf(fid, '%s %s ', 'Node Forces:'); fprintf(fid, '%d\n', size(nodeLoadVec_,1));
                            fprintf(fid, '%d %.6f %6f %6f\n', [nodeLoadVec_(:,1)-1 nodeLoadVec_(:,2:end)]');
							fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', length(fixedNodes_));
							fprintf(fid, '%d\n', fixedNodes_-1);							
							fprintf(fid, '%s %s ', 'Cartesian Stress:'); fprintf(fid, '%d\n', numNodes_);
							fprintf(fid, '%.6f %.6f %6f %.6f %.6f %6f\n', cartesianStressField_');
					end	 
				end
			end
			
		otherwise
			error('Wrong input for dataset generating!')
	end
	fclose(fid);
end