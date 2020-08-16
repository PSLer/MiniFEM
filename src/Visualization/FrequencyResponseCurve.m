function FrequencyResponseCurve(tarNodIdx, dir)
	global domainType_;
	global solSpace_;
	global freqSweepSamplings_;
	
	switch domainType_
		case '2D'
			sol2beDrawn = solSpace_(2*(tarNodIdx-1)+[1;2]',:);			
		case '3D'
			sol2beDrawn = solSpace_(3*(tarNodIdx-1)+[1;2;3]',:);	
	end
	switch dir
		case 'X'
			tar = sol2beDrawn(1,:);
		case 'Y'
			tar = sol2beDrawn(2,:);
		case 'Z'
			if strcmp(domainType_, '2D')
				error('Wrong input in drawing frequency response curve!');
			end
			tar = sol2beDrawn(3,:);
		case 'T'
			tar = vecnorm(sol2beDrawn,2,1);
	end
	plot(freqSweepSamplings_, tar*1.0e3, '-xk', 'LineWidth', 2, 'MarkerSize', 8); 
	xlabel('frequency: Hz'); ylabel('displacement: mm');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
end