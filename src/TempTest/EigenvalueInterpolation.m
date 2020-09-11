function EigenvalueInterpolation(iEle)
	%%1. para control
	global cartesianStressField_;
	global eNodMat_;
	stressTensor = cartesianStressField_(eNodMat_(iEle,:)',:);
	interpolationOrder = 2;
	stepSize = 0.1;
	lb = [-1 -1];
	ub = [1 1];
	[paraS paraT] = meshgrid(-1:stepSize:1,-1:stepSize:1);
	[ny nx] = size(paraS);
	numSamplingPoints = numel(paraS);
	
	%%2. compute
	%%2.1 analytic
	ps_major_ana = zeros(ny, nx);
	ps_major_num = zeros(ny, nx);
	ps_minor_ana = zeros(ny, nx);
	ps_minor_num = zeros(ny, nx);	
	s = reshape(paraS,numSamplingPoints,1);
	t = reshape(paraS,numSamplingPoints,1);
	cartesianStressList = HighOrderShapeFunction2D(s, t, 1)*stressTensor;
	ps_ana = zeros(numSamplingPoints,2);
	for ii=1:1:numSamplingPoints
		A = zeros(2);
		A(1,1) = cartesianStressList(ii,1);
		A(1,2) = cartesianStressList(ii,3);
		A(2,1) = A(1,2);
		A(2,2) = cartesianStressList(ii,2);		
		[eigenVec, eigenVal] = eig(A);
		ps_ana(ii,:) = [eigenVal(2,2) eigenVal(1,1)];
	end
	ps_major_ana = reshape(ps_ana(:,1), ny, nx);
	ps_minor_ana = reshape(ps_ana(:,2), ny, nx);
	
	%%2.2 numerical
	s0 = []; t0 = [];
	switch interpolationOrder
		case 1
			s0 = [-1 1 1 -1]';
			t0 = [-1 -1 1 1]';
		case 2
			s0 = [-1 1 1 -1 0 1 0 -1]';
			t0 = [-1 -1 1 1 -1 0 1 0]';		
	end
	vtxCartesianStress = HighOrderShapeFunction2D(s0, t0, 1)*stressTensor;
	numVtx = length(s0);
	vtxPS = zeros(numVtx,2);
	for ii=1:1:numVtx
		A = zeros(2);
		A(1,1) = vtxCartesianStress(ii,1);
		A(1,2) = vtxCartesianStress(ii,3);
		A(2,1) = A(1,2);
		A(2,2) = vtxCartesianStress(ii,2);		
		[eigenVec, eigenVal] = eig(A);
		vtxPS(ii,:) = [eigenVal(2,2) eigenVal(1,1)];		
	end
	ps_num = HighOrderShapeFunction2D(s, t, interpolationOrder)*vtxPS;
	ps_major_num = reshape(ps_num(:,1), ny, nx);
	ps_minor_num = reshape(ps_num(:,2), ny, nx);	
	
	%%3. vis
	figure(1)
	colormap autumn
	hd_major_ana = surf(paraS, paraT, ps_major_ana); hold on
	hd_major_num = surf(paraS, paraT, ps_major_num); 
	%axis equal; 
	axis tight; axis on;
	set(hd_major_ana, 'edgeColor', 'none');
	set(hd_major_num, 'faceColor', 'none', 'edgeColor', 'k');
	
	hd_major_ana = reshape(ps_major_ana, numel(ps_major_ana), 1);
	hd_major_num = reshape(ps_major_num, numel(ps_major_num), 1);
	interpolationError_major = norm(hd_major_ana-hd_major_num)/norm(hd_major_ana)
	
	
	figure(2)
	colormap summer
	hd_minor_ana = surf(paraS, paraT, ps_minor_ana); hold on
	hd_minor_num = surf(paraS, paraT, ps_minor_num); 
	%axis equal; 
	axis tight; axis on;	
	set(hd_minor_ana, 'edgeColor', 'none');
	set(hd_minor_num, 'faceColor', 'none', 'edgeColor', 'k');
	
	hd_minor_ana = reshape(ps_minor_ana, numel(ps_minor_ana), 1);
	hd_minor_num = reshape(ps_minor_num, numel(ps_minor_num), 1);
	interpolationError_minor = norm(hd_minor_ana-hd_minor_num)/norm(hd_minor_ana)	
	
end

function N = HighOrderShapeFunction2D(s, t, iOrder)
	N = [];
	switch iOrder
		case 1
			N = zeros(size(s,1), 4);
			N(:,1) = 0.25*(1-s).*(1-t);
			N(:,2) = 0.25*(1+s).*(1-t);
			N(:,3) = 0.25*(1+s).*(1+t);
			N(:,4) = 0.25*(1-s).*(1+t);
		case 2
			N = zeros(size(s,1), 8);
			s2 = s.*s;
			t2 = t.*t;
			N(:,1) = 0.25*(1.0-s).*(1.0-t).*(-1.0-s-t);
			N(:,2) = 0.25*(1.0+s).*(1.0-t).*(-1.0+s-t);
			N(:,3) = 0.25*(1.0+s).*(1.0+t).*(-1.0+s+t);
			N(:,4) = 0.25*(1.0-s).*(1.0+t).*(-1.0-s+t);
			N(:,5) = 0.5*(1.0-t).*(1.0-s2);
			N(:,6) = 0.5*(1.0+s).*(1.0-t2);
			N(:,7) = 0.5*(1.0+t).*(1.0-s2);
			N(:,8) = 0.5*(1.0-s).*(1.0-t2);		
	end	
end