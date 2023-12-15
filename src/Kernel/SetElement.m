function SetElement(et)
	%%For now, only work with element types below
	%%2D: 'Plane133', 'Plane144'
	%%2.5D: 'Shell133', 'Shell144'
	%%3D: 'Solid144', 'Solid188'
	global eleType_;
	switch et
		case 'Plane133', eleType_ = Plane133();
		case 'Plane144', eleType_ = Plane144();
		case 'Shell133', eleType_ = Shell133();
		case 'Shell144', eleType_ = Shell144();
		case 'Solid144', eleType_ = Solid144();
		case 'Solid188', eleType_ = Solid188();
		case 'Truss122', eleType_ = Truss122();
		case 'Truss123', eleType_ = Truss123();
		case 'Beam122', eleType_ = Beam122();
		case 'Beam123', eleType_ = Beam123();
		otherwise
			error('Undefined Element Type!');
	end
end

function val = ElementDescription()
	val = struct(				...
		'eleName',							0,	...
		'nEleNodes',						0, 	...
		'nEleNodeDOFs',						0, 	...
		'nEleStressComponents',				0,	...
		'nEleGaussIntegralPoints',			0,	...		
		'GaussIntegralPointsNaturalSpace',	0,	...
		'thickness',						0	...
	);	
end

function val = Plane133()
	%% 2D problem
	%% 1st-order Triangular plane element (3 nodes and 3 Gaussian integral points)
	%			3						*3
	%			|  \			 	
	%	y   	|    \						t
	%	|__x	|	 	\ 					|__s
	%			|	       \	 	
	%			1-----------2			*1			*2
	%			Node Ordering		Gauss IPs Ordering
	val = ElementDescription();
	val.eleName = 'Plane133';
	val.nEleNodes = 3;
	val.nEleNodeDOFs = 2;
	val.nEleStressComponents = 3;
	val.nEleGaussIntegralPoints = 3;
	val.GaussIntegralPointsNaturalSpace = [
		1/6		2/3		1/6
		1/6		1/6		2/3
		1/6		1/6		1/6
	];
end

function val = Plane144()
	%% 2D problem
	%% 1st-order Quadrilateral plane element (4 nodes and 4 Gaussian integral points)   
	%			4-----------3			*4			*3
	%			|		 	|
	%	    	|	y	 	|				t
	%			|	|__x	|				|__s
	%			|		 	|
	%			1-----------2			*1			*2
	%			Node Ordering		Gauss IPs Ordering
	val = ElementDescription();
	val.eleName = 'Plane144';
	val.nEleNodes = 4;
	val.nEleNodeDOFs = 2;
	val.nEleStressComponents = 3;
	val.nEleGaussIntegralPoints = 4;
	sqrt33 = sqrt(3)/3;
	val.GaussIntegralPointsNaturalSpace = [
		-sqrt33 	sqrt33 		sqrt33 		-sqrt33
		-sqrt33 	-sqrt33 	sqrt33 		sqrt33
		1.0			1.0			1.0			1.0
	];
end

function val = Shell133()
	%% 2.5D problem, e.g., thin-walled structure
	%% 1st-order Triangular shell element (3 nodes and 3 Gaussian integral points)
	val = ElementDescription();
	val.eleName = 'Shell133';
	val.nEleNodes = 3;
	val.nEleNodeDOFs = 6;
	val.nEleStressComponents = 6;
	val.nEleGaussIntegralPoints = 3;
	val.GaussIntegralPointsNaturalSpace = [
		2/3		1/6		1/6
		1/6		2/3		1/6
		1/6		1/6		1/6
	];
end

function val = Shell144()
	%% 2.5D problem, e.g., thin-walled structure
	%% 1st-order Quadrilateral shell element (3 nodes and 3 Gaussian integral points)
	val = ElementDescription();
	val.eleName = 'Shell144';
	val.nEleNodes = 4;
	val.nEleNodeDOFs = 6;
	val.nEleStressComponents = 6;
	val.nEleGaussIntegralPoints = 4;
	sqrt33 = sqrt(3)/3;
	val.GaussIntegralPointsNaturalSpace = [
		-sqrt33		sqrt33		sqrt33		-sqrt33
		-sqrt33		-sqrt33		sqrt33		sqrt33
		1			1			1			1
	];
end

function val = Solid144()
	%% 3D problem
	%% 1st-order Tetrahedral solid element (4 nodes and 4 Gaussian integral points)
	%    z											
	%    |__ x  (physical coordinate system)	
	%   / 
	%  y  

	val = ElementDescription();
	val.eleName = 'Solid144';
	val.nEleNodes = 4;
	val.nEleNodeDOFs = 3;
	val.nEleStressComponents = 6;
	val.nEleGaussIntegralPoints = 4;
	alp = 0.58541020;
	bet = 0.13819660;	
	w = 1/6/4;
	val.GaussIntegralPointsNaturalSpace = [
		bet		alp		bet		bet
		bet		bet		alp		bet
		bet		bet		bet		alp
		w		w		w		w
	];
end

function val = Solid188()
	%% 3D problem
	%% 1st-order Hexahedral solid element (8 nodes and 8 Gaussian integral points)
	%    z											
	%    |__ x  (physical coordinate system)	
	%   / 
	%  -y                            
	%            8--------------7      		*8			*7
	%			/ |			   /|		*5			*6
	%          5-------------6	|				p
	%          |  |          |  |				|__s (nature coordinate system)
	%          |  |          |  |			   /-t
	%          |  |          |  |   		*4			*3
	%          |  4----------|--3  		*1			*2
	%     	   | /           | /
	%          1-------------2             
	%			Node Ordering			Gauss IPs Ordering
	val = ElementDescription();
	val.eleName = 'Solid188';
	val.nEleNodes = 8;
	val.nEleNodeDOFs = 3;
	val.nEleStressComponents = 6;
	val.nEleGaussIntegralPoints = 8;
	sqrt33 = sqrt(3)/3;
	val.GaussIntegralPointsNaturalSpace = [
		-sqrt33		sqrt33		sqrt33		-sqrt33		-sqrt33		sqrt33		sqrt33		-sqrt33
		-sqrt33		-sqrt33		sqrt33		sqrt33		-sqrt33		-sqrt33		sqrt33		sqrt33
		-sqrt33		-sqrt33		-sqrt33		-sqrt33		sqrt33		sqrt33		sqrt33		sqrt33
		1			1			1			1			1			1			1			1	
	];
end

function val = Truss122()
	%% 2D Frame problem, components are assumed to be Trusses
	val = ElementDescription();
	val.eleName = 'Truss122';
	val.nEleNodes = 2;
	val.nEleNodeDOFs = 2;
end

function val = Truss123()
	%% 3D Frame problem, components are assumed to be Trusses
	val = ElementDescription();
	val.eleName = 'Truss123';
	val.nEleNodes = 2;
	val.nEleNodeDOFs = 3;
end

function val = Beam122()
	%% 2D Frame problem, components are assumed to be Beams
	val = ElementDescription();
	val.eleName = 'Beam122';
	val.nEleNodes = 2;
	val.nEleNodeDOFs = 3;
end

function val = Beam123()
	%% 2D Frame problem, components are assumed to be Beams
	val = ElementDescription();
	val.eleName = 'Beam123';
	val.nEleNodes = 2;
	val.nEleNodeDOFs = 6;
end

