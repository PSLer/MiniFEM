function ShowFixingCondition(varargin)
	global eleType_;
	global nodeCoords_;
	global fixingCond_; 
	if 0==nargin
		fixingCondToBeShow = fixingCond_;
	else
		fixingCondToBeShow = varargin{1};
	end
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188') || ...
			strcmp(eleType_.eleName, 'Truss123') ||  strcmp(eleType_.eleName, 'Beam123')
		if size(fixingCondToBeShow,1)>0
			tarNodeCoord = nodeCoords_(fixingCondToBeShow(:,1),:);
			hold('on'); hd1 = plot3(tarNodeCoord(:,1), tarNodeCoord(:,2), tarNodeCoord(:,3), 'x', ...
				'color', [153 153 153]/255, 'LineWidth', 3, 'MarkerSize', 15);
		end
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144') || ...
			strcmp(eleType_.eleName, 'Truss122') ||  strcmp(eleType_.eleName, 'Beam122')
		if size(fixingCondToBeShow,1)>0
			tarNodeCoord = nodeCoords_(fixingCondToBeShow(:,1),:);
			hold('on'); hd1 = plot(tarNodeCoord(:,1), tarNodeCoord(:,2), 'x', ...
				'color', [153 153 153]/255, 'LineWidth', 3, 'MarkerSize', 15);
		end
	else
		if size(fixingCondToBeShow,1)>0
			tarNodeCoord = nodeCoords_(fixingCondToBeShow(:,1),:);
			hold('on'); hd1 = plot3(tarNodeCoord(:,1), tarNodeCoord(:,2), tarNodeCoord(:,3), 'x', ...
				'color', [153 153 153]/255, 'LineWidth', 3, 'MarkerSize', 15);
		end			
	end
end