function hd = Vis_ShowShellNormals(axHandle)
	global simMesh_;
	
	nodeCoords = simMesh_.nodeCoords;
	eNodMat = simMesh_.eNodMat;
	xPatchs = nodeCoords(:,1); xPatchs = xPatchs(eNodMat');
	yPatchs = nodeCoords(:,2); yPatchs = yPatchs(eNodMat');
	zPatchs = nodeCoords(:,3); zPatchs = zPatchs(eNodMat');	
	switch simMesh_.meshType
		case 'TRI'
			ABs = [xPatchs(1,:)-xPatchs(2,:); yPatchs(1,:)-yPatchs(2,:); zPatchs(1,:)-zPatchs(2,:)];
			BCs = [xPatchs(2,:)-xPatchs(3,:); yPatchs(2,:)-yPatchs(3,:); zPatchs(2,:)-zPatchs(3,:)];
			iABxBC = cross(ABs',BCs');
			aveNormal = iABxBC ./ vecnorm(iABxBC,2,2);
			ctrCoords = [sum(xPatchs,1); sum(yPatchs,1); sum(zPatchs,1)]' / 3;
		case 'QUAD'
			ACs = [xPatchs(1,:)-xPatchs(3,:); yPatchs(1,:)-yPatchs(3,:); zPatchs(1,:)-zPatchs(3,:)];
			BDs = [xPatchs(2,:)-xPatchs(4,:); yPatchs(2,:)-yPatchs(4,:); zPatchs(2,:)-zPatchs(4,:)];
			iACxBD = cross(ACs',BDs');
			aveNormal = iACxBD ./ vecnorm(iACxBD,2,2);
			ctrCoords = [sum(xPatchs,1); sum(yPatchs,1); sum(zPatchs,1)]' / 4;
	end
	hold(axHandle, 'on');
	hd = quiver3(axHandle, ctrCoords(:,1), ctrCoords(:,2), ctrCoords(:,3), aveNormal(:,1), aveNormal(:,2), aveNormal(:,3));
	set(hd, 'LineWidth', 0.5, 'Color', 'r', 'MaxHeadSize', 0.5);
end