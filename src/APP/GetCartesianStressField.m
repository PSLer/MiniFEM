function GetCartesianStressField()
	%% sigma_x, sigma_y, sigma_z, tadisyz, tadiszx, tadisxy (solid)
	%%NOTE: Outer Interpolate the stress at Gauss Points to Nodes by Element Stress Interpolation Matrix --- Ns
	%% stress_GaussPoints = Ns * stress_Nodes -> stress_Nodes = inv(Ns) * stress_GaussPoints
	global U_;
	if isempty(U_), warning('No Deformation Available for Stress Analysis'); return; end
	tStart = tic;
	ComputeCartesianStress();
	disp(['Compute Cartesian Stresses Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	ShowStressComp('Sigma_xx');
end