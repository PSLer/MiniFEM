function x = myGmres(AtX, b, restart, tol, maxIT, preCond, Lp, Up, printP)
	%%0. arguments introduction
	%%A --- system matrix
	%%b --- right hand section
	%%restart --- size of the Krylov subspace
	%%tol --- stopping condition: resnrm < discrepancy
	%%maxIT --- maximum number of iterations
	%%preCond --- switch for precondition 'ON'==with precondition; 'OFF'==non precondition
	%%Lp, Up --- preconditioners from iLU algorithm
	%%printP --- print iterative process
	
	%%1. initialize data
	n = length(b);
	its = 0;
	epsmac = 1.0e-15; %%tolerance for stopping criterion,
	x = zeros(n,1);
	resVec = zeros(n,1);
	if strcmp(preCond, 'ON')
		b = Up\(Lp\b);
	end
	rhsnorm = norm(b);	
	if rhsnorm<=epsmac
		x = b; disp('The right hand side vector b is approximately 0, so x=b.'); return;
	end
	b = b/rhsnorm;
	
	%%2. outer loop for restart
	while its<=maxIT
		%%2.1 initialize residual vector and alloc memory space for Hessenberg matrix and Krylov subspace
		resList = zeros(restart+1,1);
		HssMat = zeros(restart+1,restart);
		%KrylovSpace = zeros(n,restart+1);
		KrylovSpace = [];
		%%2.2 compute initial residual vector
		if strcmp(preCond, 'ON')
			resVec = Up\(Lp\AtX(x));
		else
			resVec = AtX(x);
		end
		resVec = b-resVec;
		
		%%2.3 unitize the initial residual vector
		beta = norm(resVec);
		if beta<=epsmac
			x = rhsnorm*b; disp('The right hand side is the solution.'); return;
		end
		resList(1) = beta;
		KrylovSpace(:,1) = resVec/beta;
		
		%%2.4 inner loop
		p=0;
		c1 = zeros(restart,1); s1 = zeros(restart,1);
		for ii=1:1:restart
			%%2.4.1 Arnoldi process
			%%2.4.1.1 generate krylov vector
			if strcmp(preCond, 'ON')
				resVec = Up\(Lp\AtX(KrylovSpace(:,ii)));
			else
				resVec = AtX(KrylovSpace(:,ii));
			end
			%%2.4.1.2 compute Hessenberg matrix and Arnoldi vector
			%%@modified Gram-Schmidt orthogonalization
			for jj=1:1:ii
				HssMat(jj,ii) = KrylovSpace(:,jj)'*resVec;
				resVec = resVec - KrylovSpace(:,jj)*HssMat(jj,ii);
			end
			%%@classic Gram-Schmidt orthogonalization
			% HssMat(1:ii,ii) = KrylovSpace(:,1:ii)'*resVec;
			% resVec = resVec - sum(KrylovSpace(:,1:ii)*HssMat(1:ii,ii),2);
			
			HssMat(1+ii,ii)	= norm(resVec);
			KrylovSpace(:,1+ii) = resVec/HssMat(1+ii,ii);
			%% the break down condition
			if HssMat(1+ii,ii) <= epsmac, break; end
			
			%%2.4.2 Givens rotations for QR decomposition of Hessenberg matrix
			for jj=1:1:ii-1
				HssMat(jj:jj+1,ii) = [c1(jj) s1(jj); -s1(jj) c1(jj)]*HssMat(jj:jj+1,ii);
			end
			divisor = norm(HssMat(ii:ii+1,ii));
			if 0==divisor, divisor = epsmac; end
			c1(ii) = HssMat(ii,ii)/divisor; s1(ii) = HssMat(ii+1,ii)/divisor;
			HssMat(ii,ii) = c1(ii)*HssMat(ii,ii) + s1(ii)*HssMat(ii+1,ii);
			HssMat(ii+1,ii) = 0;
			resj = resList(ii);
			resList(ii) = c1(ii)*resj;
			resList(ii+1) = -s1(ii)*resj;
			
			%%2.4.3 update variables and estimate the convergence
			its = its+1;
			p = p+1;
			resnorm = abs(resList(ii+1));
			if strcmp(printP, 'printP_ON')
				disp([' It.: ' sprintf('%4i',its) ' Res.: ' sprintf('%16.6e',resnorm)]);
			end
			if resnorm<tol, break; end
			if its>maxIT, break; end
		end
		
		%%2.5 calculate the solution vector
		y = HssMat(1:p,1:p)\resList(1:p);
		x = x+KrylovSpace(:,1:p)*y;		
		if resnorm<tol || its>maxIT
			if resnorm<tol
				x = rhsnorm*x;
				disp(['gmres(' sprintf('%4i',restart) ') converged at outer iteration' sprintf('%4i', ceil(its/restart))...
					' (inner iteration' sprintf('%4i',mod(its, restart)) ') to a solution with relative residual' ...
						sprintf('%16.6e',resnorm)]);
			elseif its>maxIT
				warning('Exceed the maximum iterate numbers');
				disp(['The iterative process stops at residual = ' sprintf('%10.4f',resnorm)]);
			end
			return;
		end
	end
end