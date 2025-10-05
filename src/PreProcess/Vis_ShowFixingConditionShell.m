function hd = Vis_ShowFixingConditionShell(axHandle, iFixingArr)
	global simMesh_;
	if isempty(iFixingArr), hd = []; return; end
	tarNodeCoord = simMesh_.nodeCoords(iFixingArr(:,1),:);
	hold(axHandle, 'on'); 
	hd = plot3(axHandle, tarNodeCoord(:,1), tarNodeCoord(:,2), tarNodeCoord(:,3), 'xk', 'LineWidth', 2, 'MarkerSize', 10);	
end