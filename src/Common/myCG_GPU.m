function x = myCG_GPU(A, b, printP)
	global tol_; global maxIT_;
	tol = tol_; maxIT = maxIT_;
	n = length(b);
	normB = norm(b);
	its = 0;
	tmp = zeros(n,1,'gpuArray');
	x = tmp;
	r1 = tmp;
	z1 = tmp;
	p2 = tmp;
	
	%r1 = b - A*x;
	nSubMat = length(A);
	Ax = tmp;
	for ii=1:nSubMat
		Ax = Ax + A(ii).mat*x;
	end
	r1 = b - Ax;
	while its <= maxIT
		z2 = r1;
		its = its + 1;
		if 1==its
			p2 = z2;
		else
			beta = r1'*z2/(r0'*z1);
			p2 = z2 + beta*p1;			
		end
		
		valMTV = tmp;
		for ii=1:nSubMat
			valMTV = valMTV + A(ii).mat*p2;
		end			
		
		alpha = r1'*z2/(p2'*valMTV);
		x = x + alpha*p2;		
		r2 = r1 - alpha*valMTV;
		
		resnorm = norm(r2)/normB;
		if strcmp(printP, 'printP_ON')
			disp([' It.: ' sprintf('%4i',its) ' Res.: ' sprintf('%16.6e',resnorm)]);
		end
		if resnorm<tol
			x = gather(x); 
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
		x = gather(x); 
		warning('Exceed the maximum iterate numbers');
		disp(['The iterative process stops at residual = ' sprintf('%10.4e',norm(r2))]);		
	end
end