function outerInterpolationMatrix = OuterInterpolationMat()
	global domainType_;
	switch domainType_
		case '2D'
			[s t w] = GaussianIntegral();
			N = ShapeFunction(s,t);
			sFM = sparse(12,12);
			ii = 3*(1:4);
			sFM(1,ii-2) = N(1,:); sFM(2,ii-1) = N(1,:); sFM(3,ii) = N(1,:);
			sFM(4,ii-2) = N(2,:); sFM(5,ii-1) = N(2,:);	sFM(6,ii) = N(2,:);	
			sFM(7,ii-2) = N(3,:); sFM(8,ii-1) = N(3,:); sFM(9,ii) = N(3,:);	
			sFM(10,ii-2) = N(4,:); sFM(11,ii-1) = N(4,:); sFM(12,ii) = N(4,:);			
		case '3D'
			[s t p w] = GaussianIntegral();
			N = ShapeFunction(s,t,p);
			sFM = sparse(48,48);
			ii = 6*(1:8);
			sFM(1,ii-5) = N(1,:); sFM(2,ii-4) = N(1,:); sFM(3,ii-3) = N(1,:);
			sFM(4,ii-2) = N(1,:); sFM(5,ii-1) = N(1,:); sFM(6,ii) = N(1,:);
			
			sFM(7,ii-5) = N(2,:); sFM(8,ii-4) = N(2,:); sFM(9,ii-3) = N(2,:);
			sFM(10,ii-2) = N(2,:); sFM(11,ii-1) = N(2,:); sFM(12,ii) = N(2,:);

			sFM(13,ii-5) = N(3,:); sFM(14,ii-4) = N(3,:); sFM(15,ii-3) = N(3,:);
			sFM(16,ii-2) = N(3,:); sFM(17,ii-1) = N(3,:); sFM(18,ii) = N(3,:);	

			sFM(19,ii-5) = N(4,:); sFM(20,ii-4) = N(4,:); sFM(21,ii-3) = N(4,:);
			sFM(22,ii-2) = N(4,:); sFM(23,ii-1) = N(4,:); sFM(24,ii) = N(4,:);

			sFM(25,ii-5) = N(5,:); sFM(26,ii-4) = N(5,:); sFM(27,ii-3) = N(5,:);
			sFM(28,ii-2) = N(5,:); sFM(29,ii-1) = N(5,:); sFM(30,ii) = N(5,:);	

			sFM(31,ii-5) = N(6,:); sFM(32,ii-4) = N(6,:); sFM(33,ii-3) = N(6,:);
			sFM(34,ii-2) = N(6,:); sFM(35,ii-1) = N(6,:); sFM(36,ii) = N(6,:);	

			sFM(37,ii-5) = N(7,:); sFM(38,ii-4) = N(7,:); sFM(39,ii-3) = N(7,:);
			sFM(40,ii-2) = N(7,:); sFM(41,ii-1) = N(7,:); sFM(42,ii) = N(7,:);	

			sFM(43,ii-5) = N(8,:); sFM(44,ii-4) = N(8,:); sFM(45,ii-3) = N(8,:);
			sFM(46,ii-2) = N(8,:); sFM(47,ii-1) = N(8,:); sFM(48,ii) = N(8,:);				
	end
	outerInterpolationMatrix = inv(sFM);
end
