function IO_ExportFEModel2D_MiniFEM(fileName)
	global simMesh_;
	global loadingCond_;
	global fixingCond_;
	
	[~, nodesLoadedFixed] = setdiff(fixingCond_(:,1), loadingCond_(:,1));
	fixingCond_ = fixingCond_(nodesLoadedFixed,:);
	[~,uniqueFixedNodes] = unique(fixingCond_(:,1));
	fixingCond_ = fixingCond_(uniqueFixedNodes,:);	
	[~,uniqueLoadedNodes] = unique(loadingCond_(:,1));
	loadingCond_ = loadingCond_(uniqueLoadedNodes,:);
	
	materialIndicatorField_ = ones(simMesh_.numElements,1);
	
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'Version');
	fprintf(fid, '%.1f\n', 2.0);
	switch simMesh_.meshType
		case 'TRI'
			bNodesInGlobalIndices = find(1==simMesh_.nodeState);

			fprintf(fid, '%s %s ', 'Plane Tri');
			fprintf(fid, '%d\n', 1);

			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', simMesh_.numNodes);		
			fprintf(fid, '%.6e %.6e\n', simMesh_.nodeCoords');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', simMesh_.numElements);
			fprintf(fid, '%d %d %d %d %d\n', [simMesh_.eNodMat materialIndicatorField_]');	
			
			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			fprintf(fid, '%d %16.6e %16.6e\n', [bNodesInGlobalIndices(loadingCond_(:,1)) loadingCond_(:,2:end)]');
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
			fprintf(fid, '%d\n', size(fixingCond_,1));
			fprintf(fid, '%d %d %d\n', [bNodesInGlobalIndices(fixingCond_(:,1)) fixingCond_(:,2:end)]');			
	end
	fclose(fid);
end