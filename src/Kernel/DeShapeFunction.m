function dN = DeShapeFunction(paraCoords)	
	%% 	paraCoords = [
	%%		s1 s2 s3 ...
	%%		t1 t2 t3 ...
	%%		p1 p2 p3 ...
	%% ]
	global eleType_;
	switch eleType_.eleName
		case 'Plane133'
			s = paraCoords(:,1);
			t = paraCoords(:,2);
			numVars = length(s); tmp = ones(numVars,1);
			
			dN1ds = 1*tmp; dN2ds = 0*tmp; dN3ds = -1*tmp;
			dN1dt = 0*tmp; dN2dt = 1*tmp; dN3dt = -1*tmp;
			dN = zeros(2*numVars, 3);
			dN(1:2:end,:) = [dN1ds dN2ds dN3ds];
			dN(2:2:end,:) = [dN1dt dN2dt dN3dt];				
		case 'Plane144'
			s = paraCoords(:,1);
			t = paraCoords(:,2);
			dN1ds = -(1-t); dN2ds = 1-t; 	dN3ds = 1+t; dN4ds = -(1+t);
			dN1dt = -(1-s); dN2dt = -(1+s); dN3dt = 1+s; dN4dt = 1-s;
			
			dN = zeros(2*length(s), 4);
			dN(1:2:end,:) = 0.25*[dN1ds dN2ds dN3ds dN4ds];
			dN(2:2:end,:) = 0.25*[dN1dt dN2dt dN3dt dN4dt];		
		case 'Solid144'
			s = paraCoords(:,1);
			t = paraCoords(:,2);
			p = paraCoords(:,3);
			numVars = length(s); tmp = ones(numVars,1);
			
			dN1ds = -1*tmp; dN2ds = 1*tmp; dN3ds = 0*tmp; dN4ds = 0*tmp;
			dN1dt = -1*tmp; dN2dt = 0*tmp; dN3dt = 1*tmp; dN4dt = 0*tmp;	
			dN1dp = -1*tmp; dN2dp = 0*tmp; dN3dp = 0*tmp; dN4dp = 1*tmp;

			dN = zeros(3*length(s), 4);
			dN(1:3:end,:) = [dN1ds dN2ds dN3ds dN4ds];
			dN(2:3:end,:) = [dN1dt dN2dt dN3dt dN4dt];
			dN(3:3:end,:) = [dN1dp dN2dp dN3dp dN4dp];				
		case 'Solid188'
			s = paraCoords(:,1);
			t = paraCoords(:,2);
			p = paraCoords(:,3);
			dN1ds = -0.125*(1-t).*(1-p); dN2ds = 0.125*(1-t).*(1-p); 
			dN3ds = 0.125*(1+t).*(1-p);  dN4ds = -0.125*(1+t).*(1-p);
			dN5ds = -0.125*(1-t).*(1+p); dN6ds = 0.125*(1-t).*(1+p); 
			dN7ds = 0.125*(1+t).*(1+p);  dN8ds = -0.125*(1+t).*(1+p);
		
			dN1dt = -0.125*(1-s).*(1-p); dN2dt = -0.125*(1+s).*(1-p); 
			dN3dt = 0.125*(1+s).*(1-p);  dN4dt = 0.125*(1-s).*(1-p);
			dN5dt = -0.125*(1-s).*(1+p); dN6dt = -0.125*(1+s).*(1+p); 
			dN7dt = 0.125*(1+s).*(1+p);  dN8dt = 0.125*(1-s).*(1+p);
		
			dN1dp = -0.125*(1-s).*(1-t); dN2dp = -0.125*(1+s).*(1-t); 
			dN3dp = -0.125*(1+s).*(1+t); dN4dp = -0.125*(1-s).*(1+t);
			dN5dp = 0.125*(1-s).*(1-t);  dN6dp = 0.125*(1+s).*(1-t); 
			dN7dp = 0.125*(1+s).*(1+t);  dN8dp = 0.125*(1-s).*(1+t);
			
			dN = zeros(3*length(s), 8);
			dN(1:3:end,:) = [dN1ds dN2ds dN3ds dN4ds dN5ds dN6ds dN7ds dN8ds];
			dN(2:3:end,:) = [dN1dt dN2dt dN3dt dN4dt dN5dt dN6dt dN7dt dN8dt];
			dN(3:3:end,:) = [dN1dp dN2dp dN3dp dN4dp dN5dp dN6dp dN7dp dN8dp];			
		case 'Shell133'
			s = paraCoords(:,1);
			t = paraCoords(:,2);
			
		case 'Shell144'
			s = paraCoords(:,1);
			t = paraCoords(:,2);
			
	end
end