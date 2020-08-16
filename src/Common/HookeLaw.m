function D = HookeLaw()
	global domainType_;
	global moduls_; global poissonRatio_; 
	E = moduls_; nu = poissonRatio_;
	switch domainType_
		case '2D'
			D = zeros(3);
			D(1,1) = E/(1-nu^2); D(1,2) = E*nu/(1-nu^2);		
			D(2,1) = D(1,2); D(2,2) = D(1,1);	
			D(3,3) = E/2/(1+nu);
		case '3D'			
			D = zeros(6);
			cons1 = (1+nu)*(1-2*nu);
			cons2 = 2*(1+nu);
			D(1,1) = E*(1-nu)/cons1; D(1,2) = E*nu/cons1; D(1,3) = D(1,2);
			D(2,1) = D(1,2); D(2,2) = D(1,1); D(2,3) = D(2,1);
			D(3,1) = D(1,3); D(3,2) = D(2,3); D(3,3) = D(2,2);
			D(4,4) = E/cons2;
			D(5,5) = D(4,4);
			D(6,6) = D(5,5);
	end
end