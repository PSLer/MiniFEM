function hd = Vis_ShowFixingCondition2D(axHandle, iFixingArr)
	global surfMesh_;
	if isempty(iFixingArr), hd = []; return; end
	tarNodeCoord = surfMesh_.nodeCoords(iFixingArr(:,1),:);
	hold(axHandle, 'on'); 
	hd = plot(axHandle, tarNodeCoord(:,1), tarNodeCoord(:,2), 'xk', 'LineWidth', 2, 'MarkerSize', 10);	
end