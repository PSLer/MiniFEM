function iFixingArr = FEA_Apply4FixationsShell(fixingOpt)
	global fixingCond_;
	global pickedNodeCache_;
	if isempty(pickedNodeCache_), iFixingArr = []; warning('There is no node available!'); return; end
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);
	
	iFixingVec = pickedNodeCache_;
	fixingState = zeros(numTarNodes, 6);
	fixingState(:,1) = fixingOpt(1);
	fixingState(:,2) = fixingOpt(2);
	fixingState(:,3) = fixingOpt(3);
	fixingState(:,4) = fixingOpt(4);
	fixingState(:,5) = fixingOpt(5);
	fixingState(:,6) = fixingOpt(6);	
	iFixingArr = [iFixingVec fixingState];
	fixingCond_(end+1:end+numTarNodes,1:7) = iFixingArr;		
end