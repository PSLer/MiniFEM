function ExportDatasetForTSV(varargin)
	global outPath_;
	global eleType_;
	global numEles_; 
	global eNodMat_; 
	global numNodes_; 
	global nodeCoords_;	
	global fixingCond_; 
	global loadingCond_;
	global cartesianStressField_;
	
	if ~(strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144') || ...
			strcmp(eleType_.eleName, 'Solid188') || strcmp(eleType_.eleName, 'Solid144'))
		error('Only Works with Plane133, Plane144, Solid144 and Solid188 Elements!');
	end
	if isempty(cartesianStressField_)
		warning('No Cartesian Stress Available!'); return;
	end

	outputNodeWise = 1;
	if 1==nargin
		if varargin{1} %%Element-wise Stress Field
			outputNodeWise = 0;
		end
	end
	if outputNodeWise
		stressField2Output = cartesianStressField_;
	else
		stressField2Output = ComputeCartesianStressAtCellCentroids(cartesianStressField_);
	end	
	
	fileName = strcat(outPath_, 'dataset.TSV');
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'Version');
	fprintf(fid, '%.1f\n', 2.0);
	if outputNodeWise
		fprintf(fid, '%s %s %s %s', 'Stress Data Type: NODE'); fprintf(fid, '\n');
	else
		fprintf(fid, '%s %s %s %s', 'Stress Data Type: ELEMENT'); fprintf(fid, '\n');
	end	
	switch eleType_.eleName
		case 'Plane133'
			fprintf(fid, '%s %s ', 'Plane Tri');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');	

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d\n', eNodMat_');

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
			fprintf(fid, '%s %s', 'Cartesian Stress:'); 
			fprintf(fid, '%d\n', size(stressField2Output,1));		
			fprintf(fid, '%.6e %.6e %.6e\n', stressField2Output');			
		case 'Plane144'		
			fprintf(fid, '%s %s ', 'Plane Quad');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');	

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d\n', eNodMat_');
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
			fprintf(fid, '%s %s', 'Cartesian Stress:'); 
			fprintf(fid, '%d\n', size(stressField2Output,1));		
			fprintf(fid, '%.6e %.6e %.6e\n', stressField2Output');			
		case 'Solid144'
			fprintf(fid, '%s %s ', 'Solid Tet');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d\n', eNodMat_');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d\n', fixingCond_(:,1));						
			end
			fprintf(fid, '%s %s', 'Cartesian Stress:'); 
			fprintf(fid, '%d\n', size(stressField2Output,1));
			fprintf(fid, '%.6e %.6e %.6e %.6e %.6e %.6e\n', stressField2Output');			
		case 'Solid188'
			fprintf(fid, '%s %s ', 'Solid Hex');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d %d %d %d %d\n', eNodMat_');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d\n', fixingCond_(:,1));						
			end
			fprintf(fid, '%s %s', 'Cartesian Stress:'); 
			fprintf(fid, '%d\n', size(stressField2Output,1));
			fprintf(fid, '%.6e %.6e %.6e %.6e %.6e %.6e\n', stressField2Output');			
	end
	fclose(fid);	
end