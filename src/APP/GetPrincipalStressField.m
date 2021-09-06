function GetPrincipalStressField()
	global cartesianStressField_;
	global principalStressField_;
	if isempty(cartesianStressField_), warning('No Available Cartesian Stresses!'); return; end
	tStart = tic;
	principalStressField_ = ComputePrincipalStress(cartesianStressField_);
	disp(['Compute Principal Stress Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
end