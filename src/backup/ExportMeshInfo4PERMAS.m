function ExportMeshInfo4PERMAS(varargin)
	global eleType_;
	global meshType_;
	global outPath_;
	global numEles_; 
	global eNodMat_; 
	global numNodes_; 
	global nodeCoords_;	
	global fixingCond_; 
	global loadingCond_;
	
	if ~(strcmp(eleType_.eleName, 'Plane144') || strcmp(eleType_.eleName, 'Solid188'))
		error('Only Works with 2D Plane144 and 3D Solid188 Elements!');
	end
	
	fileName = strcat(outPath_, 'wrappedMeshInfo.dat');
	fid = fopen(fileName, 'w');
	%%write in self-defined stress style	
	%%1.1 file header
	if strcmp(eleType_.eleName, 'Plane144')
		%%1.2 node coordinates
		fprintf(fid, '%s ', 'Vertices:');
		fprintf(fid, '%d\n', numNodes_);		
		fprintf(fid, '%.6e %.6e\n', nodeCoords_');
		%%1.3 Cells
		fprintf(fid, '%s ', 'Elements:');
		fprintf(fid, '%d \n', numEles_);
		fprintf(fid, '%d %d %d %d\n', eNodMat_');
		%%1.4 Cartesian Stress
		fprintf(fid, '%s %s ', 'Node Forces:'); 
		fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f\n', loadingCond_');
		end        
		fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
		fprintf(fid, '%d\n', size(fixingCond_,1));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', fixingCond_(:,1));
		end										
	else
		%%1.2 node coordinates
		fprintf(fid, '%s ', 'Vertices:');
		fprintf(fid, '%d\n', numNodes_);		
		fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');
		%%1.3 Cells
		fprintf(fid, '%s ', 'Elements:');
		fprintf(fid, '%d \n', numEles_);
		fprintf(fid, '%d %d %d %d %d %d %d %d\n', eNodMat_');
		%%1.4 Cartesian Stress
		fprintf(fid, '%s %s ', 'Node Forces:'); 
		fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f %.6f\n', loadingCond_');
		end
		fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', fixingCond_(:,1));						
		end		
	end	
	fclose(fid);	
end
