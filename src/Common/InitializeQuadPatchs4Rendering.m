function InitializeQuadPatchs4Rendering()
	global domainType_;
	global patchIndices_;
	global eNodMat_;
	global numEles_;	
	switch domainType_
		case '2D'
			patchIndices_ = eNodMat_';
		case '3D'
			patchIndices_ = zeros(4,6*numEles_);
			%mapEle2patch = [1 2 3 4; 5 6 7 8; 1 2 6 5; 4 3 7 8; 1 4 8 5; 2 3 7 6]';
			mapEle2patch = [4 3 2 1; 5 6 7 8; 1 2 6 5; 8 7 3 4; 5 8 4 1; 2 3 7 6]';
			for ii=1:1:numEles_
				index = (ii-1)*6;
				iEleVtx = eNodMat_(ii,:)';
				patchIndices_(:,index+1:index+6) = iEleVtx(mapEle2patch);
			end
			% tmp = patchIndices_;
			% patchIndices_ = sort(patchIndices_,2);
			% [patchIndices_ ia ic] = unique(patchIndices_, 'rows');
			% quadFaceList = tmp(ia,:)';
	end	
end
