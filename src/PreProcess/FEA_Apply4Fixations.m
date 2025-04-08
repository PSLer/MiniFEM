function iFixingArr = FEA_Apply4Fixations(fixingOpt)
	global fixingCond_;
	global pickedNodeCache_;
	if isempty(pickedNodeCache_), iFixingArr = []; warning('There is no node available!'); return; end
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);
	
	iFixingVec = pickedNodeCache_;
	fixingState = zeros(numTarNodes, 3);
	fixingState(:,1) = fixingOpt(1);
	fixingState(:,2) = fixingOpt(2);
	fixingState(:,3) = fixingOpt(3);
	
	iFixingArr = [iFixingVec fixingState];
	fixingCond_(end+1:end+numTarNodes,1:4) = iFixingArr;		
end