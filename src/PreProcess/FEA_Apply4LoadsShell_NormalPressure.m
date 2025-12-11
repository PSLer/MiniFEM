function iLoadingVec = FEA_Apply4LoadsShell_NormalPressure()
	global loadingCond_;
	global pickedNodeCache_;
	global nodeNormals_;
	if isempty(pickedNodeCache_), iLoadingVec = []; warning('There is no node selected!'); return; end
	ComputeNodeNormalsOfEntireShellMesh();
	pickedNodeCache_ = unique(pickedNodeCache_);
	numTarNodes = length(pickedNodeCache_);
	iLoadingVec = [double(pickedNodeCache_) nodeNormals_(pickedNodeCache_,:) zeros(numTarNodes,3)];
	loadingCond_(end+1:end+numTarNodes,:) = iLoadingVec;
end

function ComputeNodeNormalsOfEntireShellMesh()
	global simMesh_;
	global nodeNormals_;
	
	nodeNormals_ = zeros(simMesh_.numNodes,3);
	switch simMesh_.meshType
		case 'TRI'
			paras = [1/3 1/3];
			for ii=1:simMesh_.numElements
				iEleNodes = simMesh_.eNodMat(ii,1:3);
				iEleNodeCoords = simMesh_.nodeCoords(iEleNodes,:);
				[iEleNormals, ~, ~] = ComputeNormalsAtGivenPosition_Tmp(paras, iEleNodeCoords, 'T3');
				nodeNormals_(iEleNodes,:) = nodeNormals_(iEleNodes,:) + repmat(iEleNormals,3,1);
			end
		case 'QUAD'
			paras = [-1 -1; 1 -1; 1 1; -1 1];
			for ii=1:simMesh_.numElements
				iEleNodes = simMesh_.eNodMat(ii,1:4);
				iEleNodeCoords = simMesh_.nodeCoords(iEleNodes,:);
				[iEleNormals, ~, ~] = ComputeNormalsAtGivenPosition_Tmp(paras, iEleNodeCoords, 'Q4');
				nodeNormals_(iEleNodes,:) = nodeNormals_(iEleNodes,:) + iEleNormals;
			end			
	end
	nodeNormals_ = nodeNormals_ ./ vecnorm(nodeNormals_,2,2);
end

function [faceNormList, tVec1, tVec2] = ComputeNormalsAtGivenPosition_Tmp(paras, iEleNodes, elementType)
	[dNdxi, dNdeta] = DeShapeFunction_Tmp(paras, elementType);
	%%Tangent Planes at "paras"
	tVec1 = dNdxi * iEleNodes;
	tVec2 = dNdeta * iEleNodes;
	nVec = cross(tVec1, tVec2);
	nVec = nVec ./ vecnorm(nVec,2,2);
	faceNormList = nVec;
end

function [dNds, dNdt] = DeShapeFunction_Tmp(paras, elementType)
	numSamps = size(paras,1);
	s = paras(:,1);
	t = paras(:,2);	
	
	switch elementType
		case 'T3'
			dNds = zeros(numSamps,3); 
			dNdt = zeros(numSamps,3);
			
			dNds(:,1) = -ones(numSamps,1); 
			dNdt(:,1) = -ones(numSamps,1);
			dNds(:,2) = ones(numSamps,1);
			dNdt(:,2) = zeros(numSamps,1);
			dNds(:,3) = zeros(numSamps,1);
			dNdt(:,3) = ones(numSamps,1);			
		case 'T6'
			dNds = zeros(numSamps,6);
			dNdt = zeros(numSamps,6);
			
			dNds(:,1) = 4*s + 4*t - 3;
			dNdt(:,1) = 4*s + 4*t - 3;
			dNds(:,2) = 4*s - 1;
			dNdt(:,2) = zeros(numSamps,1);					
			dNds(:,3) = zeros(numSamps,1);
			dNdt(:,3) = 4*t - 1;						
			dNds(:,4) = 4 - 4*t - 8*s;
			dNdt(:,4) = -4*s;						
			dNds(:,5) = 4*t;
			dNdt(:,5) = 4*s;	
			dNds(:,6) = -4*t;
			dNdt(:,6) = 4 - 8*t - 4*s;			
		case 'Q4'
			dNds = zeros(numSamps,4);
			dNdt = zeros(numSamps,4);	

			dNds(:,1) = -0.25*(1-t);
			dNdt(:,1) = -0.25*(1-s);
			dNds(:,2) = 0.25*(1-t);
			dNdt(:,2) = -0.25*(1+s);					
			dNds(:,3) = 0.25*(1+t);
			dNdt(:,3) = 0.25*(1+s);						
			dNds(:,4) = -0.25*(1+t);
			dNdt(:,4) = 0.25*(1-s);			
		case 'Q8'
			dNds = zeros(numSamps,8);
			dNdt = zeros(numSamps,8);					

			dNds(:,1) = -(s/4 - 1/4).*(t - 1) - ((t - 1).*(s + t + 1))/4;
			dNdt(:,1) = -(s/4 - 1/4).*(t - 1) - (s/4 - 1/4).*(s + t + 1);	
			dNds(:,2) = ((t - 1).*(t - s + 1))/4 - (s/4 + 1/4).*(t - 1);
			dNdt(:,2) = (s/4 + 1/4).*(t - s + 1) + (s/4 + 1/4).*(t - 1);	
			dNds(:,3) = (s/4 + 1/4).*(t + 1) + ((t + 1).*(s + t - 1))/4;
			dNdt(:,3) = (s/4 + 1/4).*(t + 1) + (s/4 + 1/4).*(s + t - 1);	
			dNds(:,4) = (s/4 - 1/4).*(t + 1) + ((t + 1).*(s - t + 1))/4;
			dNdt(:,4) = (s/4 - 1/4).*(s - t + 1) - (s/4 - 1/4).*(t + 1);	
			dNds(:,5) = s.*(t - 1);
			dNdt(:,5) = s.^2 /2 - 1/2;	
			dNds(:,6) = 1/2 - t.^2 /2;
			dNdt(:,6) = -2*t.*(s/2 + 1/2);	
			dNds(:,7) = -s.*(t + 1);
			dNdt(:,7) = 1/2 - s.^2 /2;	
			dNds(:,8) = t.^2 /2 - 1/2;
			dNdt(:,8) = 2*t.*(s/2 - 1/2);		
		otherwise
			error('Un-supported Element Type!');
	end
end