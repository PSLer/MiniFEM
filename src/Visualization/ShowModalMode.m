function ShowModalMode(modalOrder, varargin)
	global eleType_;
	global modeSpace_;
	global numNodes_;
	global U_;
	
	if isempty(modeSpace_), error('No Modal Mode Available!'); end
	if modalOrder>size(modeSpace_,2), error('Exceeds the Range of the Existing Modal Space!'); end
	U_ = modeSpace_(:,modalOrder);
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		srcField = vecnorm(reshape(U_, 3, numNodes_)',2,2);		
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		srcField = vecnorm(reshape(U_, 2, numNodes_)',2,2);
	else
		tmp = reshape(U_, 6, numNodes_)'
		srcField = vecnorm(tmp(:,1:3),2,2);			
	end
	if 1==nargin
		VisualizeScalarFieldViaColorMap(srcField);
	else
		VisualizeScalarFieldViaColorMap(srcField, varargin{1});
	end
end