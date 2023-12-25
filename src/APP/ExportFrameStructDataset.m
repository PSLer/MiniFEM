function ExportFrameStructDataset()
	global outPath_;
	global eleType_;
	global numEles_; 
	global eNodMat_; 
	global numNodes_; 
	global nodeCoords_;	
	global fixingCond_; 
	global loadingCond_;
	global nodState_;
	global diameterList_;
	
	if ~(strcmp(eleType_.eleName, 'Truss122') || strcmp(eleType_.eleName, 'Truss123') || ...
			strcmp(eleType_.eleName, 'Beam122') || strcmp(eleType_.eleName, 'Beam123'))
		error('Only Works with Plane133, Plane144, Solid144 and Solid188 Elements!');
	end
	
	
	if strcmp(eleType_.eleName, 'Truss122') || strcmp(eleType_.eleName, 'Truss123')
		fileName = strcat(outPath_, 'frame_data_Truss', '.frame');
	else
		fileName = strcat(outPath_, 'frame_data_Beam', '.frame');
	end	
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'Version');
	fprintf(fid, '%.1f\n', 2.0);
	if strcmp(eleType_.eleName, 'Truss122') || strcmp(eleType_.eleName, 'Beam122')
		if strcmp(eleType_.eleName, 'Truss122')
			fprintf(fid, '%s %s %s ', 'Frame 2D Truss');
		else
			fprintf(fid, '%s %s %s ', 'Frame 2D Beam');
		end
		fprintf(fid, '%d\n', 1);
		
		fprintf(fid, '%s ', 'Vertices:');
		fprintf(fid, '%d\n', numNodes_);		
		fprintf(fid, '%.6e %.6e\n', nodeCoords_');			
	else
		if strcmp(eleType_.eleName, 'Truss123')
			fprintf(fid, '%s %s %s ', 'Frame 3D Truss');
		else
			fprintf(fid, '%s %s %s ', 'Frame 3D Beam');
		end
		fprintf(fid, '%d\n', 1);
		
		fprintf(fid, '%s ', 'Vertices:');
		fprintf(fid, '%d\n', numNodes_);		
		fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');		
	end
	fprintf(fid, '%s ', 'Elements:');
	fprintf(fid, '%d \n', numEles_);
	fprintf(fid, '%d %d %.6e\n', [double(eNodMat_) diameterList_]');	
	
	fprintf(fid, '%s %s ', 'Node State: ');
	fprintf(fid, '%d\n', numel(nodState_));
	if ~isempty(nodState_)
		fprintf(fid, '%d\n', nodState_);
	end

	fprintf(fid, '%s %s ', 'Node Forces:'); 
	fprintf(fid, '%d\n', size(loadingCond_,1));
	if ~isempty(loadingCond_)
		switch eleType_.eleName
			case 'Truss122'
				fprintf(fid, '%d %.6e %.6e\n', loadingCond_');
			case 'Truss123'
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			case 'Beam122'
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			case 'Beam123'
				fprintf(fid, '%d %.6e %.6e %.6e %.6e %.6e %.6e\n', loadingCond_');
		end	
	end

	fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
	fprintf(fid, '%d\n', size(fixingCond_,1));
	if ~isempty(fixingCond_)
		fprintf(fid, '%d\n', fixingCond_(:,1));
	end		
	
	fprintf(fid, '%s %s', 'Cartesian Stress:'); 
	fprintf(fid, '%d\n', 0);

	fclose(fid);	
end