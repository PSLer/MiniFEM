function D = ElementElasticityMatrix(E, nu)	
	global eleType_;
	switch eleType_.eleName
		case 'Plane133'
			HL = HookeLaw('PLANE', E, nu);
			D = zeros(9);
			for ii=1:3
				index = (ii-1)*3+1:ii*3;
				D(index,index) = HL;
			end				
		case 'Plane144'
			HL = HookeLaw('PLANE', E, nu);
			D = zeros(12);
			for ii=1:4
				index = (ii-1)*3+1:ii*3;
				D(index,index) = HL;
			end		
		case 'Solid144'
			HL = HookeLaw('SOLID', E, nu);
			D = zeros(24);
			for ii=1:4
				index = (ii-1)*6+1:ii*6;
				D(index,index) = HL;
			end			
		case 'Solid188'
			HL = HookeLaw('SOLID', E, nu);
			D = zeros(48);
			for ii=1:8
				index = (ii-1)*6+1:ii*6;
				D(index,index) = HL;
			end			
		case 'Shell133'
			HL = HookeLaw('SHELL', E, nu);
			
		case 'Shell144'
			HL = HookeLaw('SHELL', E, nu);
	end
	D = sparse(D);
end

function HL = HookeLaw(eleOpt, E, nu)
	switch eleOpt
		case 'PLANE'
			HL = zeros(3);
			HL(1,1) = E/(1-nu^2); HL(1,2) = E*nu/(1-nu^2);		
			HL(2,1) = HL(1,2); HL(2,2) = HL(1,1);	
			HL(3,3) = E/2/(1+nu);	
		case 'SOLID'			
			HL = zeros(6);
			cons1 = (1+nu)*(1-2*nu);
			cons2 = 2*(1+nu);
			HL(1,1) = E*(1-nu)/cons1; HL(1,2) = E*nu/cons1; HL(1,3) = HL(1,2);
			HL(2,1) = HL(1,2); HL(2,2) = HL(1,1); HL(2,3) = HL(2,1);
			HL(3,1) = HL(1,3); HL(3,2) = HL(2,3); HL(3,3) = HL(2,2);
			HL(4,4) = E/cons2;
			HL(5,5) = HL(4,4);
			HL(6,6) = HL(5,5);
		case 'SHELL'
			
	end
end