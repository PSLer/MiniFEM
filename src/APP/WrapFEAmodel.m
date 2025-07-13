function WrapFEAmodel()
	global outPath_;
	global eleType_;
	global numEles_; 
	global eNodMat_; 
	global numNodes_; 
	global nodeCoords_;
	global fixingCond_; 
	global loadingCond_;
	global materialIndicatorField_;
	global diameterList_;
	global nodState_;
	
	fileName = strcat(outPath_, 'Data4MiniFEM.MiniFEM');
	fid = fopen(fileName, 'w');
	fprintf(fid, '%s ', 'Version');
	fprintf(fid, '%.1f\n', 2.0);
	switch eleType_.eleName
		case 'Plane133'
			fprintf(fid, '%s %s ', 'Plane Tri');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');	

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e\n', loadingCond_');
			end        
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
			fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d\n', fixingCond_');
			end										
		case 'Plane144'	
			fprintf(fid, '%s %s ', 'Plane Quad');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');	

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ materialIndicatorField_]');
			
			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e\n', loadingCond_');
			end        
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); 
			fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d\n', fixingCond_');
			end										
		case 'Solid144'
			fprintf(fid, '%s %s ', 'Solid Tet');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d %d\n', fixingCond_');						
			end		
		case 'Solid188'
			fprintf(fid, '%s %s ', 'Solid Hex');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d %d %d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d %d\n', fixingCond_');						
			end
		case 'Shell133'
			fprintf(fid, '%s %s ', 'Shell Tri');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d %d %d %d %d\n', fixingCond_');						
			end			
		case 'Shell144'
			fprintf(fid, '%s %s ', 'Shell Quad');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %d %d %d\n', [eNodMat_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d %d %d %d %d\n', fixingCond_');						
			end				
		case 'Truss122'
			fprintf(fid, '%s %s ', 'Frame Truss2D');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %.6e %d\n', [eNodMat_ diameterList_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node State: ');
			fprintf(fid, '%d\n', numel(nodState_));
			fprintf(fid, '%d\n', nodState_);

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e\n', loadingCond_');
			end		
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));	
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d\n', fixingCond_');
			end
		case 'Truss123'
			fprintf(fid, '%s %s ', 'Frame Truss3D');
			fprintf(fid, '%d\n', 1);
            
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %.6e %d\n', [eNodMat_ diameterList_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node State: ');
			fprintf(fid, '%d\n', numel(nodState_));
			fprintf(fid, '%d\n', nodState_);

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));	
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d %d\n', fixingCond_');
			end			
		case 'Beam122'
			fprintf(fid, '%s %s ', 'Frame Beam2D');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %.6e %d\n', [eNodMat_ diameterList_ materialIndicatorField_]');
			
			fprintf(fid, '%s %s ', 'Node State: ');
			fprintf(fid, '%d\n', numel(nodState_));
			fprintf(fid, '%d\n', nodState_);

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));	
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d %d\n', fixingCond_');
			end			
		case 'Beam123'
			fprintf(fid, '%s %s ', 'Frame Beam3D');
			fprintf(fid, '%d\n', 1);
			
			fprintf(fid, '%s ', 'Vertices:');
			fprintf(fid, '%d\n', numNodes_);		
			fprintf(fid, '%.6e %.6e %.6e\n', nodeCoords_');

			fprintf(fid, '%s ', 'Elements:');
			fprintf(fid, '%d \n', numEles_);
			fprintf(fid, '%d %d %.6e %d\n', [eNodMat_ diameterList_ materialIndicatorField_]');

			fprintf(fid, '%s %s ', 'Node State: ');
			fprintf(fid, '%d\n', numel(nodState_));
			fprintf(fid, '%d\n', nodState_);

			fprintf(fid, '%s %s ', 'Node Forces:'); 
			fprintf(fid, '%d\n', size(loadingCond_,1));
			if ~isempty(loadingCond_)
				fprintf(fid, '%d %.6e %.6e %.6e %.6e %.6e %.6e\n', loadingCond_');
			end
			fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', size(fixingCond_,1));
			if ~isempty(fixingCond_)
				fprintf(fid, '%d %d %d %d %d %d %d\n', fixingCond_');
			end			
	end
	fclose(fid);	
end
