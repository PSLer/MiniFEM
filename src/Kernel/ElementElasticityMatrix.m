function D = ElementElasticityMatrix(E, nu)	
	global eleType_;
	switch eleType_.eleName
		case 'Plane133'
			HL = HookeLaw_PLANE(E, nu);
			D = zeros(9);
			for ii=1:3
				index = (ii-1)*3+1:ii*3;
				D(index,index) = HL;
			end				
		case 'Plane144'
			HL = HookeLaw_PLANE(E, nu);
			D = zeros(12);
			for ii=1:4
				index = (ii-1)*3+1:ii*3;
				D(index,index) = HL;
			end		
		case 'Solid144'
			HL = HookeLaw_SOLID(E, nu);
			D = zeros(24);
			for ii=1:4
				index = (ii-1)*6+1:ii*6;
				D(index,index) = HL;
			end			
		case 'Solid188'
			HL = HookeLaw_SOLID(E, nu);
			D = zeros(48);
			for ii=1:8
				index = (ii-1)*6+1:ii*6;
				D(index,index) = HL;
			end			
		case 'Shell133'
			HL = HookeLaw_SHELL(E, nu);
			D = zeros(18);
			for ii=1:3
				index = (ii-1)*6+1:ii*6;
				D(index,index) = HL;
			end				
		case 'Shell144'
			HL = HookeLaw_SHELL(E, nu);
			D = zeros(24);
			for ii=1:4
				index = (ii-1)*6+1:ii*6;
				D(index,index) = HL;
			end				
	end
	D = sparse(D);
end

function HL = HookeLaw_PLANE(E, nu)
	HL = [
		E/(1-nu^2)		E*nu/(1-nu^2)	0
		E*nu/(1-nu^2)	E/(1-nu^2)		0
		0				0				E/2/(1+nu)
	];
end

function HL = HookeLaw_SOLID(E, nu)
	cons1 = (1+nu)*(1-2*nu);
	cons2 = 2*(1+nu);
	HL = [
		E*(1-nu)/cons1	E*nu/cons1		E*nu/cons1		0			0		0
		E*nu/cons1		E*(1-nu)/cons1	E*nu/cons1		0			0		0
		E*nu/cons1		E*nu/cons1		E*(1-nu)/cons1	0			0		0
		0				0				0				E/cons2		0		0
		0				0				0				0			E/cons2	0
		0				0				0				0			0		E/cons2
	];
end

function HL = HookeLaw_SHELL(E, nu)
	HL = E/(1-nu^2)*[
		1	nu	0	0			0			0
		nu	1	0	0			0			0
		0	0	0	0			0			0
		0	0	0	0.5*(1-nu)	0			0
		0	0	0	0			5/12*(1-nu)	0
		0	0	0	0			0			5/12*(1-nu);
	];
end