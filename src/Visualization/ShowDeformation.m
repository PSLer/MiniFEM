function ShowDeformation(dir, varargin)
	global eleType_;
	global U_;
	global numNodes_;
	if isempty(U_), error('No Deformation Field Available!'); end
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		switch dir
			case 'X'
				srcField = U_(1:3:end,1);
			case 'Y'
				srcField = U_(2:3:end,1);
			case 'Z'
				srcField = U_(3:3:end,1);
			case 'T'
				srcField = vecnorm(reshape(U_, 3, numNodes_)',2,2);
			otherwise
				warning('Undefined Deformation Direction!'); return;				
		end			
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		switch dir
			case 'X'
				srcField = U_(1:2:end,1);
			case 'Y'
				srcField = U_(2:2:end,1);
			case 'T'
				srcField = vecnorm(reshape(U_, 2, numNodes_)',2,2);
			otherwise
				warning('Undefined Deformation Direction!'); return;				
		end
	else
		switch dir
			case 'X'
				srcField = U_(1:6:end,1);
			case 'Y'
				srcField = U_(2:6:end,1);
			case 'Z'			
				srcField = U_(3:6:end,1);
			case 'T'
				tmp = reshape(U_, 6, numNodes_)'
				srcField = vecnorm(tmp(:,1:3),2,2);
			case 'YZ'
				srcField = U_(4:6:end,1);
			case 'ZX'
				srcField = U_(5:6:end,1);
			case 'XY'
				srcField = U_(6:6:end,1);
			otherwise
				warning('Undefined Deformation Direction!'); return;				
		end		
	end
	if 1==nargin
		VisualizeScalarFieldViaColorMap(srcField);
	else
		VisualizeScalarFieldViaColorMap(srcField, varargin{1});
	end
end