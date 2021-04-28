function Ns = GetElementStressInterpolationMatrix()
	global eleType_;
	switch eleType_.eleName 
		case 'Plane133'
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussIPs);
		case 'Plane144'
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussIPs);
			Ns = sparse(12,12);
			ii = 3*(1:4);
			Ns(1,ii-2) = N(1,:); Ns(2,ii-1) = N(1,:); Ns(3,ii) = N(1,:);
			Ns(4,ii-2) = N(2,:); Ns(5,ii-1) = N(2,:);	Ns(6,ii) = N(2,:);	
			Ns(7,ii-2) = N(3,:); Ns(8,ii-1) = N(3,:); Ns(9,ii) = N(3,:);	
			Ns(10,ii-2) = N(4,:); Ns(11,ii-1) = N(4,:); Ns(12,ii) = N(4,:);				
		case 'Solid144'
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			N = ShapeFunction(gaussIPs);
		case 'Solid188'
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:3,:)';
			N = ShapeFunction(gaussIPs);
			Ns = sparse(48,48);
			ii = 6*(1:8);
			Ns(1,ii-5) = N(1,:); Ns(2,ii-4) = N(1,:); Ns(3,ii-3) = N(1,:);
			Ns(4,ii-2) = N(1,:); Ns(5,ii-1) = N(1,:); Ns(6,ii) = N(1,:);
			
			Ns(7,ii-5) = N(2,:); Ns(8,ii-4) = N(2,:); Ns(9,ii-3) = N(2,:);
			Ns(10,ii-2) = N(2,:); Ns(11,ii-1) = N(2,:); Ns(12,ii) = N(2,:);

			Ns(13,ii-5) = N(3,:); Ns(14,ii-4) = N(3,:); Ns(15,ii-3) = N(3,:);
			Ns(16,ii-2) = N(3,:); Ns(17,ii-1) = N(3,:); Ns(18,ii) = N(3,:);	

			Ns(19,ii-5) = N(4,:); Ns(20,ii-4) = N(4,:); Ns(21,ii-3) = N(4,:);
			Ns(22,ii-2) = N(4,:); Ns(23,ii-1) = N(4,:); Ns(24,ii) = N(4,:);

			Ns(25,ii-5) = N(5,:); Ns(26,ii-4) = N(5,:); Ns(27,ii-3) = N(5,:);
			Ns(28,ii-2) = N(5,:); Ns(29,ii-1) = N(5,:); Ns(30,ii) = N(5,:);	

			Ns(31,ii-5) = N(6,:); Ns(32,ii-4) = N(6,:); Ns(33,ii-3) = N(6,:);
			Ns(34,ii-2) = N(6,:); Ns(35,ii-1) = N(6,:); Ns(36,ii) = N(6,:);	

			Ns(37,ii-5) = N(7,:); Ns(38,ii-4) = N(7,:); Ns(39,ii-3) = N(7,:);
			Ns(40,ii-2) = N(7,:); Ns(41,ii-1) = N(7,:); Ns(42,ii) = N(7,:);	

			Ns(43,ii-5) = N(8,:); Ns(44,ii-4) = N(8,:); Ns(45,ii-3) = N(8,:);
			Ns(46,ii-2) = N(8,:); Ns(47,ii-1) = N(8,:); Ns(48,ii) = N(8,:);				
		case 'Shell133'
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussIPs);
		case 'Shell144'
			gaussIPs = eleType_.GaussIntegralPointsNaturalSpace(1:2,:)';
			N = ShapeFunction(gaussIPs);
	end
end
