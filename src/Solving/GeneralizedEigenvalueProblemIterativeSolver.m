function [eigVecs eigVals flag] = GeneralizedEigenvalueProblemIterativeSolver(numEVs)
	global GPU_;
	global K_; global M_; global tol_;
	flag = 1; eigVals = []; eigVecs = [];
	if strcmp(GPU_, 'ON')	
		global gpuK_;
		[gpuK_ opt] = TransferBigMat2GPU(K_);
		if 0==opt
			Afun = @CGsolver_GPU;
		else
			global Lp_; Lp_ = ichol(K_);
			Afun = @CGsolver;	
		end
	else		
		global Lp_; Lp_ = ichol(K_);
		Afun = @CGsolver;	
	end
	[eigVecs, eigVals, flag] = eigs(Afun, length(M_), M_, numEVs, ...
		'smallestabs', 'IsFunctionSymmetric', 1, 'IsSymmetricDefinite', 1, 'Tolerance', tol_);	
end

function sol = CGsolver(b)
	%% solving linear system like gpuK_ * sol = b via Conjugate Gradient Method
	global K_;
	global Lp_;
	global tol_;
	global maxIT_;
	
	n = length(b);
	normB = norm(b);
	its = 0;
	x = zeros(n,1);
	r1 = zeros(n,1);
	z1 = zeros(n,1);
	p2 = zeros(n,1);
		
	r1 = b - K_*x;
	if norm(r1)/normB <= tol_
		sol = b; disp('The right hand side vector b is approximately 0, so x=b.'); return;
	end	
	
	while its <= maxIT_
		z2 = Lp_'\(Lp_\r1);
		its = its + 1;
		if 1==its
			p2 = z2;
		else
			beta = r1'*z2/(r0'*z1);
			p2 = z2 + beta*p1;			
		end
		valMTV = K_*p2;	
		
		alpha = r1'*z2/(p2'*valMTV);
		x = x + alpha*p2;		
		r2 = r1 - alpha*valMTV;
		
		resnorm = norm(r2)/normB;
		if resnorm<tol_
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

	if its > maxIT_
		sol = x;
		warning('Exceed the maximum iterate numbers');
		disp(['The iterative process stops at residual = ' sprintf('%10.4f',norm(r2))]);		
	end
end

function sol = CGsolver_GPU(b)
	%% solving linear system like gpuK_ * sol = b via Conjugate Gradient Method on GPU
	global gpuK_;
	global tol_;	
	global maxIT_;
	
	n = length(b);
	b = gpuArray(b);
	normB = norm(b);
	its = 0;
	tmp = zeros(n,1,'gpuArray');
	x = tmp;
	r1 = tmp;
	z1 = tmp;
	p2 = tmp;
	
	nSubMat = length(gpuK_);
	Ax = tmp;
	for ii=1:1:nSubMat
		Ax = Ax + gpuK_(ii).mat*x;
	end
	r1 = b - Ax;
	
	if norm(r1)/normB <= tol_
		sol = gather(b); disp('The right hand side vector b is approximately 0, so x=b.'); return;
	end
	
	while its <= maxIT_
		z2 = r1;
		its = its + 1;
		if 1==its
			p2 = z2;
		else
			beta = r1'*z2/(r0'*z1);
			p2 = z2 + beta*p1;			
		end
		
		valMTV = tmp;
		for ii=1:1:nSubMat
			valMTV = valMTV + gpuK_(ii).mat*p2;
		end	
		
		alpha = r1'*z2/(p2'*valMTV);
		x = x + alpha*p2;		
		r2 = r1 - alpha*valMTV;
		
		resnorm = norm(r2)/normB;
		%disp([' It.: ' sprintf('%4i',its) ' Res.: ' sprintf('%16.6e',resnorm)]);
		if resnorm<tol_
			sol = gather(x); 
			disp(['CGsolver (on GPU) converged at iteration' sprintf('%5i', its) ' to a solution with relative residual' ...
					sprintf('%16.6e',resnorm)]);
			break;
		end		
		%%update
		z1 = z2;
		p1 = p2;
		r0 = r1;
		r1 = r2;
	end

	if its > maxIT_
		sol = gather(x); 
		warning('Exceed the maximum iterate numbers');
		disp(['The iterative process stops at residual = ' sprintf('%10.4f',norm(r2))]);		
	end
end

