function tar = PtV(src)
	global structureState_;
	global Lp_;
	global Up_;
	switch structureState_
		case 'STATIC'
			tar = Lp_'\(Lp_\src);		
		case 'DYNAMIC'
			tar = Up_\(Lp_\src);
	end
end