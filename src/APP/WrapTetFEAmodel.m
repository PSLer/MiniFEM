function WrapTetFEAmodel()
	global eleType_;
	global meshType_;
	global outPath_;
	global numEles_; global eNodMat_; 
	global numNodes_; global nodeCoords_;
	global fixingCond_; global loadingCond_;
	global boundaryNodes_;

	if ~strcmp(eleType_.eleName, 'Solid144')
		error('Only Works with 3D Solid144 Elements!');
	end
	
	fileName = strcat(outPath_, 'wrappedTetFEAmodel.mesh');
	fid = fopen(fileName, 'w');	
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'MeshVersionFormatted'); fprintf(fid, '%d\n', 1);
	fprintf(fid, '%s ', 'Dimension'); fprintf(fid, '%d\n', 3);
	fprintf(fid, '%s ', 'Vertices'); fprintf(fid, '%d\n', numNodes_);
	fprintf(fid, '%16.6e %16.6e %16.6e %16.6e\n', [nodeCoords_ zeros(numNodes_, 1)]');
	fprintf(fid, '%s ', 'Tetrahedra'); fprintf(fid, '%d\n', 4*numEles_);
	fprintf(fid, '%10d %10d %10d %10d %10d\n', [eNodMat_ zeros(numEles_, 1)]');
	fprintf(fid, '%s %s ', 'fixed position:'); fprintf(fid, '%d\n', size(fixingCond_,1));
	if ~isempty(fixingCond_)
		fprintf(fid, '%d %d %d %d\n', fixingCond_');						
	end
	fprintf(fid, '%s %s ', 'loading condition:'); fprintf(fid, '%d\n', size(loadingCond_,1));
	if ~isempty(loadingCond_)
		fprintf(fid, '%d %16.6e %16.6e %16.6e\n', loadingCond_');
	end	
	fclose(fid);	
end