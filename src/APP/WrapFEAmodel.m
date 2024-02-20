function WrapFEAmodel()
	global outPath_;
	global eleType_;
	global numEles_; 
	global eNodMat_; 
	global numNodes_; 
	global nodeCoords_;	
	global fixingCond_; 
	global loadingCond_;
	global materialIndicatorField_;
	
	if ~(strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144') || ...
			strcmp(eleType_.eleName, 'Solid188') || strcmp(eleType_.eleName, 'Solid144'))
		error('Only Works with Plane133, Plane144, Solid144 and Solid188 Elements!');
	end
	
	fileName = strcat(outPath_, 'dataset_TSV_v2.stress');
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'Version');
	fprintf(fid, '%.1f\n', 2.0);
	switch eleType_.eleName
		case 'Plane133'
			fprintf(fid, '%s %s ', 'Plane Tri');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');	

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e\n', loadingCond_');
			end        
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
			fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d\n', fixingCond_(:,1));
			end										
		case 'Plane144'
if 0 %% Temp Test
			fprintf(fid, '%s %s ', 'Plane Tri');
			fprintf(fid, '%d\n', 1);

			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', 2*numEles_);
			tmp_eNodMat = eNodMat_(:, [1 2 3  3 4 1])';
			tmp_eNodMat = reshape(tmp_eNodMat(:), 3, 2*numEles_)';
			fprintf(fid, '%d %d %d %d\n', [tmp_eNodMat materialIndicatorField_]');			
else		
			fprintf(fid, '%s %s ', 'Plane Quad');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');	

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ materialIndicatorField_]');
end
			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e\n', loadingCond_');
			end        
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
			fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d\n', fixingCond_(:,1));
			end										
		case 'Solid144'
			fprintf(fid, '%s %s ', 'Solid Tet');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d\n', fixingCond_(:,1));						
			end		
		case 'Solid188'
			fprintf(fid, '%s %s ', 'Solid Hex');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d\n', fixingCond_(:,1));						
			end
		case 'Truss123'

		case 'Beam123'
		
	end
	fclose(fid);	
end