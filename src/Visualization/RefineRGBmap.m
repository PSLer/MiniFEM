function refinedMap = RefineRGBmap(originalMap)
	% plot(sampX, originalMap(:,1), '-xr', 'LineWidth', 2, 'MarkerSize', 8); hold on
	% plot(sampX, originalMap(:,2), '-xg', 'LineWidth', 2, 'MarkerSize', 8); hold on
	% plot(sampX, originalMap(:,3), '-xb', 'LineWidth', 2, 'MarkerSize', 8); hold on
	sampX = (1:size(originalMap,1))';
	step = 0.1; refinedX = (sampX(1):step:sampX(end))';
	
	sampY_Red = originalMap(:,1);
	Y_Red = LagrangeInterpola(refinedX,sampX,sampY_Red);
	Y_Red(Y_Red<0) = 0; Y_Red(Y_Red>1) = 1;
	
	
	sampY_Green = originalMap(:,2);
	Y_Green = LagrangeInterpola(refinedX,sampX,sampY_Green);
	Y_Green(Y_Green<0) = 0; Y_Green(Y_Green>1) = 1;
	
	sampY_Blue = originalMap(:,3);
	Y_Blue = LagrangeInterpola(refinedX,sampX,sampY_Blue);
	Y_Blue(Y_Blue<0) = 0; Y_Blue(Y_Blue>1) = 1;
	
	% plot(refinedX, Y_Red, '-r', 'LineWidth', 2); hold on
	% plot(refinedX, Y_Green, '-g', 'LineWidth', 2); hold on
	% plot(refinedX, Y_Blue, '-b', 'LineWidth', 2); hold on
	
	refinedMap = [Y_Red Y_Green Y_Blue];	
end

	%%red
	% originalMap = [	255,	245,	240
					% 254,	224,	210
					% 252,	187,	161
					% 252,	146,	114
					% 251,	106,	74
					% 239,	59,		44
					% 203,	24,		29
					% 165,	15,		21
					% 103,	0,		13]/255;
	
	%%green
	% originalMap = [	247,	252,	245
					% 229,	245,	224
					% 199,	233,	192
					% 161,	217,	155
					% 116,	196,	118
					% 65,		171,	93
					% 35,		139,	69
					% 0,		109,	44
					% 0,		68,		27]/255;
	%% blue
	% originalMap = [	%247,	251,	255
					% %222,	235,	247
					% 198,	219,	239
					% 158,	202,	225
					% 107,	174,	214
					% 66,	146,	198
					% 33,	113,	181
					% 8,	81,		156
					% 8,	48,		107]/255;	


