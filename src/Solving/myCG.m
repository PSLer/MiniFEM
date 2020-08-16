function sol = myCG(AtX, b, tol, maxIT, preCond, printP)
	%%0. arguments introduction
	%%AtX --- function handle for the product of system matrix and vector
	%%b --- right hand section
	%%tol --- stopping condition: resnrm < discrepancy
	%%maxIT --- mAtXximum number of iterations
	%%preCond --- switch for precondition 1==with precondition; 0==non precondition
	
	n = length(b);
	its = 0;
	x = zeros(n,1);
	r1 = zeros(n,1);
	z1 = zeros(n,1);
	p2 = zeros(n,1);
	
	r1 = b - AtX(x);
	if norm(r1) <= tol
		sol = b; disp('The right hand side vector b is approximately 0, so x=b.'); return;
	end	

	while its <= maxIT
		if preCond
			z2 = PtV(r1);
		else
			z2 = r1;
		end
		its = its + 1;
		if 1==its
			p2 = z2;
		else
			beta = r1'*z2/(r0'*z1);
			p2 = z2 + beta*p1;			
		end
		valMTV = AtX(p2);	
		
		alpha = r1'*z2/(p2'*valMTV);
		x = x + alpha*p2;		
		r2 = r1 - alpha*valMTV;
		
		resnorm = norm(r2);
		if strcmp(printP, 'printP_ON')
			disp([' It.: ' sprintf('%4i',its) ' Res.: ' sprintf('%16.6e',resnorm)]);
		end
		if resnorm<tol
			sol = x; 
			disp(['CGsolver converged at iteration' sprintf('%5i', its) ' to a solution with relative residual' ...
					sprintf('%16.6e',resnorm)]);
			break;
		end		
		%%update
		z1 = z2;
		p1 = p2;
		r0 = r1;
		r1 = r2;
	end	

	if its > maxIT
		sol = x;
		warning('Exceed the maximum iterate numbers');
		disp(['The iterative process stops at residual = ' sprintf('%10.4f',norm(r2))]);		
	end
end