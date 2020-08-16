function GetGIF3D(filename)
	%set(gca,'color','k');
	%axis off
%%============================================================
	% camlight('headlight','infinite')
	% camlight('right','infinite')
	% camlight('left','infinite')		
	% numSamp = 72;
	% step = 360/numSamp;
	% for ii=1:1:numSamp
		% az = ii*step; 
		% el = 30; 
		% view(az, el);
		% f = getframe(1);
		% im = frame2im(f);
		% [imind, cm] = rgb2ind(im, 256);
		% %pause(0.1);
		% if ii == 1
			% imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.0);
		% else
			% imwrite(imind, cm, filename, 'gif', 'writeMode', 'append', 'DelayTime', 0.0);
		% end	
	% end
	
%%============================================================
	[az0 el] = view;
	numCamera = 6;
	subZoneSize = 360/numCamera;
	numSamp = 72;
	sampPerSubZone = numSamp/numCamera;
	step = 360/numSamp;
	for ii=0:1:numCamera-1
		az1 = ii*subZoneSize+az0;
		% if 0==ii
			% handleForLightSource = camlight(az1, el);
			% handleForLightSource = repmat(handleForLightSource,numCamera,1);
		% else
			% handleForLightSource(ii+1) = camlight(az1, el);
		% end
		for jj=step:step:subZoneSize
			az2 = ii*subZoneSize+jj+az0;
			view(az2, el);
			f = getframe(gcf);
			im = frame2im(f);
			[imind, cm] = rgb2ind(im, 256);
			pause(0.1);
			if ii==0 && jj==step
				imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 1.0);
			else
				imwrite(imind, cm, filename, 'gif', 'writeMode', 'append', 'DelayTime', 1.0);
			end			
		end
		%set(handleForLightSource(ii+1),'visible','off');
	end

end