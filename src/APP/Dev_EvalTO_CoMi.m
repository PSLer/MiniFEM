function Dev_EvalTO_CoMi()
	global meshType_ eleType_;
	global freeDOFs_;
	global F_ K_ U_ cartesianStressField_ vonMisesStressField_;
	global fixingCond_ loadingCond_;
	global numEles_ numDOFs_;
	global eDofMat_ nodeCoords_ eNodMat_;
	global deShapeFuncs_ invJ_ matrixD_ detJ_;
	
	if isempty(fixingCond_), error('No Constraint!'); end
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	
	tStart = tic;
	U_ = SolvingStaticLinearSystemEquations();
	disp(['Compute Static Deformation Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	
	c = U_(freeDOFs_,1)' * (K_*U_(freeDOFs_,1));
	disp(['Compliance: ' sprintf('%10.4e',c)]);
	
	%% sensitivity analysis
	dE = 3;
	Ue = U_(eDofMat_);
	ceList = zeros(numEles_,1);
	wgts = eleType_.GaussIntegralPointsNaturalSpace(3,:)';
	for ii=1:numEles_
		iMatrixB = ElementStrainMatrix(deShapeFuncs_, invJ_(ii).arr);
		iKe = ElementStiffMatrix(iMatrixB, matrixD_.arr, wgts, detJ_(:,ii));
		ceList(ii) = Ue(ii,:) * iKe * Ue(ii,:)';
	end

	xAll = nodeCoords_(:,1); xAll = xAll(eNodMat_); x1 = xAll(:,1); x2 = xAll(:,2); x3 = xAll(:,3);
	yAll = nodeCoords_(:,2); yAll = yAll(eNodMat_); y1 = yAll(:,1); y2 = yAll(:,2); y3 = yAll(:,3);
	AeList = abs(x1.*(y2-y3) + x2.*(y3-y1) + x3.*(y1-y2))/2;
	A = sum(AeList)/0.4;
	AbyAe = A ./ AeList;
	ceList = -dE * AbyAe(:) .* ceList(:);
	
	figure
	hd = patch('Faces', eNodMat_, 'Vertices', nodeCoords_, 'FaceVertexCData', ceList);		
	set(hd, 'FaceColor', 'flat', 'FaceAlpha', 1, 'EdgeColor', 'None');
	colormap(jet);
	h = colorbar; t=get(h,'Limits');	
	caxis([-max(abs(ceList(:))) max(abs(ceList(:)))]);
	h = colorbar; t=get(h,'Limits'); 
	set(h,'Ticks',linspace(t(1),t(2),3),'AxisLocation','out');	
	L=cellfun(@(x)sprintf('%.2f',x),num2cell(linspace(t(1),t(2),3)),'Un',0); 
	set(h,'xticklabel',L);	
	axis equal; axis tight; axis off;
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 40);
	
	%%Stress Ana.
	ComputeCartesianStress();
	vonMisesStressField_ = ComputeVonMisesStress(cartesianStressField_);
	ShowStressComp('Sigma_vM',0);
end