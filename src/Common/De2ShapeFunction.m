function d2Shape = De2ShapeFunction(varargin)	
	if 2==nargin
		s = varargin{1}; t = varargin{2};
		dN1dss = 0; dN2dss = 0; dN3dss = 0; dN4dss = 0;
		dN1dtt = 0; dN2dtt = 0; dN3dtt = 0; dN4dtt = 0;
		dN1dst = 0.25; dN2dst = -0.25; dN3dst = 0.25; dN4dst = -0.25;	
		numCoord = length(s);
		d2Shape = zeros(3*numCoord, 4);
		d2Shape(1:3:end,:) = repmat([dN1dss	dN2dss	dN3dss	dN4dss], numCoord, 1);
		d2Shape(2:3:end,:) = repmat([dN1dtt	dN2dtt	dN3dtt	dN4dtt], numCoord, 1);
		d2Shape(3:3:end,:) = repmat([dN1dst	dN2dst	dN3dst	dN4dst], numCoord, 1);
	elseif 3==nargin
		s = varargin{1}; t = varargin{2}; p = varargin{3};
		dN1dss = 0; dN2dss = 0; dN3dss = 0;  dN4dss = 0;	
		dN5dss = 0; dN6dss = 0; dN7dss = 0;  dN8dss = 0;
		
		dN1dtt = 0; dN2dtt = 0; dN3dtt = 0; dN4dtt = 0;
		dN5dtt = 0; dN6dtt = 0; dN7dtt = 0; dN8dtt = 0;
		
		dN1dpp = 0; dN2dpp = 0; dN3dpp = 0; dN4dpp = 0;
		dN5dpp = 0; dN6dpp = 0; dN7dpp = 0; dN8dpp = 0;
		
		dN1dst = 1-p;		dN2dst = -(1-p);		dN3dst = 1-p;		dN4dst = -(1-p);
		dN5dst = 1+p;		dN6dst = -(1+p);		dN7dst = 1+p;		dN8dst = -(1+p);
		
		dN1dsp = 1-t;		dN2dsp = -(1-t);		dN3dsp = -(1+t);	dN4dsp = 1+t;
		dN5dsp = -(1-t);	dN6dsp = 1-t;			dN7dsp = 1+t;		dN8dsp = -(1+t);
		
		dN1dtp = 1-s;		dN2dtp = 1+s;			dN3dtp = -(1+s);	dN4dtp = -(1-s);
		dN5dtp = -(1-s);	dN6dtp = -(1+s);		dN7dtp = 1+s;		dN8dtp = 1-s;
		
		numCoord = length(s);
		d2Shape = zeros(6*numCoord, 8);
		d2Shape(1:6:end) = repmat([dN1dss dN2dss dN3dss dN4dss dN5dss dN6dss dN7dss dN8dss], numCoord, 1);
		d2Shape(2:6:end) = repmat([dN1dtt dN2dtt dN3dtt dN4dtt dN5dtt dN6dtt dN7dtt dN8dtt], numCoord, 1);
		d2Shape(3:6:end) = repmat([dN1dpp dN2dpp dN3dpp dN4dpp dN5dpp dN6dpp dN7dpp dN8dpp], numCoord, 1);
		d2Shape(4:6:end) = [dN1dtp dN2dtp dN3dtp dN4dtp dN5dtp dN6dtp dN7dtp dN8dtp];
		d2Shape(5:6:end) = [dN1dsp dN2dsp dN3dsp dN4dsp dN5dsp dN6dsp dN7dsp dN8dsp];
		d2Shape(6:6:end) = [dN1dst dN2dst dN3dst dN4dst dN5dst dN6dst dN7dst dN8dsp];
		d2Shape = 0.125 * d2Shape;
	else
		error('Wrong input for computing the 2nd derivative of shape function!');
	end	
end
