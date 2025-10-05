function IO_ExportFEModelShell_MiniFEM(fileName, t)
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
	shellThicknessList_ = ones(simMesh_.numElements,1) .* t;
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'Version');
	fprintf(fid, '%.1f\n', 2.0);
	switch simMesh_.meshType
		case 'TRI'
			fprintf(fid, '%s %s ', 'Shell Tri');
			fprintf(fid, '%d\n', 1);

			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', simMesh_.numNodes);		
			fprintf(fid, '%.6e %.6e %.6e\n', simMesh_.nodeCoords');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', simMesh_.numElements);
			fprintf(fid, '%d %d %d %d %16.6e\n', [simMesh_.eNodMat materialIndicatorField_ shellThicknessList_]');	
			
			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			fprintf(fid, '%d %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e\n', loadingCond_');
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
			fprintf(fid, '%d\n', size(fixingCond_,1));
			fprintf(fid, '%d %d %d %d %d %d %d\n', fixingCond_');			
		case 'QUAD'
			fprintf(fid, '%s %s ', 'Shell Quad');
			fprintf(fid, '%d\n', 1);

			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', simMesh_.numNodes);		
			fprintf(fid, '%.6e %.6e %.6e\n', simMesh_.nodeCoords');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', simMesh_.numElements);
			fprintf(fid, '%d %d %d %d %d %16.6e\n', [simMesh_.eNodMat materialIndicatorField_ shellThicknessList_]');	
			
			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			fprintf(fid, '%d %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e\n', loadingCond_');
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
			fprintf(fid, '%d\n', size(fixingCond_,1));
			fprintf(fid, '%d %d %d %d %d %d %d\n', fixingCond_');
	end
	fclose(fid);
end