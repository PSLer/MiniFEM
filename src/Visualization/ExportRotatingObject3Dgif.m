function ExportRotatingObject3Dgif()
	global outPath_;
	filename = strcat(outPath_, '/rotatingObject3D.gif');
	[az0 el] = view;
	numSamp = 36;
	step = 360/numSamp;
	
	for ii=1:1:numSamp
		handleForLightSource = camlight(az0, el);
		f = getframe(gcf);
		im = frame2im(f);
		[imind, cm] = rgb2ind(im, 256);
		if ii==1
			imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 1.0);
		else
			imwrite(imind, cm, filename, 'gif', 'writeMode', 'append', 'DelayTime', 1.0);
		end
		set(handleForLightSource,'visible','off');
		az0 = ii*step+az0;
		view(az0, el);
	end
end