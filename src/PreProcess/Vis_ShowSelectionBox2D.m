function Vis_ShowSelectionBox2D(cP1, cP2)
	global axHandle_;
	global hdSelectionBox_;
	x1 = cP1(1); y1 = cP1(2);
	x2 = cP2(1); y2 = cP2(2);
	
	selBox.vertices = [
		x1	y2
		x1	y1
		x2	y1
		x2	y2
	];
	selBox.faces = 1:4;
	if ~isempty(hdSelectionBox_)
		if isvalid(hdSelectionBox_)
			set(hdSelectionBox_, 'visible', 'off');
		end
	end
	hold(axHandle_, 'on');
	hdSelectionBox_ = patch(axHandle_, selBox);
	set(hdSelectionBox_, 'faceColor', 'None', 'EdgeColor', 'magenta', 'lineWidth', 2);
	hold(axHandle_, 'on');
	hdSelectionBox_(end+1,1) = plot(x1,y1, '*y', 'MarkerSize', 10);
	hold(axHandle_, 'on');
	hdSelectionBox_(end+1,1) = plot(x2,y2, '+c', 'MarkerSize', 10);	
end