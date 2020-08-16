function [eigVecs eigVals flag] = GeneralizedEigenvalueProblemDirectSolver(numEVs)
	global K_; global M_; global tol_;
	flag = 1; eigVals = []; eigVecs = [];
	[Lfac Ufac Pfac Qfac Rfac] = lu(K_); %%xu = Q * (U \ (L \ (P * (R \ b)))) 
	Afun = @(x) Qfac * (Ufac \ (Lfac \ (Pfac * (Rfac \ x))));	
	[eigVecs, eigVals, flag] = eigs(Afun, length(M_), M_, numEVs, ...
		'smallestabs', 'IsFunctionSymmetric', 1, 'IsSymmetricDefinite', 1, 'Tolerance', tol_);	
end
