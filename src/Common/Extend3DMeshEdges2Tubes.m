function [gridX, gridY, gridZ, gridC] = Extend3DMeshEdges2Tubes(nodeCoords, eNodMat, diameterList, varargin)
	gridX = [];
	gridY = [];
	gridZ = [];
	gridC = [];
	if isempty(eNodMat), meshEdgeTruss = []; return; end
	if 3==nargin
		cList = zeros(size(eNodMat));
	else
		cList = varargin{1};
		cList = cList(eNodMat);
	end
	n = 8;
	numLines = size(eNodMat,1);
	gridXYZ = zeros(3,n+1,1);
	gridC = zeros(n+1,1);
	for ii=1:numLines		
		r = diameterList(ii)/2;
		curve = nodeCoords(eNodMat(ii,:),:)';;
		npoints = size(curve,2);
		%deltavecs: average for internal points. first strecth for endpoitns.		
		dv = curve(:,[2:end,end])-curve(:,[1,1:end-1]);		
		%make nvec not parallel to dv(:,1)
		nvec=zeros(3,1); 
		[~,idx]=min(abs(dv(:,1))); 
		nvec(idx)=1;
		%precalculate cos and sing factors:
		cfact=repmat(cos(linspace(0,2*pi,n+1)),[3,1]);
		sfact=repmat(sin(linspace(0,2*pi,n+1)),[3,1]);
		%Main loop: propagate the normal (nvec) along the tube
		xyz = zeros(3,n+1,npoints+2);
		for k=1:npoints
			convec=cross(nvec,dv(:,k));
			convec=convec./norm(convec);
			nvec=cross(dv(:,k),convec);
			nvec=nvec./norm(nvec);
			%update xyz:
			xyz(:,:,k+1)=repmat(curve(:,k),[1,n+1]) + cfact.*repmat(r*nvec,[1,n+1]) + sfact.*repmat(r*convec,[1,n+1]);
        end
		%finally, cap the ends:
		xyz(:,:,1)=repmat(curve(:,1),[1,n+1]);
		xyz(:,:,end)=repmat(curve(:,end),[1,n+1]);
		gridXYZ(:,:,end+1:end+npoints+2) = xyz;	
		iColor = cList(ii,:);	
		cMap = [iColor(1) iColor iColor(end)];
		cMap = repmat(cMap, n+1, 1);
		gridC(:,end+1:end+npoints+2) = cMap;
	end		
	gridX = squeeze(gridXYZ(1,:,:)); 
	gridX(:,1) = [];
	gridY = squeeze(gridXYZ(2,:,:)); 
	gridY(:,1) = [];
	gridZ = squeeze(gridXYZ(3,:,:)); 
	gridZ(:,1) = [];
	gridC(:,1) = [];
	% meshEdgeTruss.gridX = gridX;
	% meshEdgeTruss.gridY = gridY;
	% meshEdgeTruss.gridZ = gridZ;
	% meshEdgeTruss.gridC = gridC;

	% hd = surf(meshEdgeTruss.gridX, meshEdgeTruss.gridY, meshEdgeTruss.gridZ, meshEdgeTruss.gridC);
	% SceneControl3D(hd, 1.0, 0);
end