function PrincipalStress(varargin)
	%%Invoking Form
	%%PrincipalStress();
	%%PrincipalStress(arg); arg = 'psMajor', 'psMinor',  'psMedium' (only for 3D)
	%%PrincipalStress(arg1, arg2); arg1 = arg above, arg2 = scalar
	global structureState_;
	global U_;
	global cartesianStressField_;
	global principalStressField_;
	global numNodes_; global eleType_;
	if 0==numel(principalStressField_)
		if 0==numel(cartesianStressField_)
			if 0==numel(U_)
				switch structureState_
					case 'STATIC'
						U_ = SolvingStaticFEM('printP_OFF');
					case 'DYNAMIC'
						U_ = SolvingDynamicFEM('printP_OFF');
				end	
			end
			cartesianStressField_ = ComputeCartesianStress(U_);		
		end
		principalStressField_ = ComputePrincipalStress(cartesianStressField_);
	end
	
	if 0==nargin, ;
	elseif nargin<=2
		global domainType_;
		inVar = ScalarFieldForVolumeRendering();
		inVar.shiftingTerm = U_;
		%inVar.dispOpt = 'meshWise';
		if ischar(varargin{1})
			switch varargin{1}
				case 'psMajor'					
					if strcmp(domainType_, '2D')
						inVar.scalarFiled = principalStressField_(:,4);
					else	
						inVar.scalarFiled = principalStressField_(:,9);
					end	
				case 'psMinor'
					inVar.scalarFiled = principalStressField_(:,1);					
				case 'psMedium'
					if strcmp(domainType_, '2D')
						error('Wrong input type for visualize the Principal stress field! Error code DDD')
					end
					inVar.scalarFiled = principalStressField_(:,5);								
				otherwise
					error('Wrong input type for visualize the Principal stress field! Error code CCC');
			end				
		else
			error('Wrong input type for visualize the Principal stress field! Error code AAA');
		end		
		if 2==nargin
			if isscalar(varargin{2})
				inVar.scalingFac = varargin{2};
			else
				error('Wrong input type for visualize the Principal stress field! Error code BBB');
			end
		end
		handleVolume = DirectlyVolumeRenderingScalarField(inVar);
	else
		error('Wrong input type for visualize the Principal stress field! Error code EEE');
	end	
end