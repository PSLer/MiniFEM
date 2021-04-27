function GetPrincipalStressField()
	global eleType_;
	global cartesianStressField_;
	global principalStressField_;
	if isempty(cartesianStressField_), warning('No Available Cartesian Stresses!'); return; end
	principalStressField_ = ComputePrincipalStress(cartesianStressField_);
end