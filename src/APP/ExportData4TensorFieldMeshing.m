function ExportData4TensorFieldMeshing()
	global domainType_;
	global numEles_; 
	global numNodes_;
	global nodeCoords_;
	global eNodMat_;
	global principalStressField_;
	fileName = 'D:/MyDataSets/TensorFieldMeshing/xx';
	fileName1 = strcat(fileName, '.obj'); fid = fopen(fileName1, 'w');
	fprintf(fid, '%d %d\n', [numNodes_ 2*numEles_]);
	fprintf(fid, '%f %f %f\n', [nodeCoords_ zeros(numNodes_,1)]');
	triSurf = [eNodMat_(:,[1 2 3]) eNodMat_(:,[1 4 3])]';
	triSurf = reshape(triSurf,3,2*numEles_);
	fprintf(fid, '%d %d %d %d\n', [3*ones(1,2*numEles_); triSurf-1]);
	fclose(fid);
	fileName1 = strcat(fileName, '.txt'); fid = fopen(fileName1, 'w');
	PrincipalStress;
	switch domainType_
		case '2D'
			tensorField = ones(3*numNodes_,2);
			tensorField(1:3:3*numNodes_,:) = principalStressField_(:,2:3);
			tensorField(2:3:3*numNodes_,:) = principalStressField_(:,5:6);
			fprintf(fid, '%f %f\n', tensorField');
		case '3D'
		
	end
	fclose(fid);
end