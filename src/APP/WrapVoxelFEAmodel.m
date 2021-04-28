function WrapVoxelFEAmodel()
	global meshType_;
	global eleType_;
	global nelx_; global nely_; global nelz_;
	global numEles_;
	global carEleMapBack_; global carNodMapBack_;
	global fixingCond_; global loadingCond_;
	global outPath_;
	
	if ~strcmp(meshType_, 'Cartesian')
		warning('Only Work with Cartesian Mesh!'); return;
	end
	fileName = strcat(outPath_, '/wrappedVoxelFEAmodel.txt');
	fid = fopen(fileName, 'w');	
	fprintf(fid, '%s %s %s', '# clipping model '); fprintf(fid, '\n');
	if strcmp(eleType_.eleName, 'Plane144')
		fprintf(fid, '%s %s %s', 'domain type: 2D'); fprintf(fid, '\n');
		fprintf(fid, '%s ', 'resolution:'); 
		fprintf(fid, '%d %d\n', [nelx_ nely_]);
		fprintf(fid, '%s %s ', 'valid elements:');
		fprintf(fid, '%d\n', numEles_);
		fprintf(fid, '%d\n', carEleMapBack_');
		fprintf(fid, '%s %s ', 'fixed position:');
		fprintf(fid, '%d\n', length(fixingCond_));
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', carNodMapBack_(fixingCond_));
		end
		fprintf(fid, '%s %s ', 'loading condition:');
		fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %6f\n', [double(carNodMapBack_(loadingCond_(:,1))) loadingCond_(:,2:end)]');
		end
	else
		fprintf(fid, '%s %s %s', 'domain type: 3D'); fprintf(fid, '\n');
		fprintf(fid, '%s ', 'resolution:'); 
		fprintf(fid, '%d %d %d\n', [nelx_ nely_ nelz_]);
		fprintf(fid, '%s %s ', 'valid elements:');
		fprintf(fid, '%d\n', numEles_);
		fprintf(fid, '%d\n', carEleMapBack_');
		fprintf(fid, '%s %s ', 'fixed position:');
		fprintf(fid, '%d\n', length(fixingCond_));		
		if ~isempty(fixingCond_)
			fprintf(fid, '%d\n', carNodMapBack_(fixingCond_));
		end
		fprintf(fid, '%s %s ', 'loading condition:');
		fprintf(fid, '%d\n', size(loadingCond_,1));
		if ~isempty(loadingCond_)
			fprintf(fid, '%d %.6f %.6f %.6f\n', [double(carNodMapBack_(loadingCond_(:,1))) loadingCond_(:,2:end)]');
		end		
	end
	fclose(fid);
end