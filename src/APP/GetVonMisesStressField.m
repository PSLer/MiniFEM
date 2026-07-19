function GetVonMisesStressField()
	global eleType_;
    global cartesianStressField_ vonMisesStressField_;
	if isempty(cartesianStressField_), warning('No Available Cartesian Stresses!'); return; end
	vonMisesStressField_ = ComputeVonMisesStress(cartesianStressField_);
    ShowStressComp('Sigma_vM',0);
end