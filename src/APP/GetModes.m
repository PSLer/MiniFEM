function GetModes(numModalModes)
	global freeDOFs_;
	global K_;
	global M_;	
	if isempty(freeDOFs_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	if isempty(M_), AssembleMassMatrix(); end
	ModeAnalysis(numModalModes);
	ShowModalMode(1);
end