function CartesianStress(varargin)
	%%Invoking Form
	%%CartesianStress();
	%%CartesianStress(arg); arg = 'X', 'Y', 'XY' or 'YX', 'Z', 'XZ', 'YZ' (only for 3D)
	%%CartesianStress(arg1, arg2); arg1 = arg above, arg2 = scalar
	global structureState_;
	global U_;
	global cartesianStressField_;
	global numNodes_; global eleType_;
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
	
	if 0==nargin, ;
	elseif nargin<=2
		global domainType_;
		inVar = ScalarFieldForVolumeRendering();
		inVar.shiftingTerm = U_;
		if ischar(varargin{1})
			switch varargin{1}
				case 'X'
					inVar.scalarFiled = cartesianStressField_(:,1);
				case 'Y'
					inVar.scalarFiled = cartesianStressField_(:,2);
				case 'Z'
					if strcmp(domainType_, '2D')
						error('Wrong input type for visualize the Cartesian stress field! Error code DDD')
					end
					inVar.scalarFiled = cartesianStressField_(:,3);				
				case 'YZ'
					if strcmp(domainType_, '2D')
						error('Wrong input type for visualize the Cartesian stress field! Error code DDD')
					end		
					inVar.scalarFiled = cartesianStressField_(:,4);
				case 'ZY'
					if strcmp(domainType_, '2D')
						error('Wrong input type for visualize the Cartesian stress field! Error code DDD')
					end		
					inVar.scalarFiled = cartesianStressField_(:,4);					
				case 'ZX'
					if strcmp(domainType_, '2D')
						error('Wrong input type for visualize the Cartesian stress field! Error code DDD')
					end				
					inVar.scalarFiled = cartesianStressField_(:,5);
				case 'XZ'
					if strcmp(domainType_, '2D')
						error('Wrong input type for visualize the Cartesian stress field! Error code DDD')
					end				
					inVar.scalarFiled = cartesianStressField_(:,5);					
				case 'XY'
					if strcmp(domainType_, '2D')
						inVar.scalarFiled = cartesianStressField_(:,3);
					else	
						inVar.scalarFiled = cartesianStressField_(:,6);
					end
				case 'YX'
					if strcmp(domainType_, '2D')
						inVar.scalarFiled = cartesianStressField_(:,3);
					else	
						inVar.scalarFiled = cartesianStressField_(:,6);
					end					
				otherwise
					error('Wrong input type for visualize the Cartesian stress field! Error code CCC');
			end				
		else
			error('Wrong input type for visualize the Cartesian stress field! Error code AAA');
		end		
		if 2==nargin
			if isscalar(varargin{2})
				inVar.scalingFac = varargin{2};
			else
				error('Wrong input type for visualize the Cartesian stress field! Error code BBB');
			end
		end
		handleVolume = DirectlyVolumeRenderingScalarField(inVar);
	else
		error('Wrong input type for visualize the Cartesian stress field! Error code EEE');
	end	
end