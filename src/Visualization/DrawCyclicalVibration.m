function DrawCyclicalVibration(varargin)
	%%DrawCyclicalVibration(arg); arg = Steady-state amplitude
	%%DrawCyclicalVibration(arg1, arg2); arg1 = arg above; arg2 = scalingFac
	%%DrawCyclicalVibration(arg1, arg2, arg3); arg1 = arg above; arg2 = scalingFac; arg3 = 'meshWise'
	global structureState_;
	global domainType_;
	global numDOFs_;
	global numNodes_;
	global outPath_;
	
	if ~strcmp(structureState_, 'DYNAMIC'), error('The cyclical vibration does not exist!'); end
	if nargin<1 || nargin>3, error('Wrong input for drawing cyclical vibration!'); end
	if ~(isnumeric(varargin{1}) & isequal([numDOFs_ 1], size(varargin{1})))
		error('Wrong input for drawing cyclical vibration!'); end
	nFrame = 36;
	az = 0; el = 0;
	hF = figure();
	inVar = ScalarFieldForVolumeRendering();
	fileName = strcat(outPath_, '/vibro.gif');
	for ii=1:1:nFrame		
		%inVar.shiftingTerm = varargin{1}*sin(2*pi*ii);
		inVar.shiftingTerm = real(varargin{1}*exp(1i*2*pi*ii/nFrame));
		switch domainType_
			case '2D'
				tmp = reshape(inVar.shiftingTerm, 2, numNodes_)';
			case '3D'
				tmp = reshape(inVar.shiftingTerm, 3, numNodes_)';
		end		
		inVar.scalarFiled = vecnorm(tmp,2,2);
		switch nargin
			case 1
				inVar.scalingFac = 0;
				hGlyph = DirectlyVolumeRenderingScalarField(inVar); 
				if strcmp(domainType_, '3D')
					axis vis3d;
					if 1==ii
						disp('Adjust the posture of the image as you want!');
						pause; [az el] = view; inVar.viewAngle = [az el];
                    end
				end	
			case 2
				if isscalar(varargin{2}) 
					inVar.scalingFac = varargin{2};
					hGlyph = DirectlyVolumeRenderingScalarField(inVar); colorbar off
					if strcmp(domainType_, '3D')
						axis vis3d;
						if 1==ii
							disp('Adjust the posture of the image as you want!');
							pause; [az el] = view; inVar.viewAngle = [az el];
						end
					end										
				else
					error('Wrong input for drawing cyclical vibration!');
				end
			case 3
				if isscalar(varargin{2}) & strcmp(varargin{3}, 'meshWise')
					inVar.scalingFac = varargin{2};
					inVar.dispOpt = 'meshWise';
					hGlyph = DirectlyVolumeRenderingScalarField(inVar); colorbar off
					if strcmp(domainType_, '3D')
						axis vis3d;
						if 1==ii
							disp('Adjust the posture of the image as you want!');
							pause; [az el] = view; inVar.viewAngle = [az el];
						end
					end										
				else
					error('Wrong input for drawing cyclical vibration!');
				end			
		end		
		%axis vis3d; 
		axis image; drawnow;

		f = getframe(1);
		im = frame2im(f);
		[imind, cm] = rgb2ind(im, 256);
		if ii == 1
			imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf, ...
			'DelayTime', 0.1);
		else
			imwrite(imind, cm, fileName, 'gif', 'writeMode', 'append', ...
			'DelayTime', 0.1);
		end
		if 2==nargin || 3==nargin, RemoveGlyphs(hGlyph); end;
	end
	close(hF);
end

