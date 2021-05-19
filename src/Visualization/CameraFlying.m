function CameraFlying(varargin)
	global eleType_;
	global outPath_;
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		warning('Only Work with 3D Object!'); return;
	end
	
	if 0==nargin
		outputType = 'Animation';
	elseif strcmp(varargin{1}, 'Animation') || strcmp(varargin{1}, 'Video')
		outputType = 'Video';
	else
		warning('Wrong Input!'); return;
	end

	[az, el] = view;
	nFrame = 180;
	step = 360/nFrame;
	light('visible', 'off');
	lighting gouraud;
	switch outputType
		case 'Animation'
			filename = strcat(outPath_, 'rotatingObject3D.gif');
			for ii=1:nFrame
				disp([' Progress.: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
				hdLight = camlight(az, el);
				material dull; %% dull, shiny, metal
				f = getframe(gcf);
				im = frame2im(f);
				[imind, cm] = rgb2ind(im, 256);
				% pause(0.5);
				if ii==1
					imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
				else
					imwrite(imind, cm, filename, 'gif', 'writeMode', 'append', 'DelayTime', 0.1);
				end
				set(hdLight,'visible','off');
				az = step+az;
				view(az, el);
			end		
		case 'Video'		
			filename = strcat(outPath_, 'rotatingObject3D.mp4');
			v = VideoWriter(filename, 'MPEG-4');
			v.Quality = 100;
			v.FrameRate = 10;
			open(v);
			for ii=1:nFrame
				disp([' Progress.: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
				hdLight = camlight(az, el);
				material dull; %% dull, shiny, metal
				f = getframe(gcf);
				writeVideo(v,f);
				set(hdLight,'visible','off');
				az = step+az;
				view(az, el);
			end
			close(v);
	end
end