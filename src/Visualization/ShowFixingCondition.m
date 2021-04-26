function ShowFixingCondition(varargin)
	global eleType_;
	global nodeCoords_;
	global fixingCond_; 
	if 0==nargin
		fixingCondToBeShow = fixingCond_;
	else
		fixingCondToBeShow = varargin{1};
	end
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		if size(fixingCondToBeShow,1)>0
			tarNodeCoord = nodeCoords_(fixingCondToBeShow,:);
			hold on; hd1 = plot3(tarNodeCoord(:,1), tarNodeCoord(:,2), tarNodeCoord(:,3), 'xk', 'LineWidth', 2, 'MarkerSize', 6);
		end
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		if size(fixingCondToBeShow,1)>0
			tarNodeCoord = nodeCoords_(fixingCondToBeShow,:);
			hold on; hd1 = plot(tarNodeCoord(:,1), tarNodeCoord(:,2), 'xk', 'LineWidth', 2, 'MarkerSize', 6);
		end
	else
		if size(fixingCondToBeShow,1)>0
			tarNodeCoord = nodeCoords_(fixingCondToBeShow,:);
			hold on; hd1 = plot3(tarNodeCoord(:,1), tarNodeCoord(:,2), tarNodeCoord(:,3), 'xk', 'LineWidth', 2, 'MarkerSize', 6);
		end			
	end
end