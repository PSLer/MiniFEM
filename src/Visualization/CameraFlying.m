function CameraFlying()
	global eleType_;
	global outPath_;
	if strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144')
		warning('Only Work with 3D Object!');
	end
	
	filename = strcat(outPath_, '/rotatingObject3D.gif');
	[az, el] = view;
	nFrame = 180;
	step = 360/nFrame;
	light('visible', 'off');
	lighting gouraud;
	material dull;
	for ii=1:nFrame
		disp([' Progress.: ' sprintf('%6i',ii) ' Total.: ' sprintf('%6i',nFrame)]);
		hdLight = camlight(az, el);
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
end