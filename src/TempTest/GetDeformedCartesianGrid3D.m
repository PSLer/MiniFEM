function GetDeformedCartesianGrid3D(meshInfoName)
	global nelx_; global nely_; global nelz_; 
	global numNodes_; global numEles_; global eNodMat_;
	global nodeCoords_;	
	global U_;
	deviator = reshape(U_, 3, numNodes_)';
	
	xCoords = nodeCoords_(:,1) + deviator(:,1);
	yCoords = nodeCoords_(:,2) + deviator(:,2);
	zCoords = nodeCoords_(:,3) + deviator(:,3);
	xCoords = reshape( xCoords, nely_+1, nelx_+1, nelz_+1 );
	yCoords = reshape( yCoords, nely_+1, nelx_+1, nelz_+1 );
	zCoords = reshape( zCoords, nely_+1, nelx_+1, nelz_+1 );			
	
	figure(2)
	%%1. draw mesh lines along y-direction
	for jj=1:1:nelz_+1
		for ii=1:1:nelx_+1
			plot3( xCoords(:,ii,jj), yCoords(:,ii,jj), zCoords(:,ii,jj), ...
				'-b', 'LineWidth', 1 ); hold on
		end
	end
	
	%%2. draw mesh lines along x-direction
	for jj=1:1:nelz_+1
		for ii=1:1:nely_+1
			plot3( xCoords(ii,:,jj), yCoords(ii,:,jj), zCoords(ii,:,jj), ...
				'-b', 'LineWidth', 1 ); hold on
		end
	end
	
	%%3. draw mesh lines along z-direction
	for jj=1:1:nelx_+1
		for ii=1:1:nely_+1
			tempX = reshape(xCoords(ii,jj,:), nelz_+1, 1);
			tempY = reshape(yCoords(ii,jj,:), nelz_+1, 1);
			tempZ = reshape(zCoords(ii,jj,:), nelz_+1, 1);
			plot3( tempX, tempY, tempZ, '-b', 'LineWidth', 1 ); hold on
		end
	end
	
	axis equal; box on
	xlabel('X'); ylabel('Y'); zlabel('Z')
	camproj('perspective')
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20)	
	
	
	%%1. output mesh information	
	fid = fopen(meshInfoName, 'w');
	%%1.1 node coordinates
	fprintf(fid, '%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c', 'MeshVersionFormatted'); fprintf(fid, '%d\n', 1);
	fprintf(fid, '%c%c%c%c%c%c%c%c%c', 'Dimension'); fprintf(fid, ' %d\n', 3);
	fprintf(fid, '%c%c%c%c%c%c%c%c', 'Vertices'); fprintf(fid, ' %d\n', numNodes_);
	
	fprintf(fid, '%.6f %.6f %.6f %d\n', [nodeCoords_+deviator zeros(numNodes_,1)]');
	%%1.2 Elements
	fprintf(fid, '%c%c%c%c%c%c%c%c%c', 'Hexahedra'); fprintf(fid, ' %d\n', numEles_);
	fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [eNodMat_ zeros(numEles_,1)]');
	fprintf(fid, '%c%c%c', 'End');
	fclose(fid);		
end