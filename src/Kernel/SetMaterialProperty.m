function SetMaterialProperty(mp)
	%%For now, only work with Linear Elasticity Materials under the Standard Unit System
	global material_;
	material_ = struct('modulus', 0, 'poissonRatio', 0, 'density', 0); 
	switch mp
		case 'Unit'
			material_.modulus = 1;
			material_.poissonRatio = 0.3;
			material_.density = 1;
		case 'Steel'
			material_.modulus = 2.1e11;
			material_.poissonRatio = 0.3;
			material_.density = 7900;		
		case 'Aluminium'
			material_.modulus = 7.0e10;
			material_.poissonRatio = 0.3;
			material_.density = 2700;			
		otherwise
			error('Undefined Material!');
	end
end