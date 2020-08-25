function D = ElementElasticityMatrix()	
	global domainType_;
	global eleType_;
	HL = HookeLaw();
	var = zeros(eleType_.numStressComponents);
	switch domainType_
		case '2D'
			D = [
				HL	var	var	var
				var	HL	var	var
				var	var	HL	var
				var	var	var	HL
			];		
		case '3D'
			D = [
				HL	var	var	var	var	var	var	var
				var	HL	var	var	var	var	var	var
				var	var	HL	var	var	var	var	var
				var	var	var	HL	var	var	var	var
				var	var	var	var	HL	var	var	var
				var	var	var	var	var	HL	var	var
				var	var	var	var	var	var	HL	var
				var	var	var	var	var	var	var	HL
			];		
	end
	D = sparse(D);
end