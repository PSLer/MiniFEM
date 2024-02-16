function RedistributeCartesianStressOnHexMesh2SubdividedTetMesh()
	DivNum = 12;
	switch DivNum
		case 5
			RedistributeCartesianStressOnHexMesh2SubdividedTetMesh_Div5();
		case 12
			RedistributeCartesianStressOnHexMesh2SubdividedTetMesh_Div12();
		case 24
			RedistributeCartesianStressOnHexMesh2SubdividedTetMesh_Div24();
	end
end
function RedistributeCartesianStressOnHexMesh2SubdividedTetMesh_Div5()
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global cartesianStressField_;
	global outPath_;
	global boundingBox_;
	
	%%Tetrahedralization from hexahedron (5 from 1)
	%% Move object to let its bounding box located at [0,0,0]
	tmp_nodeCoord = nodeCoords_ - boundingBox_(1,:);
	hex_to_tet_nodeCoords = nodeCoords_;
	tmp_eNodMat = eNodMat_;
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		iEleNodeCoords = tmp_nodeCoord(iEleNodes,:);
		dis2zero = vecnorm(iEleNodeCoords,2,2);
		[~,smallestVtx] = min(dis2zero);
		
		switch smallestVtx
			case 1
				newEleNodes = iEleNodes;
			case 2
				newEleNodes = iEleNodes([2 1 5 6 3 4 8 7]);
			case 3
				newEleNodes = iEleNodes([3 2 6 7 4 1 5 8]);
			case 4
				newEleNodes = iEleNodes([4 1 2 3 8 5 6 7]);
			case 5
				newEleNodes = iEleNodes([5 1 4 8 6 2 3 7]);
			case 6
				newEleNodes = iEleNodes([6 2 1 5 7 3 4 8]);
			case 7
				newEleNodes = iEleNodes([7 3 2 6 8 4 1 5]);
			case 8
				newEleNodes = iEleNodes([8 4 3 7 5 1 2 6]);
		end
		tmp_eNodMat(ii,:) = newEleNodes;
	end
	
	numTetNodes = numNodes_;
	numTetEles = 5*numEles_;
	hex_to_tet_eNodMat = tmp_eNodMat(:,[1 2 3 6  1 3 8 6  1 3 4 8  1 6 8 5  3 8 6 7]);
	hex_to_tet_eNodMat = reshape(hex_to_tet_eNodMat', 4, numTetEles)';
	hex_to_tet_cartesianStress = cartesianStressField_;
	hex_to_tet_principalStress = ComputePrincipalStress(hex_to_tet_cartesianStress);
	
	% figure; VisSubdividedElements(hex_to_tet_nodeCoords, hex_to_tet_eNodMat([1 3 5],:));
	
	%% Write
	%% Output tet-mesh
	fileName = strcat(outPath_, 'tet_sim.mesh');
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'MeshVersionFormatted'); fprintf(fid, '%d\n', 1);
	fprintf(fid, '%s ', 'Dimension'); fprintf(fid, '%d\n', 3);
	fprintf(fid, '%s ', 'Vertices'); fprintf(fid, '%d\n', numTetNodes);
	fprintf(fid, '%16.6e %16.6e %16.6e %16.6e\n', [hex_to_tet_nodeCoords zeros(numTetNodes, 1)]');
	fprintf(fid, '%s ', 'Tetrahedra'); fprintf(fid, '%d\n', 4*numTetEles);
	fprintf(fid, '%10d %10d %10d %10d %10d\n', [hex_to_tet_eNodMat zeros(numTetEles, 1)]');
	fprintf(fid, '%s', 'End'); fprintf(fid, '\n');
	fclose(fid);
	
	%% sigma_xx, sigma_yy, sigma_zz, tadis_yz, tadis_zx, tadis_xy (solid)
	fileName = strcat(outPath_, 'tet_Cartesian_stress.dat');
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s %s ', 'Cartesian Stress'); fprintf(fid, '%d\n', numTetNodes);
	fprintf(fid, '%16.6e %16.6e %16.6e %16.6e %16.6e %16.6e\n', hex_to_tet_cartesianStress');
	fclose(fid);
	
	fileName = strcat(outPath_, 'tet_principal_stress.dat');
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s %s ', 'Principal Stress'); fprintf(fid, '%d\n', numTetNodes);
	fprintf(fid, '%16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e\n', hex_to_tet_principalStress');
	fclose(fid);	
end

function RedistributeCartesianStressOnHexMesh2SubdividedTetMesh_Div12()
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global cartesianStressField_;
	global fixingCond_;
	global loadingCond_;
	global outPath_;
	
	shapeFuncsAtCentroid = ShapeFunction([0.0, 0.0, 0.0]);
	eleCentroidList = zeros(numEles_,3);
	for ii=1:numEles_
		iEleCoords = nodeCoords_(eNodMat_(ii,:),:);
		eleCentroidList(ii,:) = shapeFuncsAtCentroid * iEleCoords;
	end
	
	%%Tetrahedralization from hexahedron
	numTetNodes = numNodes_ + numEles_;
	numTetEles = 12*numEles_;
	hex_to_tet_nodeCoords = [nodeCoords_; eleCentroidList];
	newNodeIndices = (1:numEles_)' + numNodes_;
	
	hex_to_tet_eNodMat = zeros(numEles_, 48);
	hex_to_tet_eNodMat(:,1:4) = [eNodMat_(:,[1 2 3]) newNodeIndices];
	hex_to_tet_eNodMat(:,5:8) = [eNodMat_(:,[3 4 1]) newNodeIndices];
	hex_to_tet_eNodMat(:,9:12) = [eNodMat_(:,[5 7 6]) newNodeIndices];
	hex_to_tet_eNodMat(:,13:16) = [eNodMat_(:,[5 8 7]) newNodeIndices];
	
	hex_to_tet_eNodMat(:,17:20) = [eNodMat_(:,[2 7 3]) newNodeIndices];
	hex_to_tet_eNodMat(:,21:24) = [eNodMat_(:,[2 6 7]) newNodeIndices];
	hex_to_tet_eNodMat(:,25:28) = [eNodMat_(:,[1 4 8]) newNodeIndices];
	hex_to_tet_eNodMat(:,29:32) = [eNodMat_(:,[1 8 5]) newNodeIndices];
	
	hex_to_tet_eNodMat(:,33:36) = [eNodMat_(:,[1 5 2]) newNodeIndices];			
	hex_to_tet_eNodMat(:,37:40) = [eNodMat_(:,[5 6 2]) newNodeIndices];
	hex_to_tet_eNodMat(:,41:44) = [eNodMat_(:,[8 4 3]) newNodeIndices];
	hex_to_tet_eNodMat(:,45:48) = [eNodMat_(:,[7 8 3]) newNodeIndices];
	
	hex_to_tet_eNodMat = hex_to_tet_eNodMat'; hex_to_tet_eNodMat = hex_to_tet_eNodMat(:);
	hex_to_tet_eNodMat = reshape(hex_to_tet_eNodMat, 4, numTetEles)';		
	
	stressTensorAtElementCentroids = zeros(numEles_, size(cartesianStressField_,2));
	for ii=1:numEles_
		iCartesianStress = cartesianStressField_(eNodMat_(ii,:), :);
		stressTensorAtElementCentroids(ii,:) = shapeFuncsAtCentroid * iCartesianStress;
	end
	hex_to_tet_cartesianStress = [cartesianStressField_; stressTensorAtElementCentroids];
	hex_to_tet_principalStress = ComputePrincipalStress(hex_to_tet_cartesianStress);
	
	% figure; VisSubdividedElements(hex_to_tet_nodeCoords, hex_to_tet_eNodMat([1 3 5 7 9 11],:));
	
	%% Write
	fileName = strcat(outPath_, 'hex2tet_sim.stress');
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'Version');
	fprintf(fid, '%.1f\n', 2.0);	
	fprintf(fid, '%s %s ', 'Solid Tet');
	fprintf(fid, '%d\n', 1);
	
	fprintf(fid, '%s ', 'Vertices:');
	fprintf(fid, '%d\n', numTetNodes);		
	fprintf(fid, '%.6e %.6e %.6e\n', hex_to_tet_nodeCoords');

	fprintf(fid, '%s ', 'Elements:');
	fprintf(fid, '%d \n', numTetEles);
	fprintf(fid, '%d %d %d %d\n', hex_to_tet_eNodMat');

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
	fprintf(fid, '%d\n', numTetNodes);
	fprintf(fid, '%.6e %.6e %.6e %.6e %.6e %.6e\n', hex_to_tet_cartesianStress');		
	
	%% Output tet-mesh
	% fileName = strcat(outPath_, 'tet_sim.mesh');
	% fid = fopen(fileName, 'w');
	% fprintf(fid, '%s ', 'MeshVersionFormatted'); fprintf(fid, '%d\n', 1);
	% fprintf(fid, '%s ', 'Dimension'); fprintf(fid, '%d\n', 3);
	% fprintf(fid, '%s ', 'Vertices'); fprintf(fid, '%d\n', numTetNodes);
	% fprintf(fid, '%16.6e %16.6e %16.6e %16.6e\n', [hex_to_tet_nodeCoords zeros(numTetNodes, 1)]');
	% fprintf(fid, '%s ', 'Tetrahedra'); fprintf(fid, '%d\n', 4*numTetEles);
	% fprintf(fid, '%10d %10d %10d %10d %10d\n', [hex_to_tet_eNodMat zeros(numTetEles, 1)]');
	% fprintf(fid, '%s', 'End'); fprintf(fid, '\n');
	% fclose(fid);
	
	% %% sigma_xx, sigma_yy, sigma_zz, tadis_yz, tadis_zx, tadis_xy (solid)
	% fileName = strcat(outPath_, 'tet_Cartesian_stress.dat');
	% fid = fopen(fileName, 'w');
	% fprintf(fid, '%s %s ', 'Cartesian Stress'); fprintf(fid, '%d\n', numTetNodes);
	% fprintf(fid, '%16.6e %16.6e %16.6e %16.6e %16.6e %16.6e\n', hex_to_tet_cartesianStress');
	fclose(fid);
	
	% fileName = strcat(outPath_, 'tet_principal_stress.dat');
	% fid = fopen(fileName, 'w');
	% fprintf(fid, '%s %s ', 'Principal Stress'); fprintf(fid, '%d\n', numTetNodes);
	% fprintf(fid, '%16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e %16.6e\n', hex_to_tet_principalStress');
	% fclose(fid);	
end

function RedistributeCartesianStressOnHexMesh2SubdividedTetMesh_Div24()
	global numNodes_;
	global nodeCoords_;
	global numEles_;
	global eNodMat_;
	global cartesianStressField_;
	global outPath_;
	
	shapeFuncsAtCentroid = ShapeFunction([0.0, 0.0, 0.0]);
	shapeFuncsAtFaceCentroid = shapeFuncsAtCentroid([0 0 -1; 0 0 1; -1 0 0; 1 0 0; 0 -1 0; 0 1 0]);
	eleCentroidList = zeros(numEles_,3);
	stressAtEleCentroids = zeros(numEles_, 6)
	eleFaceCentroidList = zeros(6*numEles_, 3);
	stressAtEleFaceCentroidList = zeros(6*numEles_, 6);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		iEleCoords = nodeCoords_(iEleNodes,:);
		iEleStress = cartesianStressField_(iEleNodes,:);
		eleCentroidList(ii,:) = shapeFuncsAtCentroid * iEleCoords;
		stressAtEleCentroids(ii,:) = shapeFuncsAtCentroid * iEleStress;
		eleFaceCentroidList(6*(ii-1)+1:6*ii,:) = shapeFuncsAtFaceCentroid * iEleCoords;
		stressAtEleFaceCentroidList(6*(ii-1)+1:6*ii,:) = shapeFuncsAtFaceCentroid * iEleStress;
	end
	
	
	for ii=1:6*numEles_
		
	end
end

function VisSubdividedElements(coords, eles)
	visPatchs.vertices = coords;
	numEles = size(eles,1);
	patchIndices = eles(:, [1 2 3  4 2 1  4 3 2  4 1 3])';
	visPatchs.faces = reshape(patchIndices(:), 3, 4*numEles)';
	hd = patch(visPatchs);
	camproj('perspective');
	% xlabel('X'); ylabel('Y'); zlabel('Z');
	[az, el] = view(3);
	lighting('gouraud');
	camlight(az,el);
	material('dull'); %% dull, shiny, metal	
	set(hd, 'FaceColor', [65 174 118]/255, 'FaceAlpha', 1, 'EdgeColor', 'k');
	axis('equal'); axis('tight'); axis('on');
	% set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);			
end