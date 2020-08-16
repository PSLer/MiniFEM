function dShape = DeShapeFunction(varargin)	
	global eleType_;
	if 2==nargin
		s = varargin{1}; t = varargin{2};
		dN1ds = -(1-t); dN2ds = 1-t; 	dN3ds = 1+t; dN4ds = -(1+t);
		dN1dt = -(1-s); dN2dt = -(1+s); dN3dt = 1+s; dN4dt = 1-s;
		numCoord = length(s);
		dShape = zeros( eleType_.numNodeDOFs*numCoord, eleType_.numNode );
		for ii=1:1:numCoord
			var1 = 0.25 * [
				dN1ds(ii) dN2ds(ii) dN3ds(ii) dN4ds(ii)
				dN1dt(ii) dN2dt(ii) dN3dt(ii) dN4dt(ii)	
			];
			dShape(eleType_.numNodeDOFs*(ii-1)+1:eleType_.numNodeDOFs*ii,:) = var1;
		end
	elseif 3==nargin
		s = varargin{1}; t = varargin{2}; p = varargin{3};
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
		numCoord = length(s);
		dShape = zeros( eleType_.numNodeDOFs*numCoord, eleType_.numNode );
		for ii=1:1:numCoord
			var1 = [
				dN1ds(ii) dN2ds(ii) dN3ds(ii) dN4ds(ii) dN5ds(ii) dN6ds(ii) dN7ds(ii) dN8ds(ii)
				dN1dt(ii) dN2dt(ii) dN3dt(ii) dN4dt(ii) dN5dt(ii) dN6dt(ii) dN7dt(ii) dN8dt(ii)
				dN1dp(ii) dN2dp(ii) dN3dp(ii) dN4dp(ii) dN5dp(ii) dN6dp(ii) dN7dp(ii) dN8dp(ii)		
			];
			dShape( eleType_.numNodeDOFs*(ii-1)+1:eleType_.numNodeDOFs*ii,: ) = var1;
		end		
	else
		error('Wrong input for computing the 1st derivative of shape function!');
	end
end