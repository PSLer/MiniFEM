function ExportGridFormatedScalarField(x)
	global nelx_; global nely_; global nelz_; 
	global originalValidNodeIndex_;
	V = zeros((nelx_+1)*(nely_+1)*(nelz_+1),1);
	V(originalValidNodeIndex_) = x;
	V = reshape(V, nely_+1, nelx_+1, nelz_+1);
	save('../../IO/TestVolume1.mat', 'V');
end