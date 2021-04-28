function principalStress = ComputePrincipalStress(cartesianStress)
	global eleType_;
	numStressTensors = size(cartesianStress,1);
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		principalStress = zeros(numStressTensors, 6);
		iPS = zeros(1, 6);
		for ii=1:numStressTensors
			iStressTensor = cartesianStress(ii,:);
			A = iStressTensor([1 3; 3 2]);
			[eigenVec, eigenVal] = eig(A);
			iPS([1 4]) = diag(eigenVal);
			iPS([2 3 5 6]) = reshape(eigenVec,1,4);
			principalStress(ii,:) = iPS;
		end
	else
		%% iStressTensor = [sigma_x, sigma_y, sigma_z, tadisyz, tadiszx, tadisxy]; 
		principalStress = zeros(numStressTensors, 12);
		iPS = zeros(1, 12);
		for ii=1:numStressTensors
			iStressTensor = cartesianStress(ii,:);
			A = iStressTensor([1 6 5; 6 2 4; 5 4 3]);
			[eigenVec, eigenVal] = eig(A);
			iPS([1 5 9]) = diag(eigenVal);
			iPS([2 3 4 6 7 8 10 11 12]) = reshape(eigenVec,1,9);
			principalStress(ii,:) = iPS;
		end		
	end		
end
