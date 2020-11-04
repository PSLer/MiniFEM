function carStr = ComputeCartesianStress(dis)
	%% sigma_x, sigma_y, sigma_z, tadisyz, tadiszx, tadisxy (3D)
	global numEles_; global numNodes_; global eleType_; 
	global eNodMat_; global numNod2ElesVec_;
	global dShape_; global invJ_; global eleD_;	global eleB_;
	global modelSource_;
	carStr = zeros(numNodes_, eleType_.numStressComponents);
	OTP = OuterInterpolationMat();
	numEntries = eleType_.numNode*eleType_.numNodeDOFs;
	if ~strcmp(modelSource_, 'ExtMesh')
		eleB = ElementStrainMatrix(dShape_, invJ_.SPmat);
	end
	for ii=1:1:numEles_
		relativeDOFsIndex = eleType_.numNodeDOFs*eNodMat_(ii,:)'-(eleType_.numNodeDOFs-1:-1:0);
		u = dis(reshape(relativeDOFsIndex', numEntries, 1));
		if strcmp(modelSource_, 'ExtMesh')
			cartesianStressOnGaussIntegralPoints = eleD_ * (eleB_(:,:,ii)*u);
		else
			cartesianStressOnGaussIntegralPoints = eleD_ * (eleB_*u);
		end	
		midVar = OTP*cartesianStressOnGaussIntegralPoints;
		midVar = reshape(midVar, eleType_.numStressComponents, eleType_.numNode)';
		carStr(eNodMat_(ii,:)', :) = midVar + carStr(eNodMat_(ii,:)', :);
	end
	carStr = carStr./numNod2ElesVec_;
end