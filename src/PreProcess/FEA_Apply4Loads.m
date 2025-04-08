function iLoadingVec = FEA_Apply4Loads(force)
	global loadingCond_;
	global pickedNodeCache_;
	
	if isempty(pickedNodeCache_), iLoadingVec = []; warning('There is no node selected!'); return; end
	force = force(:)';
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);
	iLoadingVec = [double(pickedNodeCache_) repmat(force/numTarNodes, numTarNodes, 1)];
	loadingCond_(end+1:end+numTarNodes,:) = iLoadingVec;
end
