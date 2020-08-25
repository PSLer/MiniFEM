function principalStress = ComputePrincipalStress(cartesianStress)
	global domainType_;
	switch domainType_
		case '2D'
			principalStress = zeros(size(cartesianStress,1), 1+2+1+2);
			for ii=1:1:size(cartesianStress,1)
				A = zeros(2);
				A(1,1) = cartesianStress(ii,1);
				A(1,2) = cartesianStress(ii,3);
				A(2,1) = A(1,2);
				A(2,2) = cartesianStress(ii,2);	
				[eigenVec, eigenVal] = eig(A);
				principalStress(ii,1) = eigenVal(1,1); 
				principalStress(ii,2:3) = eigenVec(:,1);
				principalStress(ii,4) = eigenVal(2,2); 
				principalStress(ii,5:6) = eigenVec(:,2);
			end			
		case '3D'
			principalStress = zeros(size(cartesianStress,1), 1+3+1+3+1+3);
			for ii=1:1:size(cartesianStress,1)
				A = zeros(3);
				A(1,1) = cartesianStress(ii,1);
				A(1,2) = cartesianStress(ii,6);
				A(1,3) = cartesianStress(ii,5);
				A(2,1) = A(1,2);
				A(2,2) = cartesianStress(ii,2);
				A(2,3) = cartesianStress(ii,4);
				A(3,1) = A(1,3);
				A(3,2) = A(2,3);
				A(3,3) = cartesianStress(ii,3);		
				[eigenVec, eigenVal] = eig(A);
				principalStress(ii,1) = eigenVal(1,1); principalStress(ii,2:4) = eigenVec(:,1);
				principalStress(ii,5) = eigenVal(2,2); principalStress(ii,6:8) = eigenVec(:,2);
				principalStress(ii,9) = eigenVal(3,3); principalStress(ii,10:12) = eigenVec(:,3);
			end			
	end		
end
