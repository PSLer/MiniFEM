function x = myCG(ATX, Preconditioning, b, printP)
	global tol_; global maxIT_;
	tol = tol_; maxIT = maxIT_;
	n = length(b);
	normB = norm(b);
	its = 0;
	x = zeros(n,1);
	r1 = b - ATX(x);
	z1 = zeros(n,1);

	while its <= maxIT
		its = its + 1;
		z2 = Preconditioning(r1);
		if 1==its
			p2 = z2;
		else
			beta = r1'*z2/(r0'*z1);
			p2 = z2 + beta*p1;			
		end
		valMTV = ATX(p2);	
		alpha = r1'*z2/(p2'*valMTV);
		x = x + alpha*p2;		
		r2 = r1 - alpha*valMTV;
		
		resnorm = norm(r2)/normB;
		if strcmp(printP, 'printP_ON')
			disp([' It.: ' sprintf('%4i',its) ' Res.: ' sprintf('%16.6e',resnorm)]);
		end
		if resnorm<tol
			disp(['Conjugate Gradient Solver Converged at Iteration' sprintf('%5i', its) ' to a Solution with Relative Residual' ...
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
		warning('Exceed the maximum iterate numbers');
		disp(['The iterative process stops at residual = ' sprintf('%10.4f',norm(r2))]);		
	end
end

