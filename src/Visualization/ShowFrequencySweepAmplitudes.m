function ShowFrequencySweepAmplitudes(scalingFac, style, outPutType, varargin)
	%% an improfessional but possibly interesting function
	global eleType_;
	global M_;
	global nodeCoords_;
	global numNodes_;
	global numEles_;
	global eNodMat_;
	global boundingBox_;
	global nodState_;
	global outPath_;
	
	if isempty(M_), warning('The cyclical vibration does not exist!'); return; end
	if 4==nargin, cameraZoomScaling = varargin{1}; else, cameraZoomScaling = 1; end
	if strcmp(outPutType, 'Animation')
		fileName = strcat(outPath_, 'CyclicalVibration.gif');
	elseif strcmp(outPutType, 'Video')
		filename = strcat(outPath_, 'CyclicalVibration.mp4');
		v = VideoWriter(filename, 'MPEG-4');
		v.Quality = 100;
		v.FrameRate = 10;
		open(v);		
	else
		warning('Wrong Input!'); return;
	end
	freqList = load(strcat(outPath_, 'frequencyList.dat'));
	numFreq = length(freqList);
	hF = figure; axis equal; axis tight; axis off; 
	if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
		camproj('perspective');	
		if strcmp(eleType_.eleName, 'Solid144')
			patchIndices = eNodMat_(:, [1 2 3  1 2 4  2 3 4  3 1 4])'; %% need to be verified
			patchIndices = reshape(patchIndices(:), 3, 4*numEles_);		
			numNodsEleFace = 3;
		else
			patchIndices = eNodMat_(:, [4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
			patchIndices = reshape(patchIndices(:), 4, 6*numEles_);
			numNodsEleFace = 4;
		end
		tmp = nodState_(patchIndices); tmp = sum(tmp,1);
		boundaryEleFaces = patchIndices(:,find(numNodsEleFace==tmp));
		amp = reshape(amp, 3, numNodes_)';
		for ii=1:numFreq
			iFreq = freqList(ii);
			disp([' Freq.: ' sprintf('%12.3f',iFreq) ' Progress.: ' sprintf('%6i',ii) ' | Total.: ' sprintf('%6i',numFreq)]);

			iFileName = sprintf(strcat(outPath_, 'frequencyResponse-step-%d.mat'), ii);
			resp = load(iFileName);
			amp = resp.U_;
			if isempty(scalingFac)
				minFeaterSize = min(boundingBox_(2,:)-boundingBox_(1,:)); selfFac = 10;
				scalingFac = minFeaterSize/selfFac/max(abs(amp));		
			end			
			amp = reshape(amp, 3, numNodes_)';
			
			deformedMeshCoords = nodeCoords_+scalingFac*amp;
			xPatchs = deformedMeshCoords(:,1); xPatchs = xPatchs(boundaryEleFaces);
			yPatchs = deformedMeshCoords(:,2); yPatchs = yPatchs(boundaryEleFaces);
			zPatchs = deformedMeshCoords(:,3); zPatchs = zPatchs(boundaryEleFaces);
			cPatchs = vecnorm(amp,2,2); cPatchs = cPatchs(boundaryEleFaces);
			
			hGlyph = patch(xPatchs, yPatchs, zPatchs, cPatchs);	
			if 1==style
				colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
			elseif 2==style
				set(hGlyph, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
			else
				error('Wrong Input!');
			end
			if 1==ii
				view(3); camzoom(cameraZoomScaling);
				axis vis3d;
				disp('Adjust the Posture of the Object for better Presentation!');
				pause;
            end		
			lighting gouraud;
			material dull;			
			hdLight = camlight('headlight','infinite');
			f = getframe(1);
			
			if strcmp(outPutType, 'Animation')
				im = frame2im(f);
				[imind, cm] = rgb2ind(im, 256);
				if ii == 1
					imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
				else
					imwrite(imind, cm, fileName, 'gif', 'writeMode', 'append', 'DelayTime', 0.1);
				end			
			else
				writeVideo(v,f);
			end
			set(hGlyph, 'visible', 'off');
			set(hdLight,'visible','off');
		end
	elseif strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')		
		for ii=1:numFreq
			iFreq = freqList(ii);
			disp([' Freq.: ' sprintf('%12.3f',iFreq) ' Progress.: ' sprintf('%6i',ii) ' | Total.: ' sprintf('%6i',numFreq)]);
			iFileName = sprintf(strcat(outPath_, 'frequencyResponse-step-%d.mat'), ii);
			resp = load(iFileName);
			amp = resp.U_;
			if isempty(scalingFac)
				minFeaterSize = min(boundingBox_(2,:)-boundingBox_(1,:)); selfFac = 10;
				scalingFac = minFeaterSize/selfFac/max(abs(amp));		
			end	
			amp = reshape(amp, 2, numNodes_)';

			deformedMeshCoords = nodeCoords_+scalingFac*amp;
			xPatchs = deformedMeshCoords(:,1); xPatchs = xPatchs(eNodMat_');
			yPatchs = deformedMeshCoords(:,2); yPatchs = yPatchs(eNodMat_');				
			cPatchs = vecnorm(amp,2,2); cPatchs = cPatchs(eNodMat_');
			
			hGlyph = patch(xPatchs, yPatchs, cPatchs);
			if 1==style
				colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
			elseif 2==style
				set(hGlyph, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
			else
				error('Wrong Input!');				
			end
			f = getframe(1);
			
			if strcmp(outPutType, 'Animation')
				im = frame2im(f);
				[imind, cm] = rgb2ind(im, 256);
				if ii == 1
					imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
				else
					imwrite(imind, cm, fileName, 'gif', 'writeMode', 'append', 'DelayTime', 0.1);
				end
			else
				writeVideo(v,f);
			end				
			set(hGlyph, 'visible', 'off');			
		end
	elseif strcmp(eleType_.eleName, 'Shell133') || strcmp(eleType_.eleName, 'Shell144')
	
	end
	close(hF);
	if strcmp(outPutType, 'Video'), close(v); end
end