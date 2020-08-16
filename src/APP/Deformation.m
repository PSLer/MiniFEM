function Deformation(varargin)
	%%Invoking Form
	%%Deformation();
	%%Deformation(arg); arg = 'X', 'Y', 'Z', 'T'
	%%Deformation(arg1, arg2); arg1 = arg above, arg2 = scalar or 'meshWise'
	%%Deformation(arg1, arg2, arg3); arg1 = arg above, arg2 = scalar; arg3 = 'meshWise'
	global structureState_;
	global U_;	
	if 0==numel(U_)	
		switch structureState_
			case 'STATIC'
                tic
                U_ = SolvingStaticFEM('printP_ON');
				disp(['Solving static linear system costs: ' sprintf('%10.3g',toc) 's']);
			case 'DYNAMIC'
				tic
                U_ = SolvingDynamicFEM('printP_ON');
				disp(['Solving dynamic linear system costs: ' sprintf('%10.3g',toc) 's']);
		end
	end
	if 0==nargin, ;
	elseif nargin<=3
		global domainType_; global numNodes_;
		switch domainType_
			case '2D'
				tmp = reshape(U_, 2, numNodes_)';
			case '3D'
				tmp = reshape(U_, 3, numNodes_)';
		end
		inVar = ScalarFieldForVolumeRendering();
		inVar.shiftingTerm = U_;		
		if ischar(varargin{1})
			switch varargin{1}
				case 'X'
					inVar.scalarFiled = tmp(:,1);
				case 'Y'
					inVar.scalarFiled = tmp(:,2);
				case 'Z'
					if strcmp(domainType_, '2D')
						error('Wrong input type for visualize the deformation field! Error code DDD')
					end
					inVar.scalarFiled = tmp(:,3);				
				case 'T'
					inVar.scalarFiled = vecnorm(tmp,2,2);
				otherwise
					error('Wrong input type for visualize the deformation field! Error code CCC');
			end				
		else
			error('Wrong input type for visualize the deformation field! Error code AAA');
		end		
		if 2==nargin
			if isscalar(varargin{2})
				inVar.scalingFac = varargin{2};
			elseif strcmp('meshWise', varargin{2})
				inVar.dispOpt = varargin{2};
			else
				error('Wrong input type for visualize the deformation field! Error code BBB');
			end
		end
		if 3==nargin
			if isscalar(varargin{2})
				inVar.scalingFac = varargin{2};
			else
				error('Wrong input type for visualize the deformation field! Error code BBB');
			end			
			if strcmp('meshWise', varargin{3})
				inVar.dispOpt = varargin{3};
			else
				error('Wrong input type for visualize the deformation field! Error code FFF');
			end
		end
		figure; handleVolume = DirectlyVolumeRenderingScalarField(inVar);
	else
		error('Wrong input type for visualize the deformation field! Error code EEE');
	end
end