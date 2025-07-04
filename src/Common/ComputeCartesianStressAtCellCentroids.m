function stressTensorAtElementCentroids = ComputeCartesianStressAtCellCentroids(carStress)
	%% sigma_xx, sigma_yy, sigma_zz, tadisyz, tadiszx, tadisxy (3D)
	global numEles_;
	global eNodMat_;
	global eleType_;
	if isempty(carStress), return; end
	stressTensorAtElementCentroids = zeros(numEles_, size(carStress,2));
	switch eleType_.eleName
		case 'Plane133'
			shapeFuncsAtCentroid = ones(1,3)/3;
		case 'Plane144'
			shapeFuncsAtCentroid = ones(1,4)/4;
		case 'Solid144'
			shapeFuncsAtCentroid = ones(1,4)/4;
		case 'Solid188'
			shapeFuncsAtCentroid = ones(1,8)/8;
	end
	for ii=1:numEles_
		iCartesianStress = carStress(eNodMat_(ii,:), :);
		stressTensorAtElementCentroids(ii,:) = shapeFuncsAtCentroid * iCartesianStress;
	end	
end