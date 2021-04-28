function GetFrequencyResponse(iFreq)
	global F_;
	global K_;
	global M_;
	global U_;
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	if isempty(M_), AssembleMassMatrix(); end
	U_ = SolvingDynamicLinearSystemEquations(iFreq);
	ShowDeformation('T');
end