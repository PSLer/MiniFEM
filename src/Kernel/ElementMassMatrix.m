function Me = ElementMassMatrix(N, w, detJ, dens)
	global eleType_;
	wgt = dens*w.*detJ;	wgt = repmat(wgt, 1, eleType_.nEleNodeDOFs);
	wgt = reshape(wgt', 1, numel(wgt));
	Me = N'.*wgt*N;
	%%%%ref
	% global domainType_;
	% switch domainType_
		% case '2D'
			% Me = ElementMassMatrix2D(N, w, detJ, dens);
		% case '3D'
			% Me = ElementMassMatrix3D(N, w, detJ, dens);
	% end
end