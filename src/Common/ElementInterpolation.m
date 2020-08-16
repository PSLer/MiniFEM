function N = ElementInterpolation(varargin)
	if 2~=nargin, error('Wrong input for element interpolation!'); end
	paraCoord = varargin{1};
	if 2==length(varargin{1})
		%			4	|t	3
		%	  (-1,1)----|----(1,1)
		%			|	|	|
		%		--------------------->s
		%			|	|	|			
		%	 (-1,-1)----|----(1,-1)
		%			1	|	2	
		sF = ShapeFunction(paraCoord(1), paraCoord(2));
		switch varargin{2}
			case 'coord'
				% N = sparse(2,8); ii = 2*(1:4);
				% N(1,ii-1) = sF;
				% N(2,ii) = sF;
				%%-------------------------------------------
				N = [sF(1) 0 sF(2) 0 sF(3) 0 sF(4) 0
					 0 sF(1) 0 sF(2) 0 sF(3) 0 sF(4)];
			case 'stress'	
				% N = sparse(3,12); ii = 3*(1:4);
				% N(1,ii-2) = sF;
				% N(2,ii-1) = sF;	
				% N(3,ii) = sF;
				%%-------------------------------------------
				N = [sF(1) 0 0 sF(2) 0 0 sF(3) 0 0 sF(4) 0 0
					 0 sF(1) 0 0 sF(2) 0 0 sF(3) 0 0 sF(4) 0
					 0 0 sF(1) 0 0 sF(2) 0 0 sF(3) 0 0 sF(4)];				
			otherwise
				error('Wrong input for element interpolation!');
		end
	elseif 3==length(varargin{1})
		%    z
		%    |__ x
		%   / 
		%  y                            
		%            8--------------7      	
		%			/ |			   /|	
		%          5-------------6	|
		%          |  |          |  |
		%          |  |          |  |	
		%          |  |          |  |   
		%          |  4----------|--3  
		%     	   | /           | /
		%          1-------------2             
		%			Hexahedral element	
		sF = ShapeFunction(paraCoord(1), paraCoord(2), paraCoord(3));
		switch varargin{2}
			case 'coord'
				% N = sparse(3,24); ii = 3*(1:8);
				% N(1,ii-2) = sF;
				% N(2,ii-1) = sF;	
				% N(3,ii) = sF;	
				%%-------------------------------------------
				N = [sF(1) 0 0 sF(2) 0 0 sF(3) 0 0 sF(4) 0 0 sF(5) 0 0 sF(6) 0 0 sF(7) 0 0 sF(8) 0 0
					 0 sF(1) 0 0 sF(2) 0 0 sF(3) 0 0 sF(4) 0 0 sF(5) 0 0 sF(6) 0 0 sF(7) 0 0 sF(8) 0
					 0 0 sF(1) 0 0 sF(2) 0 0 sF(3) 0 0 sF(4) 0 0 sF(5) 0 0 sF(6) 0 0 sF(7) 0 0 sF(8)];				
			case 'stress'
				% N = sparse(6,48); ii = 6*(1:8);
				% N(1,ii-5) = sF;
				% N(2,ii-4) = sF;
				% N(3,ii-3) = sF;
				% N(4,ii-2) = sF;
				% N(5,ii-1) = sF;	
				% N(6,ii) = sF;
				%%-------------------------------------------
				N = [sF(1) 0 0 0 0 0 sF(2) 0 0 0 0 0 sF(3) 0 0 0 0 0 sF(4) 0 0 0 0 0 sF(5) 0 0 0 0 0 sF(6) 0 0 0 0 0 sF(7) 0 0 0 0 0 sF(8) 0 0 0 0 0
					 0 sF(1) 0 0 0 0 0 sF(2) 0 0 0 0 0 sF(3) 0 0 0 0 0 sF(4) 0 0 0 0 0 sF(5) 0 0 0 0 0 sF(6) 0 0 0 0 0 sF(7) 0 0 0 0 0 sF(8) 0 0 0 0
					 0 0 sF(1) 0 0 0 0 0 sF(2) 0 0 0 0 0 sF(3) 0 0 0 0 0 sF(4) 0 0 0 0 0 sF(5) 0 0 0 0 0 sF(6) 0 0 0 0 0 sF(7) 0 0 0 0 0 sF(8) 0 0 0
					 0 0 0 sF(1) 0 0 0 0 0 sF(2) 0 0 0 0 0 sF(3) 0 0 0 0 0 sF(4) 0 0 0 0 0 sF(5) 0 0 0 0 0 sF(6) 0 0 0 0 0 sF(7) 0 0 0 0 0 sF(8) 0 0
					 0 0 0 0 sF(1) 0 0 0 0 0 sF(2) 0 0 0 0 0 sF(3) 0 0 0 0 0 sF(4) 0 0 0 0 0 sF(5) 0 0 0 0 0 sF(6) 0 0 0 0 0 sF(7) 0 0 0 0 0 sF(8) 0 
					 0 0 0 0 0 sF(1) 0 0 0 0 0 sF(2) 0 0 0 0 0 sF(3) 0 0 0 0 0 sF(4) 0 0 0 0 0 sF(5) 0 0 0 0 0 sF(6) 0 0 0 0 0 sF(7) 0 0 0 0 0 sF(8)];	
			otherwise
				error('Wrong input for element interpolation!');
		end	
	else
		error('Wrong input for element interpolation!');
	end
end