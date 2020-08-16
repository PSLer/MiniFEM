function MisesStress(varargin)
	%%MisesStress(scalar)
	global structureState_;
	global U_;
	global cartesianStressField_;
	global vonMisesStressField_;
	global numNodes_; global eleType_;
	if 0==numel(vonMisesStressField_)
		if 0==numel(cartesianStressField_)
			if 0==numel(U_)
				switch structureState_
					case 'STATIC'
						U_ = SolvingStaticFEM('printP_ON');
					case 'DYNAMIC'
						U_ = SolvingDynamicFEM('printP_ON');
				end	
			end
			cartesianStressField_ = ComputeCartesianStress(U_);		
		end
		vonMisesStressField_ = ComputeVonMisesStress(cartesianStressField_);
	end

	if nargin<=1
		global domainType_;
		inVar = ScalarFieldForVolumeRendering();
		inVar.shiftingTerm = U_;
		inVar.scalarFiled = vonMisesStressField_;
		if 1==nargin & isscalar(varargin{1})
			if isscalar(varargin{1})
				inVar.scalingFac = varargin{1};
			else
				error('Wrong input type for visualize the Mises stress field! Error code BBB');
			end			
		end
		handleVolume = DirectlyVolumeRenderingScalarField(inVar);
	else
		error('Wrong input type for visualize the Mises stress field! Error code EEE');
	end		
end