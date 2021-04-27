function Ke = ElementStiffMatrix(B, D, w, detJ)
	global eleType_;
	wgt = w.*detJ;	wgt = repmat(wgt, 1, eleType_.nEleStressComponents);
	wgt = reshape(wgt', 1, numel(wgt));
	Ke = B'*(D.*wgt)*B;
	%%ref
	%Ke = B'*D*sparse(diag(wgt))*B;	
end
