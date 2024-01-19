function ShowTransientProcess(varType, scalingFac, outPutType, varargin)
	global eleType_;
	global nodeCoords_;
	global numNodes_;
	global eNodMat_;
	global displacmentHistory_;
	global velocityHistory_;
	global accelerationHistory_;	
	global timeAxis_;
	global boundingBox_;
	global boundaryFaceNodMat_;
	global outPath_;
	
	if isempty(displacmentHistory_), warning('The transient result does not exist!'); return; end
	if isempty(scalingFac)
		minFeaterSize = min(boundingBox_(2,:)-boundingBox_(1,:)); selfFac = 10;
		scalingFac = minFeaterSize/selfFac/max(abs(displacmentHistory_(:,end)));		
	end

	if 4==nargin, cameraZoomScaling = varargin{1}; else, cameraZoomScaling = 1; end
	if strcmp(outPutType, 'Animation')
		fileName = strcat(outPath_, 'TransientProcess.gif');
	elseif strcmp(outPutType, 'Video')
		filename = strcat(outPath_, 'TransientProcess.mp4');
		v = VideoWriter(filename, 'MPEG-4');
		v.Quality = 100;
		v.FrameRate = 10;
		open(v);		
	else
		warning('Wrong Input!'); return;
	end
	style = 2;
	nFrame = size(displacmentHistory_,2);
	hF = figure; axis('equal'); axis('tight'); axis('off'); 
	switch varType
		case 'D' %%Displacement
			if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
				camproj('perspective');	
				for ii=1:nFrame
					disp(['Progress: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
					srcField = reshape(displacmentHistory_(:,ii), 3, numNodes_)';
					deformedMeshCoords = nodeCoords_+scalingFac*srcField;
					xPatchs = deformedMeshCoords(:,1); xPatchs = xPatchs(boundaryFaceNodMat_');
					yPatchs = deformedMeshCoords(:,2); yPatchs = yPatchs(boundaryFaceNodMat_');
					zPatchs = deformedMeshCoords(:,3); zPatchs = zPatchs(boundaryFaceNodMat_');
					cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(boundaryFaceNodMat_');
					
					hGlyph = patch(xPatchs, yPatchs, zPatchs, cPatchs);
					title(['Transient Deformation. Time: ', sprintf('%.3e', timeAxis_(ii)), 's of ', sprintf('%.3e', timeAxis_(end)), 's.']);					
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
					lighting('gouraud');
					material('dull');			
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
				for ii=1:nFrame
					disp([' Progress.: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
					srcField = reshape(displacmentHistory_(:,ii), 2, numNodes_)';
					deformedMeshCoords = nodeCoords_+scalingFac*srcField;
					xPatchs = deformedMeshCoords(:,1); xPatchs = xPatchs(eNodMat_');
					yPatchs = deformedMeshCoords(:,2); yPatchs = yPatchs(eNodMat_');				
					cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(eNodMat_');
					
					hGlyph = patch(xPatchs, yPatchs, cPatchs);
					title(['Transient Deformation. Time: ', sprintf('%.3e', timeAxis_(ii)), 's of ', sprintf('%.3e', timeAxis_(end)), 's.']);
					if 1==style
						colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
					elseif 2==style
						set(hGlyph, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'k');
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
		case 'V' %%Velocity
			if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
				camproj('perspective');	
				for ii=1:nFrame
					disp(['Progress: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
					srcField = reshape(velocityHistory_(:,ii), 3, numNodes_)';
					xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(boundaryFaceNodMat_');
					yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(boundaryFaceNodMat_');
					zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(boundaryFaceNodMat_');
					cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(boundaryFaceNodMat_');
					
					hGlyph = patch(xPatchs, yPatchs, zPatchs, cPatchs);
					title(['Transient Velocity. Time: ', sprintf('%.3e', timeAxis_(ii)), 's of ', sprintf('%.3e', timeAxis_(end)), 's.']);					
					colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
					if 1==ii
						view(3); camzoom(cameraZoomScaling);
						axis vis3d;
						disp('Adjust the Posture of the Object for better Presentation!');
						pause;
					end		
					lighting('gouraud');
					material('dull');			
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
				for ii=1:nFrame
					disp([' Progress.: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
					srcField = reshape(velocityHistory_(:,ii), 2, numNodes_)';
					xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(eNodMat_');
					yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(eNodMat_');				
					cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(eNodMat_');
					
					hGlyph = patch(xPatchs, yPatchs, cPatchs);
					title(['Transient Velocity. Time: ', sprintf('%.3e', timeAxis_(ii)), 's of ', sprintf('%.3e', timeAxis_(end)), 's.']);
					colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
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
		case 'A' %%Acceleartion
			if strcmp(eleType_.eleName, 'Solid144') || strcmp(eleType_.eleName, 'Solid188')
				camproj('perspective');	
				for ii=1:nFrame
					disp(['Progress: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
					srcField = reshape(accelerationHistory_(:,ii), 3, numNodes_)';
					xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(boundaryFaceNodMat_');
					yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(boundaryFaceNodMat_');
					zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(boundaryFaceNodMat_');
					cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(boundaryFaceNodMat_');
					
					hGlyph = patch(xPatchs, yPatchs, zPatchs, cPatchs);
					title(['Transient Acceleration. Time: ', sprintf('%.3e', timeAxis_(ii)), 's of ', sprintf('%.3e', timeAxis_(end)), 's.']);					
					colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
					if 1==ii
						view(3); camzoom(cameraZoomScaling);
						axis vis3d;
						disp('Adjust the Posture of the Object for better Presentation!');
						pause;
					end		
					lighting('gouraud');
					material('dull');			
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
				for ii=1:nFrame
					disp([' Progress.: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
					srcField = reshape(accelerationHistory_(:,ii), 2, numNodes_)';
					xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(eNodMat_');
					yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(eNodMat_');				
					cPatchs = vecnorm(srcField,2,2); cPatchs = cPatchs(eNodMat_');
					
					hGlyph = patch(xPatchs, yPatchs, cPatchs);
					title(['Transient Acceleration. Time: ', sprintf('%.3e', timeAxis_(ii)), 's of ', sprintf('%.3e', timeAxis_(end)), 's.']);
					colormap('jet'); set(hGlyph, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
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
	end

	close(hF);
	if strcmp(outPutType, 'Video'), close(v); end
end