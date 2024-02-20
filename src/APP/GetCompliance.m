function c = GetCompliance(varargin)
	global meshType_;
	global material_;
	global eleType_;
	global freeDOFs_;
	global F_;
	global K_;
	global U_;
	global fixingCond_; 
	global loadingCond_;
	global numEles_;
	global eDofMat_;
	global nodeCoords_;
	global eNodMat_;
	global Ke_;

	if isempty(fixingCond_), error('No Constraint!'); end
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	
	tStart = tic;
	if 0==nargin
		U_ = SolvingStaticLinearSystemEquations();
	elseif 1==nargin
		if strcmp(varargin{1}, 'DIRECT') || strcmp(varargin{1}, 'ITERATIVE')
			U_ = SolvingStaticLinearSystemEquations(varargin{1});
		else
			error('Wrong Input!');
		end	
	else
		error('Wrong Input!');
	end
	disp(['Compute Static Deformation Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	
	if 1==length(material_.modulus) && 1==length(material_.poissonRatio) && strcmp(meshType_, 'Cartesian')
		ce = zeros(numEles_,1);
		blockIndex = PartitionMission4CPU(numEles_, 1.0e6);
		for ii=1:size(blockIndex,1)
			rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
			iReshapedU = U_(eDofMat_(rangeIndex,:));
			ce(rangeIndex,1) = ce(rangeIndex,1) + sum((iReshapedU*Ke_).*iReshapedU,2);
		end
		ce(ce<0)=1.0e-16;
		c = sum(ce);
		if strcmp(eleType_.eleName, 'Plane144')
			xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(eNodMat_');
			yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(eNodMat_');
			cPatchs = ce(:)';
			if 1
				cPatchs = log(cPatchs);
			else
				cPatchs = cPatchs.^(1/4);
			end
			cPatchs = repmat(cPatchs, 4, 1);
			figure;
			% colormap(flip(gray));
			colormap('jet');
			hd = patch(xPatchs, yPatchs, cPatchs); hold on;
			set(hd, 'FaceColor', 'Interp', 'FaceAlpha', 1, 'EdgeColor', 'None');
			axis('equal'); axis('tight'); axis('off');
            h = colorbar;%('southoutside'); 
            t=get(h,'Limits'); 
            colorbarIntervals = 7;
            set(h,'Ticks',linspace(t(1),t(2),colorbarIntervals),'AxisLocation','out');	
            L=cellfun(@(x)sprintf('%.2e',x),num2cell(linspace(t(1),t(2),colorbarIntervals)),'Un',0); 
            set(h,'xticklabel',L);		
            axis('equal'); axis('tight'); axis('off');
            set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);				
		end
	else
		c = U_(freeDOFs_,1)' * (K_*U_(freeDOFs_,1));
	end
	
end