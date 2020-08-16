function OutputStressFieldInfo_Binary(fileName)
	global domainType_; global eleSize_;
	global numNodes_; global nodeCoords_; 
	global numEles_; global eNodMat_;
	global cartesianStressField_;
	global originalValidNodeIndex_;
	switch domainType_
		case '2D'		
			%%1. output mesh information
			meshInfoName = strcat(fileName, 'meshInfo.dat');
			fid = fopen(meshInfoName, 'w');
			%%1.1 node coordinates
			fprintf(fid, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', 'Node Coordinates');
			fprintf(fid, '%d\n', numNodes_);
			fprintf(fid, '%16.6e%16.6e\n', nodeCoords_');
			%%1.2 Elements
			fprintf(fid, '%c%c%c%c%c%c%c%c\n', 'Elements');
			fprintf(fid, '%16d%16.6e\n', [numEles_ eleSize_]);
			fprintf(fid, '%16d%16d%16d%16d\n', eNodMat_');
			fclose(fid);
			
			%%2. output cartesian stress field information
			stressFieldName = strcat(fileName, 'stressField.dat');
			fid = fopen(stressFieldName, 'w');
			fprintf(fid, '%16.6e%16.6e%16.6e\n', cartesianStressField_'); %% [sigma_x sigma_y tau_xy]           
			fclose(fid);
			
			%%3. output original valid node indexs (in case the FEM model is from a cut process)
			validNodeName = strcat(fileName, 'validNodeIndexs.dat');
			fid = fopen(validNodeName, 'w');
			fprintf(fid, '%16d\n', originalValidNodeIndex_');         
			fclose(fid);			
		case '3D'
			%%1. output mesh information
			% meshInfoName = strcat(fileName, 'meshInfo.dat');
			% fid = fopen(meshInfoName, 'w');
			%%1.1 node coordinates
			% fprintf(fid, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n', 'Node Coordinates');
			% fprintf(fid, '%d\n', numNodes_);
			% fprintf(fid, '%16.6e%16.6e%16.6e\n', nodeCoords_');
			%%1.2 Elements
			% fprintf(fid, '%c%c%c%c%c%c%c%c\n', 'Elements');
			% fprintf(fid, '%16d%16.6e\n', [numEles_ eleSize_]);
			% fprintf(fid, '%16d%16d%16d%16d%16d%16d%16d%16d\n', eNodMat_');
			% fclose(fid);
			
			%%2. output cartesian stress field information
			% stressFieldName = strcat(fileName, 'stressField.dat');
			% fid = fopen(stressFieldName, 'w');
			% fprintf(fid, '%16.6e%16.6e%16.6e%16.6e%16.6e%16.6e\n', cartesianStressField_'); %% [sigma_x sigma_y tau_xy]
			% fclose(fid);

			%%3. output original valid node indexs (in case the FEM model is from a cut process)
			% validNodeName = strcat(fileName, 'validNodeIndexs.dat');
			% fid = fopen(validNodeName, 'w');
			% fprintf(fid, '%16d\n', originalValidNodeIndex_');         
			% fclose(fid);
			srcNode = (1:numNodes_)';
			tarNode = ReorderingNode(srcNode);
			cartesianStressField_ = cartesianStressField_(tarNode,:);
			outputData = reshape(cartesianStressField_', size(cartesianStressField_,1)*size(cartesianStressField_,2),1)';
			stressFieldName = strcat(fileName, 'stressField.bin');
			fid = fopen(stressFieldName, 'wb');
			fwrite(fid, outputData, 'single');
			fclose(fid);
			
	end
end