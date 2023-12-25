function RunFrameOpti(MaxIt)
	global F_;
	global K_;
	global U_;
	global fixingCond_; 
	global loadingCond_;
	global diameterList_;
	global eleCrossSecAreaList_;
	global eleLengthList_;	
	global nodeCoords_;
	global numEles_;
	global numDOFs_;
	global numNodes_;
	global iniNodeCoords_;
	global iniDiameterList_;
	global iniEleCrossSecAreaList_;
	global iniEleLengthList_;
	global nodeAssociatedEdgeLength_;
	global eNodMat_;
	global objOptiHist_;
	global optiNodeHist_;
	global BestSol_;
	
	if isempty(fixingCond_), error('No Constraint!'); end
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end

	iniNodeCoords_ = nodeCoords_;
	iniDiameterList_ = diameterList_;
	iniEleCrossSecAreaList_ = eleCrossSecAreaList_;
	iniEleLengthList_ = eleLengthList_;
	
	nodeEleStruct = struct('arr', []); nodeEleStruct = repmat(nodeEleStruct, numNodes_, 1);
	nodeAssociatedEdgeLength_ = zeros(numNodes_,1);
	for ii=1:numEles_
		iEleNodes = eNodMat_(ii,:);
		nodeEleStruct(iEleNodes(1)).arr(1,end+1) = ii;
		nodeEleStruct(iEleNodes(2)).arr(1,end+1) = ii;
	end
	for ii=1:numNodes_
		nodeAssociatedEdgeLength_(ii) = min(eleLengthList_(nodeEleStruct(ii).arr));
	end
	
	%%Opti.
	CostFunction = @ComputeObjectiveFunc;
	tStart = tic;
	varRangePosition = [-0.25 0.25];
	[objOptiHist_, designVarOptiHist, BestSol_] = ...
		Optimizer_CMAES(CostFunction, 3*numNodes_, varRangePosition, MaxIt);
	disp(['Running Optimization Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	
	%%Post-process
	optiNodeHist_ = zeros(numNodes_,3,MaxIt+1);
	optiNodeHist_(:,:,1) = iniNodeCoords_;
	for ii=1:MaxIt
		tmpNodeCoord = iniNodeCoords_ + nodeAssociatedEdgeLength_ .* reshape(designVarOptiHist(:,ii), 3, numNodes_)';		
		tmpNodeCoord(fixingCond_(:,1),:) = iniNodeCoords_(fixingCond_(:,1),:);
		tmpNodeCoord(loadingCond_(:,1),:) = iniNodeCoords_(loadingCond_(:,1),:);	
		optiNodeHist_(:,:,ii+1) = tmpNodeCoord;
	end
	[c0, vol0] = ComputeObjectiveFunc(zeros(size(BestSol_.Position)));
	[cOpti, volOpti] = ComputeObjectiveFunc(BestSol_.Position);
	objOptiHist_ = [[c0, vol0]; objOptiHist_];
	disp(['Before Optimization------C: ', sprintf('%.6f', c0), '; V: ', sprintf('%.6f', vol0)]);
	disp(['After Optimization------C: ', sprintf('%.6f', cOpti), '; V: ', sprintf('%.6f', volOpti)]);
	ShowBoundaryCondition(); 
end

function [c, vol] = ComputeObjectiveFunc(updatedNodePositions)
	global iniNodeCoords_;
	global iniDiameterList_;
	global iniEleCrossSecAreaList_;
	global iniEleLengthList_;
	global nodeCoords_;
	global diameterList_;
	global eleCrossSecAreaList_;
	global eleLengthList_;	
	global U_;
	global F_;
	global nodeAssociatedEdgeLength_;
	global fixingCond_; 
	global loadingCond_;
	global numNodes_;
	global eNodMat_;
	global freeDOFs_;
	
	nodeCoords_ = iniNodeCoords_ + nodeAssociatedEdgeLength_ .* reshape(updatedNodePositions, 3, numNodes_)';
	nodeCoords_(fixingCond_(:,1),:) = iniNodeCoords_(fixingCond_(:,1),:);
	nodeCoords_(loadingCond_(:,1),:) = iniNodeCoords_(loadingCond_(:,1),:);
	eleCrossSecAreaList_ = pi/2 * (diameterList_/2).^2;
	eleLengthList_ = vecnorm(nodeCoords_(eNodMat_(:,2),:)-nodeCoords_(eNodMat_(:,1),:),2,2);	
	AssembleStiffnessMatrix();
	U_ = SolvingStaticLinearSystemEquations();
	c = U_(freeDOFs_)' * F_;
	vol = pi/4 * (eleLengthList_(:)' * diameterList_.^2);
end

function [objFuncList, designVarList, BestSol] = Optimizer_CMAES(CostFunction, nVar, VarRange, MaxIt)	
	objFuncList = zeros(MaxIt,2);
	designVarList = zeros(nVar,MaxIt);
	
	VarSize=[1 nVar];       % Decision Variables Matrix Size
	
	% VarMin=-10;             % Lower Bound of Decision Variables
	% VarMax= 10;             % Upper Bound of Decision Variables
	
	%% CMA-ES Settings
	
	% Maximum Number of Iterations
	%MaxIt=300;
	
	% Population Size (and Number of Offsprings)
	lambda=(4+round(3*log(nVar)))*10;
	
	% Number of Parents
	mu=round(lambda/2);
	
	% Parent Weights
	w=log(mu+0.5)-log(1:mu);
	w=w/sum(w);
	
	% Number of Effective Solutions
	mu_eff=1/sum(w.^2);

	% Step Size Control Parameters (c_sigma and d_sigma);
	sigma0=0.3*(VarRange(2)-VarRange(1));
	cs=(mu_eff+2)/(nVar+mu_eff+5);
	ds=1+cs+2*max(sqrt((mu_eff-1)/(nVar+1))-1,0);
	ENN=sqrt(nVar)*(1-1/(4*nVar)+1/(21*nVar^2));
	
	% Covariance Update Parameters
	cc=(4+mu_eff/nVar)/(4+nVar+2*mu_eff/nVar);
	c1=2/((nVar+1.3)^2+mu_eff);
	alpha_mu=2;
	cmu=min(1-c1,alpha_mu*(mu_eff-2+1/mu_eff)/((nVar+2)^2+alpha_mu*mu_eff/2));
	hth=(1.4+2/(nVar+1))*ENN;

	%% Initialization
	
	ps=cell(MaxIt,1);
	pc=cell(MaxIt,1);
	C=cell(MaxIt,1);
	sigma=cell(MaxIt,1);
	
	ps{1}=zeros(VarSize);
	pc{1}=zeros(VarSize);
	C{1}=eye(nVar);
	sigma{1}=sigma0;
	
	empty_individual = struct('Position', [], 'Step', [], 'Cost', [], 'vol', [], 'invalidEdges', []);
	
	M=repmat(empty_individual,MaxIt,1);
	M(1).Position=unifrnd(VarRange(1),VarRange(2),VarSize);
	M(1).Step=zeros(VarSize);
	[objVal, objVolume] = CostFunction(M(1).Position);
	M(1).Cost = objVal;
	M(1).vol = objVolume;
	BestSol=M(1);
	
	%% CMA-ES Main Loop
	for g=1:MaxIt
		if 1==g
			%disp(['Iteration ' num2str(0) ': Best Cost = ' num2str(BestSol.Cost * BestSol.vol)]);
			disp(['Iteration ' sprintf('%d', 0) ': C = ' sprintf('%.6f', BestSol.Cost), '; V = ', ...
				sprintf('%.6f', BestSol.vol), '; M = ', sprintf('%.6f', BestSol.Cost*BestSol.vol)]);
		end
		% Generate Samples
		pop=repmat(empty_individual,lambda,1);
		for ii=1:lambda
			pop(ii).Step=mvnrnd(zeros(VarSize),C{g});
			pop(ii).Position=M(g).Position+sigma{g}*pop(ii).Step;
			pop(ii).Position = max(pop(ii).Position, VarRange(1)); %%regularization
			pop(ii).Position = min(pop(ii).Position, VarRange(2));
			[objVal, objVolume] = CostFunction(pop(ii).Position);
			% if 1==objOpt, pop(ii).Cost = objVal; else, opt = 0; return; end			
			% Update Best Solution Ever Found			
			pop(ii).Cost = objVal;
			pop(ii).vol = objVolume;		
			if pop(ii).Cost<BestSol.Cost
				BestSol=pop(ii);
			end
		end
		
		% Sort Population
		Costs=[pop.Cost];
		[~, SortOrder]=sort(Costs);
		pop=pop(SortOrder);
		
		%Write
		objFuncList(g, 1) = BestSol.Cost;
		objFuncList(g, 2) = BestSol.vol;
		designVarList(:,g) = BestSol.Position;
		
		% Display Results
		% disp(['Iteration ' num2str(g) ': Best Cost = ' num2str(BestSol.Cost*BestSol.vol)]);
			disp(['Iteration ' sprintf('%d', g) ': C = ' sprintf('%.6f', BestSol.Cost), '; V = ', ...
				sprintf('%.6f', BestSol.vol), '; M = ', sprintf('%.6f', BestSol.Cost*BestSol.vol)]);	
		% Exit At Last Iteration
		if g==MaxIt, break; end
			
		% Update Mean
		M(g+1).Step=0;
		for j=1:mu
			M(g+1).Step=M(g+1).Step+w(j)*pop(j).Step;
		end
		M(g+1).Position=M(g).Position+sigma{g}*M(g+1).Step;
		M(g+1).Position = max(M(g+1).Position, VarRange(1)); %%regularization
		M(g+1).Position = min(M(g+1).Position, VarRange(2));		
		[objVal, objVolume] = CostFunction(M(g+1).Position);	
		M(g+1).Cost = objVal;
		M(g+1).vol = objVolume;
		if M(g+1).Cost<BestSol.Cost
			BestSol=M(g+1);				
		end
		
		% Update Step Size
		ps{g+1}=(1-cs)*ps{g}+sqrt(cs*(2-cs)*mu_eff)*M(g+1).Step/chol(C{g})';
		sigma{g+1}=sigma{g}*exp(cs/ds*(norm(ps{g+1})/ENN-1))^0.3;
		
		% Update Covariance Matrix
		if norm(ps{g+1})/sqrt(1-(1-cs)^(2*(g+1)))<hth
			hs=1;
		else
			hs=0;
		end
		delta=(1-hs)*cc*(2-cc);
		pc{g+1}=(1-cc)*pc{g}+hs*sqrt(cc*(2-cc)*mu_eff)*M(g+1).Step;
		C{g+1}=(1-c1-cmu)*C{g}+c1*(pc{g+1}'*pc{g+1}+delta*C{g});
		for j=1:mu
			C{g+1}=C{g+1}+cmu*w(j)*pop(j).Step'*pop(j).Step;
		end
		
		% If Covariance Matrix is not Positive Defenite or Near Singular
		[V, E]=eig(C{g+1});
		if any(diag(E)<0)
			E=max(E,0);
			C{g+1}=V*E/V;
		end
	end
 end