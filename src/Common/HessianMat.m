function invHJ = HessianMat(dShape, d2Shape, coord);
	%%physical coordinates: x, y
	%%generalized coordinates: s, t
	if 2==size(dShape,1) & 3==size(d2Shape,1) & 2==size(coord,2)
		DxDs = dShape(1,:)*coord(:,1);
		DyDs = dShape(1,:)*coord(:,2);
		DxDt = dShape(2,:)*coord(:,1);
		DyDt = dShape(2,:)*coord(:,2);
	
		D2xDs2 = d2Shape(1,:)*coord(:,1);
		D2yDs2 = d2Shape(1,:)*coord(:,2);
		squareDxDs = DxDs^2;
		squareDyDs = DyDs^2;
		DxDsMultiDyDs2 = 2*DxDs*DyDs;
	
		D2xDt2 = d2Shape(2,:)*coord(:,1);
		D2yDt2 = d2Shape(2,:)*coord(:,2);
		squareDxDt = DxDt^2;
		squareDyDt = DyDt^2;
		DxDtMultiDyDt2 = 2*DxDt*DyDt;	
		
		D2xDst = d2Shape(3,:)*coord(:,1);
		D2yDst = d2Shape(3,:)*coord(:,2);
		DxDsMultiDxDt = DxDs*DxDt;
		DyDsMultiDyDt = DyDs*DyDt;
		DxDsMultiDyDtPlusDxDtMultiDyDs = DxDs*DyDt + DxDt*DyDs;
		
		HJ = [
			DxDs		DyDs		0				0				0
			DxDt		DyDt		0				0				0
			D2xDs2		D2yDs2		squareDxDs		squareDyDs		DxDsMultiDyDs2	
			D2xDt2		D2yDt2		squareDxDt		squareDyDt		DxDtMultiDyDt2
			D2xDst		D2yDst		DxDsMultiDxDt	DyDsMultiDyDt	DxDsMultiDyDtPlusDxDtMultiDyDs
		];	
	if 3==size(dShape,1) & 6==size(d2Shape,1) & 3==size(coord,2)
		DxDs = dShape(1,:)*coord(:,1);
		DyDs = dShape(1,:)*coord(:,2);
		DzDs = dShape(1,:)*coord(:,3);
		DxDt = dShape(2,:)*coord(:,1);
		DyDt = dShape(2,:)*coord(:,2);
		DzDt = dShape(2,:)*coord(:,3);
		DxDp = dShape(3,:)*coord(:,1);
		DyDp = dShape(3,:)*coord(:,2);
		DzDp = dShape(3,:)*coord(:,3);
	
		D2xDs2 = d2Shape(1,:)*coord(:,1);
		D2yDs2 = d2Shape(1,:)*coord(:,2);
		D2zDs2 = d2Shape(1,:)*coord(:,3);
		squareDxDs = DxDs^2;
		squareDyDs = DyDs^2;
		squareDzDs = DzDs^2;
		DxDsMultiDyDs2 = 2*DxDs*DyDs;
		DxDsMultiDzDs2 = 2*DxDs*DzDs;
		DyDsMultiDzDs2 = 2*DyDs*DzDs;
		
		D2xDt2 = d2Shape(2,:)*coord(:,1);
		D2yDt2 = d2Shape(2,:)*coord(:,2);
		D2zDt2 = d2Shape(2,:)*coord(:,3);
		squareDxDt = DxDt^2;
		squareDyDt = DyDt^2;
		squareDzDt = DzDt^2;
		DxDtMultiDyDt2 = 2*DxDt*DyDt;
		DxDtMultiDzDt2 = 2*DxDt*DzDt;
		DyDtMultiDzDt2 = 2*DyDt*DzDt;
	
		D2xDp2 = d2Shape(3,:)*coord(:,1);
		D2yDp2 = d2Shape(3,:)*coord(:,2);
		D2zDp2 = d2Shape(3,:)*coord(:,3);
		squareDxDp = DxDp^2;
		squareDyDp = DyDp^2;
		squareDzDp = DzDp^2;
		DxDpMultiDyDp2 = 2*DxDp*DyDp;
		DxDpMultiDzDp2 = 2*DxDp*DzDp;
		DyDpMultiDzDp2 = 2*DyDp*DzDp;
	
		D2xDtp = d2Shape(4,:)*coord(:,1);
		D2yDtp = d2Shape(4,:)*coord(:,2);
		D2zDtp = d2Shape(4,:)*coord(:,3);
		DxDtMultiDxDp = DxDt*DxDp;
		DyDtMultiDyDp = DyDt*DyDp;
		DzDtMultiDzDp = DzDt*DzDp;
		DyDtMultiDzDpPlusDyDpMultiDzDt = DyDt*DzDp + DyDp*DzDt;	
		DxDtMultiDzDpPlusDxDpMultiDzDt = DxDt*DzDp + DxDp*DzDt;
		DxDtMultiDyDpPlusDxDpMultiDyDt = DxDt*DyDp + DxDp*DyDt;	
			
		D2xDsp = d2Shape(5,:)*coord(:,1);
		D2yDsp = d2Shape(5,:)*coord(:,2);
		D2zDsp = d2Shape(5,:)*coord(:,3);
		DxDsMultiDxDp = DxDs*DxDp;
		DyDsMultiDyDp = DyDs*DyDp;
		DzDsMultiDzDp = DzDs*DzDp;
		DyDsMultiDzDpPlusDyDpMultiDzDs = DyDs*DzDp + DyDp*DzDs;
		DxDsMultiDzDpPlusDxDpMultiDzDs = DxDs*DzDp + DxDp*DzDs;	
		DxDsMultiDyDpPlusDxDpMultiDyDs = DxDs*DyDp + DxDp*DyDs;
	
		D2xDst = d2Shape(6,:)*coord(:,1);
		D2yDst = d2Shape(6,:)*coord(:,2);
		D2zDst = d2Shape(6,:)*coord(:,3);
		DxDsMultiDxDt = DxDs*DxDt;
		DyDsMultiDyDt = DyDs*DyDt;
		DzDsMultiDzDt = DzDs*DzDt;
		DyDsMultiDzDtPlusDyDtMultiDzDs = DyDs*DzDt + DyDt*DzDs;
		DxDsMultiDzDtPlusDxDtMultiDzDs = DxDs*DzDt + DxDt*DzDs;
		DxDsMultiDyDtPlusDxDtMultiDyDs = DxDs*DyDt + DxDt*DyDs;
		
		HJ = [
			DxDs   DyDs	  DzDs	 0			   0			 0			   0							  0								 0
			DxDt   DyDt	  DzDt	 0			   0			 0			   0							  0								 0
			DxDp   DyDp	  DzDp	 0			   0			 0			   0							  0								 0
			D2xDs2 D2yDs2 D2zDs2 squareDxDs	   squareDyDs	 squareDzDs	   DyDsMultiDzDs2				  DxDsMultiDzDs2				 DxDsMultiDyDs2
			D2xDt2 D2yDt2 D2zDt2 squareDxDt	   squareDyDt	 squareDzDt	   DyDtMultiDzDt2				  DxDtMultiDzDt2				 DxDtMultiDyDt2
			D2xDp2 D2yDp2 D2zDp2 squareDxDp	   squareDyDp	 squareDzDp	   DyDpMultiDzDp2				  DxDpMultiDzDp2				 DxDpMultiDyDp2
			D2xDtp D2yDtp D2zDtp DxDtMultiDxDp DyDtMultiDyDp DzDtMultiDzDp DyDtMultiDzDpPlusDyDpMultiDzDt DxDtMultiDzDpPlusDxDpMultiDzDt DxDtMultiDyDpPlusDxDpMultiDyDt
			D2xDsp D2yDsp D2zDsp DxDsMultiDxDp DyDsMultiDyDp DzDsMultiDzDp DyDsMultiDzDpPlusDyDpMultiDzDs DxDsMultiDzDpPlusDxDpMultiDzDs DxDsMultiDyDpPlusDxDpMultiDyDs			
			D2xDst D2yDst D2zDst DxDsMultiDxDt DyDsMultiDyDt DzDsMultiDzDt DyDsMultiDzDtPlusDyDtMultiDzDs DxDsMultiDzDtPlusDxDtMultiDzDs DxDsMultiDyDtPlusDxDtMultiDyDs
		];	
	else
		error('Wrong input for computing Hessian matrix!');
	end
	invHJ = inv(HJ);
end