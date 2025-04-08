function iFixingArr = FEA_Apply4Fixations2D(fixingOpt)
	global fixingCond_;
	global pickedNodeCache_;
	if isempty(pickedNodeCache_), iFixingArr = []; warning('There is no node available!'); return; end
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);
	
	iFixingVec = pickedNodeCache_;
	fixingState = zeros(numTarNodes, 2);
	fixingState(:,1) = fixingOpt(1);
	fixingState(:,2) = fixingOpt(2);
	
	iFixingArr = [iFixingVec fixingState];
	fixingCond_(end+1:end+numTarNodes,1:3) = iFixingArr;		
end