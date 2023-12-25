function VisTrussOptiHistory(varargin)
	global outPath_;
	global optiNodeHist_;
	global eNodMat_; 
	global diameterList_;
	global objOptiHist_;
	
	if isempty(optiNodeHist_), return; end
	[~,~,MaxIt] = size(optiNodeHist_);
	if 0==nargin
		outputType = 'Video';
	elseif strcmp(varargin{1}, 'Animation') || strcmp(varargin{1}, 'Video')
		outputType = varargin{1};
	else
		warning('Wrong Input!'); return;
	end	
	if strcmp(outputType, 'Animation')
		fileName = strcat(outPath_, 'FrameOptiHist.gif');
	elseif strcmp(outputType, 'Video')
		filename = strcat(outPath_, 'FrameOptiHist.mp4');
		v = VideoWriter(filename, 'MPEG-4');
		v.Quality = 100;
		v.FrameRate = 10;
		open(v);		
	else
		warning('Wrong Input!'); return;
	end	
	hF = figure; 
	for ii=1:MaxIt
		disp(['Iteration: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',MaxIt)]);
		[gridX, gridY, gridZ, gridC] = Extend3DMeshEdges2Tubes(optiNodeHist_(:,:,ii), eNodMat_, diameterList_);
		hd = surf(gridX, gridY, gridZ, gridC);
		axis('equal'); axis('tight'); axis('off');
		title(['Iteration: ', sprintf('%d', ii-1), '; C: ', sprintf('%.4f', objOptiHist_(ii,1)),  '; V: ', ...
			sprintf('%.4f', objOptiHist_(ii,2)), '; M: ', sprintf('%.4f', objOptiHist_(ii,1)*objOptiHist_(ii,2))]);
		set(hd, 'FaceColor', DelightfulColors('Default'), 'FaceAlpha', 1, 'EdgeColor', 'None');
		set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
		if 1==ii
			view(3);
			axis vis3d;
			disp('Adjust the Posture of the Object for better Presentation!');
			pause;
        end
		lighting('gouraud');
		material('dull');			
		hdLight = camlight('headlight','infinite');
		f = getframe(1);
		if strcmp(outputType, 'Animation')
			im = frame2im(f);
			[imind, cm] = rgb2ind(im, 256);
			if ii == 1
				imwrite(imind, cm, fileName, 'gif', 'Loopcount', inf, 'DelayTime', 1.0);
			else
				imwrite(imind, cm, fileName, 'gif', 'writeMode', 'append', 'DelayTime', 1.0);
			end			
		else
			writeVideo(v,f);
		end
		set(hd, 'visible', 'off');
		set(hdLight,'visible','off');		
	end
	close(hF);
	if strcmp(outputType, 'Video'), close(v); end	
end