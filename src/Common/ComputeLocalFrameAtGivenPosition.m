function [R, origin, t1, t2] = ComputeLocalFrameAtGivenPosition(paras, iEleNodes)
	global refVec_;
	global refVecFallback_;
	global tolRefVecFallback_;
	N = ShapeFunction(paras);
	% [dNdxi, dNdeta] = DeShapeFunction(paras, elementType);
	dN = DeShapeFunction(paras);
	dNdxi = dN(1:2:end,:);
	dNdeta = dN(2:2:end,:);
	%%Tangent Planes at "paras"
	t1 = dNdxi * iEleNodes;
	t2 = dNdeta * iEleNodes;
	origin = N*iEleNodes;
	nVec = cross(t1, t2);
	e3 = nVec ./ vecnorm(nVec,2,2);
	rVec = refVec_;
	tVec = rVec - (dot(rVec, e3))*e3;
	if norm(tVec) < tolRefVecFallback_
		rVec = refVecFallback_;
		tVec = rVec - (dot(rVec, e3))*e3;
		if norm(tVec) < tolRefVecFallback_
			error('Reference directions are parallel to normal; provide a custom ref.');
		end				
	end
	e1 = tVec / norm(tVec);
	e2 = cross(e3, e1);
	R = [e1(:), e2(:), e3(:)];
end