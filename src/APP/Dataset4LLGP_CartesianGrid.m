function Dataset4LLGP_CartesianGrid()
	global domainType_;
	global outPath_;
	global modelSource_;
	global nelx_; global nely_; global nelz_;
	global vtxLowerBound_; global vtxUpperBound_;
	global validElements_;
	global structureState_;
	global U_;
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global nodesOutline_;
	global cartesianStressField_;
	global nodeLoadVec_;
    
	%%1. write mesh info in .vtk
	%%1.1 file header (ignore 'volume mesh' for 2D)
	%fileName = '../../../MyDataSets/StressFields4LLGP/stressField.vtk';
	fileName = strcat(outPath_, '/stressField.vtk');
	fid = fopen(fileName, 'w');				
	fprintf(fid, '%s %s %s %s', '# vtk DataFile Version');
	fprintf(fid, '%.1f\n', 3.0);
	fprintf(fid, '%s %s', 'Volume mesh'); fprintf(fid, '\n');
	fprintf(fid, '%s \n', 'ASCII');
	fprintf(fid, '%s %s', 'DATASET CARTESIAN_GRID'); fprintf(fid, '\n');
	fprintf(fid, '%s', 'Resolution:');
	
	switch domainType_
		case '2D'
			fprintf(fid, ' %d %d\n', [nelx_ nely_]);
			fprintf(fid, '%s', 'LowerBound:');
			fprintf(fid, ' %f %f\n', [vtxLowerBound_]);
			fprintf(fid, '%s', 'UpperBound:');
			fprintf(fid, ' %f %f\n', [vtxUpperBound_]);	
			fprintf(fid, '%s', 'ELEMENTS');
			fprintf(fid, ' %d', numEles_);
			fprintf(fid, ' %s \n', 'int');	
			fprintf(fid, '%d\n', validElements_-1);	
			%%2.1 compute
			switch structureState_
				case 'STATIC'
					U_ = SolvingStaticFEM('printP_ON');
				case 'DYNAMIC'
					U_ = SolvingDynamicFEM('printP_ON');
			end
			cartesianStressField_ = ComputeCartesianStress(U_);
			Deformation('T',1);
			%%2.2 write
			tmp = zeros(size(nodeLoadVec_)); tmp(:,1) = 1;
			fprintf(fid, '%s %s %s %s', 'Number of Stress Fields');
			fprintf(fid, ' %d\n', 1);
			fprintf(fid, '%s %s %s %s', 'Number of Loaded Nodes');
			fprintf(fid, ' %d\n', size(nodeLoadVec_,1));
			fprintf(fid, '%s %s', 'Node Force'); fprintf(fid, '\n');
			fprintf(fid, '%d %.6f %6f\n', (nodeLoadVec_-tmp)');
			fprintf(fid, '%s %s', 'Cartesian Stress'); 
			fprintf(fid, ' %d\n', numNodes_);
			fprintf(fid, '%.6e %.6e %6e\n', cartesianStressField_');				
		case '3D'			
			fprintf(fid, ' %d %d %d\n', [nelx_ nely_ nelz_]);
			fprintf(fid, '%s', 'LowerBound:');
			fprintf(fid, ' %f %f %f\n', [vtxLowerBound_]);
			fprintf(fid, '%s', 'UpperBound:');
			fprintf(fid, ' %f %f %f\n', [vtxUpperBound_]);	
			fprintf(fid, '%s', 'ELEMENTS');
			fprintf(fid, ' %d', numEles_);
			fprintf(fid, ' %s \n', 'int');	
			fprintf(fid, '%d\n', validElements_-1);
			%%2.1 compute
			switch structureState_
				case 'STATIC'
					U_ = SolvingStaticFEM('printP_ON');
				case 'DYNAMIC'
					U_ = SolvingDynamicFEM('printP_ON');
			end
			cartesianStressField_ = ComputeCartesianStress(U_);
			Deformation('T',1);
			%%2.2 write
			tmp = zeros(size(nodeLoadVec_)); tmp(:,1) = 1;
			fprintf(fid, '%s %s %s %s', 'Number of Stress Fields');
			fprintf(fid, ' %d\n', 1);
			fprintf(fid, '%s %s %s %s', 'Number of Loaded Nodes');
			fprintf(fid, ' %d\n', size(nodeLoadVec_,1));
			fprintf(fid, '%s %s', 'Node Force'); fprintf(fid, '\n');
			fprintf(fid, '%d %.6f %6f %6f\n', (nodeLoadVec_-tmp)');
			fprintf(fid, '%s %s', 'Cartesian Stress'); 
			fprintf(fid, ' %d\n', numNodes_);
			fprintf(fid, '%.6f %.6f %6f %.6f %.6f %6f\n', cartesianStressField_');	
	end
	fclose(fid);
end