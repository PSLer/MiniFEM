function GetDeformedMesh(varargin)
	%%GetDeformedMesh(scalingFac)
	%%GetDeformedMesh(scalingFac, output_vtk)
	
	if 0==nargin, error('Wrong input for getting deformed mesh!'); end
	global domainType_;
	global nodeCoords_;
	global U_;
	global eleType_;
	global numNodes_;
	global numEles_;
	global eNodMat_;	
	global dShape_;
	global JacobianDet_;
	global JacobianRatio_;	
% 	Deformation();
	
	%%measure quality of deformed mesh
	shiftingTerm = varargin{1} * U_;
	shiftingTerm =  reshape(shiftingTerm, eleType_.numNodeDOFs, numNodes_)';
	nodeCoords_ = nodeCoords_ + shiftingTerm;
	
	
	JacobianDet_ = zeros(numEles_, eleType_.numGIPs);
	JacobianRatio_ = zeros(numEles_,1);
	numEntries = eleType_.numNode*eleType_.numNodeDOFs;
	[s t p w] = GaussianIntegral();
	dShape_ = DeShapeFunction(s,t,p);
		
	for ii=1:1:numEles_
		relativeNodCoord = nodeCoords_(eNodMat_(ii,:)',:);
		for jj=1:1:eleType_.numGIPs
			[JacobianDet_(ii, jj) tmp] = ...
				JacobianMat(dShape_(eleType_.numNodeDOFs*(jj-1)+1:eleType_.numNodeDOFs*jj,:), relativeNodCoord);
		end
		JacobianRatio_(ii) = min(JacobianDet_(ii,:)) / max(JacobianDet_(ii,:));
	end
	
	VisualizeMeshes('qualityMetric_On');
	
	if 2==nargin
		if strcmp(varargin{2}, 'output_vtk')
			global nodesOutline_;
			%%1. output file header		
			fileName = 'deformedMesh.vtk';
			fid = fopen(fileName, 'w');				
			fprintf(fid, '%s %s %s %s', '# vtk DataFile Version');
			fprintf(fid, '%.1f\n', 3.0);
			fprintf(fid, '%s %s', 'Volume mesh'); fprintf(fid, '\n');
			fprintf(fid, '%s \n', 'ASCII');
			fprintf(fid, '%s %s', 'DATASET UNSTRUCTURED_GRID'); fprintf(fid, '\n');
			fprintf(fid, '%s', 'POINTS');
			fprintf(fid, ' %d', numNodes_);
			fprintf(fid, ' %s \n', 'double');
			switch domainType_
				case '2D'		
					%%2. node coordinates
					fprintf(fid, '%.6f %.6f\n', nodeCoords_');
					%%3. Cells
					fprintf(fid, '%s', 'CELLS');
					fprintf(fid, ' %d %d\n', [numEles_ 5*numEles_]);
					fprintf(fid, '%d %d %d %d %d\n', [4*ones(numEles_,1) eNodMat_-1]');
					%%4. cell type
					fprintf(fid, '%s', 'CELL_TYPES');
					fprintf(fid, ' %d\n', numEles_);
					fprintf(fid, ' %d\n', 4*ones(1, numEles_));
					%%5. node positions
					fprintf(fid, '%s', 'POINT_DATA'); 
					fprintf(fid, ' %d\n', numNodes_);
					fprintf(fid, '%s %s %s', 'SCALARS fixed int'); fprintf(fid, '\n');
					fprintf(fid, '%s %s', 'LOOKUP_TABLE default'); fprintf(fid, '\n');
					tmp = zeros(numNodes_,1); tmp(nodesOutline_) = 1;
					fprintf(fid, ' %d\n', tmp');
					%%6. node deformation
					fprintf(fid, '%s', 'Deformation'); 
					fprintf(fid, ' %d\n', numNodes_);
					fprintf(fid, '%.6e %.6e\n', shiftingTerm'/varargin{1});						
				case '3D'
					%%2. node coordinates
					fprintf(fid, '%.6f %.6f %.6f\n', nodeCoords_');
					%%3. Cells
					fprintf(fid, '%s', 'CELLS');
					fprintf(fid, ' %d %d\n', [numEles_ 9*numEles_]);
					fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [8*ones(numEles_,1) eNodMat_-1]');
					%%4. cell type
					fprintf(fid, '%s', 'CELL_TYPES');
					fprintf(fid, ' %d\n', numEles_);
					fprintf(fid, ' %d\n', 12*ones(1, numEles_));
					%%5. node positions
					fprintf(fid, '%s', 'POINT_DATA'); 
					fprintf(fid, ' %d\n', numNodes_);
					fprintf(fid, '%s %s %s', 'SCALARS fixed int'); fprintf(fid, '\n');
					fprintf(fid, '%s %s', 'LOOKUP_TABLE default'); fprintf(fid, '\n');
					tmp = zeros(numNodes_,1); tmp(nodesOutline_) = 1;
					fprintf(fid, ' %d\n', tmp');
					%%6. node deformation
% 					fprintf(fid, '%s', 'Deformation'); 
% 					fprintf(fid, ' %d\n', numNodes_);
% 					fprintf(fid, '%.6e %.6e %.6e\n', shiftingTerm'/varargin{1});					
			end			
			fclose(fid);
		else
			error('Wrong input for getting deformed mesh!');
		end
	end
	nodeCoords_ = nodeCoords_ - shiftingTerm;
end