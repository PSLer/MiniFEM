function [detJ invJ] = JacobianMat(dShape, coord);
	if 2==size(coord,2) & 2==size(dShape,1)
		Jac = [
			dShape(1,:)*coord(:,1)	dShape(1,:)*coord(:,2)
			dShape(2,:)*coord(:,1)	dShape(2,:)*coord(:,2)
		];
	elseif 3==size(coord,2) & 3==size(dShape,1)
		Jac = [
			dShape(1,:)*coord(:,1) 	dShape(1,:)*coord(:,2) dShape(1,:)*coord(:,3)
			dShape(2,:)*coord(:,1) 	dShape(2,:)*coord(:,2) dShape(2,:)*coord(:,3)
			dShape(3,:)*coord(:,1) 	dShape(3,:)*coord(:,2) dShape(3,:)*coord(:,3)		
		];	
	else
		error('Wrong input in computing Jacobian matrix!');
	end
	detJ = det(Jac);
	invJ = inv(Jac);
end