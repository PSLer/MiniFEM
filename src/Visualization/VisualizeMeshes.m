function handlePatchs = VisualizeMeshes(varargin)
	%%VisualizeMeshes()
	%%VisualizeMeshes(arg), arg = eleList or 'qualityMetric_On'
	%%%VisualizeMeshes(arg1,arg2), arg1 = eleList, arg2 = 'qualityMetric_On'
	global domainType_;
	global nodeCoords_;
	global patchIndices_;
	global JacobianRatio_;	
	if 0==numel(patchIndices_), InitializeQuadPatchs4Rendering(); end
	if nargin>2, error('Wrong input for checking mesh quality!'); end
	switch nargin
		case 0
			inVar = ScalarFieldForVolumeRendering();
			inVar.scalarFiled = zeros(size(nodeCoords_,1),1);
			inVar.shiftingTerm = repmat(inVar.scalarFiled,size(nodeCoords_,2),1);
			inVar.scalingFac = 0;
			inVar.dispOpt = 'meshWise';
			handlePatchs = DirectlyVolumeRenderingScalarField(inVar); axis on
			if strcmp(domainType_, '2D'), xlabel('X'); ylabel('Y');
			else, xlabel('X'); ylabel('Y'); zlabel('Z'); end
		case 1
			if isnumeric(varargin{1})
				inVar = ScalarFieldForVolumeRendering();
				inVar.eleList = varargin{1};
				inVar.scalarFiled = zeros(size(nodeCoords_,1),1);
				inVar.shiftingTerm = repmat(inVar.scalarFiled,size(nodeCoords_,2),1);
				inVar.scalingFac = 0;
				inVar.dispOpt = 'meshWise';
				handlePatchs = DirectlyVolumeRenderingScalarField(inVar); axis on
				if strcmp(domainType_, '2D'), xlabel('X'); ylabel('Y');
				else, xlabel('X'); ylabel('Y'); zlabel('Z'); end				
			elseif strcmp(varargin{1}, 'qualityMetric_On')
				switch domainType_
					case '2D'
						xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(patchIndices_);
						yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(patchIndices_);
						cPatchs = repmat(JacobianRatio_',4,1);
						handlePatchs = patch(xPatchs, yPatchs, cPatchs); hold on;
						colormap('jet');
						xlabel('X'); ylabel('Y');
					case '3D'
						xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(patchIndices_);
						yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(patchIndices_);
						zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(patchIndices_);
						cPatchs = repmat(JacobianRatio_',6,1);
						cPatchs = reshape(cPatchs, numel(cPatchs), 1);
						cPatchs = repmat(cPatchs',4,1);
						handlePatchs = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on; 
						colormap('jet');
						xlabel('X'); ylabel('Y'); zlabel('Z');
						view(3); camproj('perspective');
				end
				h = colorbar; t=get(h,'Limits');
				set(h,'Ticks',linspace(t(1),t(2),5),'AxisLocation','out');	
				L=cellfun(@(x)sprintf('%.2f',x),num2cell(linspace(t(1),t(2),5)),'Un',0); 
				set(h,'xticklabel',L);		
				set(handlePatchs, 'FaceColor', 'Flat', 'FaceAlpha', 1.0, 'EdgeColor', 'k');					
			else
				error('Wrong input for checking mesh quality!');
			end
		case 2
			if isnumeric(varargin{1}) & strcmp(varargin{2}, 'qualityMetric_On')
				tmp = varargin{1}; 
				if strcmp(domainType_, '2D')
					patchsList = patchIndices_(:,tmp(:)');
				else
					tmp1 = repmat(6*tmp(:), 1, 6) - (5:-1:0); 
					tmp1 = reshape(tmp1', numel(tmp1), 1)';	
					patchsList = patchIndices_(:,tmp1); 
				end
				switch domainType_
					case '2D'
						xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(patchsList);
						yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(patchsList);
						cPatchs = repmat(JacobianRatio_',4,1); cPatchs = cPatchs(patchsList);
						handlePatchs = patch(xPatchs, yPatchs, cPatchs); hold on;
						colormap('jet');
						xlabel('X'); ylabel('Y');
					case '3D'
						xPatchs = nodeCoords_(:,1); xPatchs = xPatchs(patchsList);
						yPatchs = nodeCoords_(:,2); yPatchs = yPatchs(patchsList);
						zPatchs = nodeCoords_(:,3); zPatchs = zPatchs(patchsList);
						cPatchs = repmat(JacobianRatio_',6,1);
						cPatchs = reshape(cPatchs, numel(cPatchs), 1);
						cPatchs = repmat(cPatchs',4,1); cPatchs = cPatchs(patchsList);
						handlePatchs = patch(xPatchs, yPatchs, zPatchs, cPatchs); hold on; 
						colormap('jet');
						xlabel('X'); ylabel('Y'); zlabel('Z');
						view(3); camproj('perspective');
				end
				h = colorbar; t=get(h,'Limits');
				set(h,'Ticks',linspace(t(1),t(2),5),'AxisLocation','out');	
				L=cellfun(@(x)sprintf('%.2f',x),num2cell(linspace(t(1),t(2),5)),'Un',0); 
				set(h,'xticklabel',L);		
				set(handlePatchs, 'FaceColor', 'Flat', 'FaceAlpha', 1.0, 'EdgeColor', 'k');				
			else
				error('Wrong input for checking mesh quality!');
			end
	end
	axis equal; 
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20)
end