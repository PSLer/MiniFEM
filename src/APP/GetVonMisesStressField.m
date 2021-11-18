function GetVonMisesStressField()
	global cartesianStressField_;
	global vonMisesStressField_;
	if isempty(cartesianStressField_), warning('No Available Cartesian Stresses!'); return; end
	vonMisesStressField_ = ComputeVonMisesStress(cartesianStressField_);
    ShowStressComp('Sigma_vM');
end