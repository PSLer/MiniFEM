function ShiftScalingObject(newOrigin, newCharacterDimension)
	global eleType_;
	global boundingBox_;
	global nodeCoords_;
	global diameterList_;
	global eleCrossSecAreaList_;
	
	if ~isempty(newOrigin)
		newOrigin = newOrigin(:)';
		if 2==numel(newOrigin) || 3==numel(newOrigin)
			nodeCoords_ = nodeCoords_ + (newOrigin - boundingBox_(1,:));
			boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
		else
			warning('Wrong input!'); return;
		end	
	end

	
	if ~isempty(newCharacterDimension)
		nodeCoords_ = boundingBox_(1,:) + (nodeCoords_ - boundingBox_(1,:)) * (newCharacterDimension/max(boundingBox_(2,:)-boundingBox_(1,:)));
		if strcmp(eleType_.eleName, 'Truss122') || strcmp(eleType_.eleName, 'Truss123') || strcmp(eleType_.eleName, 'Beam122') || ...
				strcmp(eleType_.eleName, 'Beam123')
			diameterList_ = diameterList_ * newCharacterDimension;	
		end
		if strcmp(eleType_.eleName, 'Truss123') || strcmp(eleType_.eleName, 'Beam123')
			eleCrossSecAreaList_ = pi/2 * (diameterList_/2).^2;
		end
		boundingBox_ = [min(nodeCoords_, [], 1); max(nodeCoords_, [], 1)];
	end
	ShowBoundaryCondition();
end