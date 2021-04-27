function ShowStressComp(compName, varargin)
	global eleType_;
	global cartesianStressField_;
	global vonMisesStressField_;
	global principalStressField_;	
	global numNodes_;
	if isempty(cartesianStressField_), warning('No Stress Field Available!'); return; end
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		switch compName
			case 'Sigma_xx'
				srcField = cartesianStressField_(:,1);
			case 'Sigma_yy'
				srcField = cartesianStressField_(:,2);
			case 'Sigma_zz'
				srcField = cartesianStressField_(:,3);	
			case 'Sigma_yz'
				srcField = cartesianStressField_(:,4);
			case 'Sigma_zx'
				srcField = cartesianStressField_(:,5);				
			case 'Sigma_xy'
				srcField = cartesianStressField_(:,6);
			case 'Sigma_vM'
				if isempty(vonMisesStressField_), warning('von Mises Stress Field is not Available!'); return; end
				srcField = vonMisesStressField_;
			case 'Sigma_ps1' %%major PS
				if isempty(principalStressField_), warning('Principal Stress Field is not Available!'); return; end
				srcField = principalStressField_(:,9);
			case 'Sigma_ps2' %%medium PS
				if isempty(principalStressField_), warning('Principal Stress Field is not Available!'); return; end
				srcField = principalStressField_(:,5);				
			case 'Sigma_ps3' %%minor PS
				if isempty(principalStressField_), warning('Principal Stress Field is not Available!'); return; end
				srcField = principalStressField_(:,1);
			otherwise
				warning('Undefined Stress Type!'); return;
		end			
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		switch compName
			case 'Sigma_xx'
				srcField = cartesianStressField_(:,1);
			case 'Sigma_yy'
				srcField = cartesianStressField_(:,2);
			case 'Sigma_xy'
				srcField = cartesianStressField_(:,3);
			case 'Sigma_vM'
				if isempty(vonMisesStressField_), warning('von Mises Stress Field is not Available!'); return; end
				srcField = vonMisesStressField_;
			case 'Sigma_ps1' %%major PS
				if isempty(principalStressField_), warning('Principal Stress Field is not Available!'); return; end
				srcField = principalStressField_(:,4);
			case 'Sigma_ps2' %%minor PS
				if isempty(principalStressField_), warning('Principal Stress Field is not Available!'); return; end
				srcField = principalStressField_(:,1);
			otherwise
				warning('Undefined Stress Type!'); return;				
		end
	else
		%% to be confirmed
		switch compName
			case 'Sigma_xx'
				srcField = cartesianStressField_(:,1);
			case 'Sigma_yy'
				srcField = cartesianStressField_(:,2);
			case 'Sigma_zz'
				srcField = cartesianStressField_(:,3);	
			case 'Sigma_yz'
				srcField = cartesianStressField_(:,4);
			case 'Sigma_zx'
				srcField = cartesianStressField_(:,5);				
			case 'Sigma_xy'
				srcField = cartesianStressField_(:,6);
			case 'Sigma_vM'
				if isempty(vonMisesStressField_), warning('von Mises Stress Field is not Available!'); return; end
				srcField = vonMisesStressField_;
			case 'Sigma_ps1' %%major PS
				if isempty(principalStressField_), warning('Principal Stress Field is not Available!'); return; end
				srcField = principalStressField_(:,9);
			case 'Sigma_ps2' %%medium PS
				if isempty(principalStressField_), warning('Principal Stress Field is not Available!'); return; end
				srcField = principalStressField_(:,5);				
			case 'Sigma_ps3' %%minor PS
				if isempty(principalStressField_), warning('Principal Stress Field is not Available!'); return; end
				srcField = principalStressField_(:,1);
			otherwise
				warning('Undefined Stress Type!'); return;				
		end			
	end
	if 1==nargin
		VisualizeScalarFieldViaColorMap(srcField);
	else
		VisualizeScalarFieldViaColorMap(srcField, varargin{1});
	end
end