function D = ElementElasticityMatrix()	
	global domainType_;
	global eleType_;
	HL = HookeLaw();
	switch domainType_
		case '2D'
			D = zeros(12);
			for ii=1:4
				index = (ii-1)*3+1:ii*3;
				D(index,index) = HL;
			end
		case '3D'
			D = zeros(48);
			for ii=1:8
				index = (ii-1)*6+1:ii*6;
				D(index,index) = HL;
			end						
	end
	D = sparse(D);
end