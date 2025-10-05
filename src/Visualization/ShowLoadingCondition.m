function ShowLoadingCondition(varargin)
	global eleType_ nodeCoords_ boundingBox_;
	global loadingCond_;
	if 0==nargin
		loadingCondToBeShow = loadingCond_;
	else
		loadingCondToBeShow = varargin{1};
    end
    if isempty(loadingCondToBeShow), return; end
	
	switch eleType_.eleName
		case {'Plane133', 'Plane144'}
			amps = vecnorm(loadingCondToBeShow(:,2:end),2,2);
			lB = 0.2; uB = 1.0; maxAmp = max(amps); minAmp = min(amps);
			if abs(minAmp-maxAmp)/(minAmp+maxAmp)<0.1
				scalingFac = 1;
			else
				if minAmp/maxAmp>lB/uB, lB = minAmp/maxAmp; end
				scalingFac = lB + (uB-lB)*(amps-minAmp)/(maxAmp-minAmp);
			end
			loadingDirVec = loadingCondToBeShow(:,2:3)./amps.*scalingFac;
			coordLoadedNodes = nodeCoords_(loadingCondToBeShow(:,1),:);
			amplitudesF = mean(boundingBox_(2,:)-boundingBox_(1,:))/5 * loadingDirVec;
			hold('on'); quiver(coordLoadedNodes(:,1), coordLoadedNodes(:,2), amplitudesF(:,1), ...
				amplitudesF(:,2), 0, 'Color', [255 127 0.0]/255, 'LineWidth', 2, 'MaxHeadSize', 1); 				
		case {'Solid144', 'Solid188', 'Truss123'}
			amps = vecnorm(loadingCondToBeShow(:,2:end),2,2);
			lB = 0.2; uB = 1.0; maxAmp = max(amps); minAmp = min(amps);
			if abs(minAmp-maxAmp)/(minAmp+maxAmp)<0.1
				scalingFac = 1;
			else
				if minAmp/maxAmp>lB/uB, lB = minAmp/maxAmp; end
				scalingFac = lB + (uB-lB)*(amps-minAmp)/(maxAmp-minAmp);
			end
			loadingDirVec = loadingCondToBeShow(:,2:4)./amps.*scalingFac;
			coordLoadedNodes = nodeCoords_(loadingCondToBeShow(:,1),:);
			amplitudesF = mean(boundingBox_(2,:)-boundingBox_(1,:))/5 * loadingDirVec;
			hold('on'); quiver3(coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), amplitudesF(:,1), ...
				amplitudesF(:,2), amplitudesF(:,3), 0, 'Color', [255 127 0.0]/255, 'LineWidth', 2, 'MaxHeadSize', 1); 			
		case {'Beam123', 'Shell133', 'Shell144'}
			amps = vecnorm(loadingCondToBeShow(:,2:4),2,2);
			lB = 0.2; uB = 1.0; maxAmp = max(amps); minAmp = min(amps);
			if abs(minAmp-maxAmp)/(minAmp+maxAmp)<0.1
				scalingFac = 1;
			else
				if minAmp/maxAmp>lB/uB, lB = minAmp/maxAmp; end
				scalingFac = lB + (uB-lB)*(amps-minAmp)/(maxAmp-minAmp);
            end
            coordLoadedNodes = nodeCoords_(loadingCondToBeShow(:,1),:);
			if ~(0==min(amps) &&  0==max(amps))
				loadingDirVec = loadingCondToBeShow(:,2:4)./amps.*scalingFac;				
				amplitudesF = mean(boundingBox_(2,:)-boundingBox_(1,:))/5 * loadingDirVec;
				hold('on'); quiver3(coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), amplitudesF(:,1), ...
					amplitudesF(:,2), amplitudesF(:,3), 0, 'Color', [255 127 0.0]/255, 'LineWidth', 2, 'MaxHeadSize', 1); 					
			end
			nodesRx = find(loadingCondToBeShow(:,5));
			nodesRy = find(loadingCondToBeShow(:,6));
			nodesRz = find(loadingCondToBeShow(:,7));
			nodesTorque = unique([nodesRx; nodesRy; nodesRz]);
			if ~isempty(nodesTorque)
				hold('on'); plot3(coordLoadedNodes(nodesTorque,1), coordLoadedNodes(nodesTorque,2), coordLoadedNodes(nodesTorque,3), 'o', ...
                        'Color', [112 48 160]/255, 'LineWidth', 1, 'MarkerSize', 6); 				
			end
	end
end