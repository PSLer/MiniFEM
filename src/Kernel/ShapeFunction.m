function N = ShapeFunction(paraCoords)
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
			N = zeros(length(s), 3);
			N(:,1) = s;
			N(:,2) = t;
			N(:,3) = 1-s-t;		
		case 'Plane144'
			%				   	   __s (parametric coordinate system)
			%				  	 /-t
			%				*4			*3
			%			*1			*2
			%
			%				nodes		
			s = paraCoords(:,1);
			t = paraCoords(:,2);
			N = zeros(length(s), 4);
			N(:,1) = 0.25*(1-s).*(1-t);
			N(:,2) = 0.25*(1+s).*(1-t);
			N(:,3) = 0.25*(1+s).*(1+t);
			N(:,4) = 0.25*(1-s).*(1+t);			
		case 'Solid144'
			N = paraCoords;
		case 'Solid188'
			%				*8			*7
			%			*5			*6
			%					p
			%				   |__s (parametric coordinate system)
			%				  /-t
			%				*4			*3
			%			*1			*2
			%
			%				nodes
			s = paraCoords(:,1);
			t = paraCoords(:,2);
			p = paraCoords(:,3);
			N = zeros(length(s), 8);
			N(:,1) = 0.125*(1-s).*(1-t).*(1-p);
			N(:,2) = 0.125*(1+s).*(1-t).*(1-p);
			N(:,3) = 0.125*(1+s).*(1+t).*(1-p);
			N(:,4) = 0.125*(1-s).*(1+t).*(1-p);
			N(:,5) = 0.125*(1-s).*(1-t).*(1+p);
			N(:,6) = 0.125*(1+s).*(1-t).*(1+p);
			N(:,7) = 0.125*(1+s).*(1+t).*(1+p);
			N(:,8) = 0.125*(1-s).*(1+t).*(1+p);				
		case 'Shell133'
			s = paraCoords(:,1);
			t = paraCoords(:,2);			
		case 'Shell144'
			s = paraCoords(:,1);
			t = paraCoords(:,2);	
	end	
end