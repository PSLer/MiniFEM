function GetVonMisesStressField()
	global eleType_;
	global cartesianStressField_;
	global vonMisesStressField_;
	if isempty(cartesianStressField_), warning('No Available Cartesian Stresses!'); return; end
	vonMisesStressField_ = ComputeVonMisesStress(cartesianStressField_);
end