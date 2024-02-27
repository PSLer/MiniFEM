function SetMaterialProperty(mp)
	global material_;
	mp = mp(:);
	material_ = MaterialList(mp(1));
	for ii=2:numel(mp)
		material_(ii) = MaterialList(mp(ii));
	end
end

function materialMode = MaterialList(optMP)
	%%For now, only work with Linear Elasticity Materials under the Standard Unit System
	materialMode = struct('name', [], 'modulus', 0, 'poissonRatio', 0, 'density', 0); 
	switch optMP
		case 'Unit'
			materialMode.name = 'Unit';
			materialMode.modulus = 1;
			materialMode.poissonRatio = 0.3;
			materialMode.density = 1;
		case 'Steel'
			materialMode.name = 'Steel';
			materialMode.modulus = 2.1e11;
			materialMode.poissonRatio = 0.3;
			materialMode.density = 7900;		
		case 'Aluminium'
			materialMode.name = 'Aluminium';
			materialMode.modulus = 7.0e10;
			materialMode.poissonRatio = 0.3;
			materialMode.density = 2700;
		case 'Concrete'
			materialMode.name = 'Concrete';
			materialMode.modulus = 4.0e10;
			materialMode.poissonRatio = 0.2;
			materialMode.density = 2350;			
		case '4FrameComparison'
			materialMode.name = '4FrameComparison';
			materialMode.modulus = 68950;
			materialMode.poissonRatio = 0.3;
			materialMode.density = 2700;			
		otherwise
			error('Undefined Material!');
	end
end