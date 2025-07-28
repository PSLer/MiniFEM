function [D, varargout] = ElementElasticityMatrix(E, nu, varargin)	
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
			t = varargin{1}; %% Shell Thickness
			[HLm, HLb, HLs] = HookeLaw_SHELL(E, nu, t);
			Dmem = zeros(9);
			Dbend = zeros(9);
			Dshear = zeros(6);
			for jj=1:3
				Dmem((jj-1)*3+1:jj*3, (jj-1)*3+1:jj*3) = HLm;
				Dbend((jj-1)*3+1:jj*3, (jj-1)*3+1:jj*3) = HLb;
				Dshear((jj-1)*2+1:jj*2, (jj-1)*2+1:jj*2) = HLs;
			end
			D = Dmem;
			nargout = 3;
			varargout{1} = sparse(Dbend);
			varargout{2} = sparse(Dshear);
		case 'Shell144'
			t = varargin{1}; %% Shell Thickness
			[HLm, HLb, HLs] = HookeLaw_SHELL(E, nu, t);
			Dmem = zeros(12);
			Dbend = zeros(12);
			Dshear = zeros(8);
			for jj=1:4
				Dmem((jj-1)*3+1:jj*3, (jj-1)*3+1:jj*3) = HLm;
				Dbend((jj-1)*3+1:jj*3, (jj-1)*3+1:jj*3) = HLb;
				Dshear((jj-1)*2+1:jj*2, (jj-1)*2+1:jj*2) = HLs;
			end
			D = Dmem;
			nargout = 3;
			varargout{1} = sparse(Dbend);
			varargout{2} = sparse(Dshear);			
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

function [HLm, HLb, HLs] = HookeLaw_SHELL(E, nu, t)
	% Plane stress stiffness matrix
	%% Membrane
	HLm = E/(1-nu^2)*[
			1	nu	0
			nu	1	0
			0	0	(1 - nu)/2
	];
	%% Bending
	%% t: Shell Thickness
	HLb = E*t^2/(12*(1-nu^2))*[
		1	nu	0
		nu	1	0
		0	0	(1 - nu)/2
	];
	%% Shear
	kappa = 5/6;
	HLs = kappa*E/(2*(1+nu))*eye(2);	
end