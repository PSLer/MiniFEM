function ShowCyclicalVibration(amp, scalingFac, varargin)
	%%ShowCyclicalVibration(arg1, arg2); arg1 = Steady-state amplitude; arg2 = scalingFac
	%%ShowCyclicalVibration(arg1, arg2, arg3); arg1 = arg above; arg2 = scalingFac; arg3 = 'pureColor'
	global eleType_;
	global M_;
	global nodeCoords_;
	global numNodes_;
	global numEles_;
	global eNodMat_;
	global boundingBox_;
	global boundaryNodes_;
	global outPath_;
	
	if isempty(M_), warning('The cyclical vibration does not exist!'); return; end
	if isempty(scalingFac)
		minFeaterSize = min(boundingBox_(2,:)-boundingBox_(1,:)); selfFac = 10;
		scalingFac = minFeaterSize/selfFac/max(abs(amp));		
	end	
		
	nFrame = 36;
	az = 0; el = 0;
	hF = figure; axis equal; axis tight; axis off;	
	fileName = strcat(outPath_, 'CyclicalVibration.gif');	
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		if strcmp(eleType_.eleName, 'Solid144')
			patchIndices = eNodMat_(:, [1 2 3  1 2 4  2 3 4  3 1 4])'; %% need to be verified
			patchIndices = reshape(patchIndices(:), 3, 4*numEles_);		
			numNodsEleFace = 3;
		else
			patchIndices = eNodMat_(:, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
			patchIndices = reshape(patchIndices(:), 4, 6*numEles_);
			numNodsEleFace = 4;
		end
		tmp = zeros(numNodes_,1); tmp(boundaryNodes_) = 1;
		tmp = tmp(patchIndices); tmp = sum(tmp,1);
		boundaryEleFaces = patchIndices(:,find(numNodsEleFace==tmp));
		amp = reshape(amp, 3, numNodes_)';
		for ii=1:nFrame
			disp([' Progress.: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
			srcField = real(amp*exp(1i*2*pi*ii/nFrame));
			deformedMeshCoords = nodeCoords_+scalingFac*srcField;
			xPatchs = deformedMeshCoords(:,1); xPatchs = xPatchs(boundaryEleFaces);
			yPatchs = deformedMeshCoords(:,2); yPatchs = yPatchs(boundaryEleFaces);
			zPatchs = deformedMeshCoords(:,3); zPatchs = zPatchs(boundaryEleFaces);
			cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(boundaryEleFaces);
			
			hGlyph = patch(xPatchs, yPatchs, zPatchs, cPatchs); 
			view(3); 
			camproj('perspective');
			if 2==nargin
				colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
			else
				set(hGlyph, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
			end
			if 1==ii
				axis vis3d;
				disp('Adjust the Posture of the Object for better Presentation!');
				pause; [az, el] = view; viewAngle = [az el];
				if 3==nargin
					lighting gouraud;
					camlight(az,el);
					material dull;
				end
			else
				view(viewAngle(1), viewAngle(2));
            end
			%axis image; drawnow;
			f = getframe(1);
			im = frame2im(f);
			[imind, cm] = rgb2ind(im, 256);
			if ii == 1
				imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
			else
				imwrite(imind, cm, fileName, 'gif', 'writeMode', 'append', 'DelayTime', 0.1);
			end
			set(hGlyph, 'visible', 'off');
		end
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		amp = reshape(amp, 2, numNodes_)';
		for ii=1:nFrame
			disp([' Progress.: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
			srcField = real(amp*exp(1i*2*pi*ii/nFrame));
			deformedMeshCoords = nodeCoords_+scalingFac*srcField;
			xPatchs = deformedMeshCoords(:,1); xPatchs = xPatchs(eNodMat_');
			yPatchs = deformedMeshCoords(:,2); yPatchs = yPatchs(eNodMat_');				
			cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(eNodMat_');
			hGlyph = patch(xPatchs, yPatchs, cPatchs);
			if 2==nargin
				colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
			else
				set(hGlyph, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
			end
			f = getframe(1);
			im = frame2im(f);
			[imind, cm] = rgb2ind(im, 256);
			if ii == 1
				imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
			else
				imwrite(imind, cm, fileName, 'gif', 'writeMode', 'append', 'DelayTime', 0.1);
			end
			set(hGlyph, 'visible', 'off');			
		end
	else
		amp = reshape(amp, 6, numNodes_)'; amp = amp(:,1:3);
		for ii=1:nFrame
			srcField = real(amp*exp(1i*2*pi*ii/nFrame));
			deformedMeshCoords = nodeCoords_+scalingFac*srcField;
			xPatchs = deformedMeshCoords(:,1); xPatchs = xPatchs(eNodMat_');
			yPatchs = deformedMeshCoords(:,2); yPatchs = yPatchs(eNodMat_');
			zPatchs = deformedMeshCoords(:,3); zPatchs = zPatchs(eNodMat_');			
			cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(eNodMat_');
			hGlyph = patch(xPatchs, yPatchs, zPatchs, cPatchs); 
			view(3); 
			camproj('perspective');			
			if 2==nargin
				colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
			else
				set(hGlyph, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
			end
			if 1==ii
				axis vis3d;
				disp('Adjust the Posture of the Object for better Presentation!');
				pause; [az, el] = view; viewAngle = [az el];
				if 3==nargin
					lighting gouraud;
					camlight(az,el);
					material dull;
				end
			else
				view(viewAngle(1), viewAngle(2));
            end
			%axis image; drawnow;
			f = getframe(1);
			im = frame2im(f);
			[imind, cm] = rgb2ind(im, 256);
			if ii == 1
				imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
			else
				imwrite(imind, cm, fileName, 'gif', 'writeMode', 'append', 'DelayTime', 0.1);
			end
			set(hGlyph, 'visible', 'off');		
		end		
	end
	close(hF);
end