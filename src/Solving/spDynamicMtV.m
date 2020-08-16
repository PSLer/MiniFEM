function v = spDynamicMtV(v1)
	global advancedSolvingOpt_;
	switch advancedSolvingOpt_
		case 'TimePriority'
			global T_; 
			v = T_ * v1;
		case 'SpacePriority'
			global edofMat_; global Te_;
			global freeDofs_; global numDOFs_;
			
			v2 = zeros(numDOFs_,1); v2(freeDofs_) = v1;
			vEleWise = v2(edofMat_)*Te_;
			v = zeros(numDOFs_,1);
			for ii=1:1:size(edofMat_,2)
				v(edofMat_(:,ii)) = v(edofMat_(:,ii)) + vEleWise(:,ii);
			end	
			v = v(freeDofs_);
	end
end