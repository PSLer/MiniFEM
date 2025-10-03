function GetVonMisesStressField()
	global eleType_;
    global cartesianStressField_ cartesianStressFieldGlobal_ vonMisesStressField_;
	if isempty(cartesianStressField_), warning('No Available Cartesian Stresses!'); return; end
    if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
        vonMisesStressField_ = ComputeVonMisesStress(cartesianStressFieldGlobal_);
    else
	    vonMisesStressField_ = ComputeVonMisesStress(cartesianStressField_);
    end
    ShowStressComp('Sigma_vM');
end