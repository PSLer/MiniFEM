function val = DelightfulColors(opt)
	switch opt
		case 'Default'
			val = [65 174 118]/255;
		case 'Concrete'
			val = [206 205 203]/255;
		case 'Stainless'
			val = [224 223 219]/255;	
		otherwise
			error('No Available Color!');
	end
end