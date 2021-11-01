function UnPickPoint()
	global eleType_;
	global nodeCoords_;
	global boundaryNodes_;
	global pickedNodeCache_;
	global hdPickedNode_;
    dcm_obj = datacursormode;
    info_struct = getCursorInfo(dcm_obj);
    tarNode = info_struct.Position;
	if size(pickedNodeCache_,1)>0		
		if strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
			potentialNodeList = nodeCoords_(pickedNodeCache_,:);
		else
			potentialNodeList = nodeCoords_(boundaryNodes_(pickedNodeCache_,1),:);
		end
		[~, minValPos] = min(vecnorm(tarNode-potentialNodeList,2,2));	
		set(hdPickedNode_, 'visible', 'off');
		pickedNodeCache_(minValPos,:) = [];
		potentialNodeList(minValPos,:) = [];
		
		if size(pickedNodeCache_,1)>0
			if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
				hdPickedNode_(end+1) = plot(potentialNodeList(:,1), potentialNodeList(:,2), ...
					'xr', 'LineWidth', 2, 'MarkerSize', 8);
			else
				hdPickedNode_(end+1) = plot3(potentialNodeList(:,1), potentialNodeList(:,2), ...
					potentialNodeList(:,3), 'xr', 'LineWidth', 2, 'MarkerSize', 8);
			end			
		end	
	end
end