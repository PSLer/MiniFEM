function Vis_ShowSelectionSphere2D(sphereCtr, sphereRad)
	global axHandle_;
	global hdSelectionBox_;

	theta = linspace(0, 2*pi, 100);  % angle from 0 to 2π
	x = sphereRad * cos(theta)+sphereCtr(1);          % x coordinates
	y = sphereRad * sin(theta)+sphereCtr(2);          % y coordinates
	
	if ~isempty(hdSelectionBox_)
		if isvalid(hdSelectionBox_)
			set(hdSelectionBox_, 'visible', 'off');
		end
	end
	hold(axHandle_, 'on');
	hdSelectionBox_ = fill(axHandle_, x, y, 'b');;
	set(hdSelectionBox_, 'faceColor', [252 141 98]/255, 'faceAlpha', 0.3, 'EdgeColor', 'None');
end
