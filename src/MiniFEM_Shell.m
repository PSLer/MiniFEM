clear all; clc;
addpath('./Common');
addpath('./Kernel');
global align2GlobalFrame_;
global eleType_;
global optMine_; optMine_ = 0;
global refVec_;
global Ks_;
%% Mesh
if 0
	nodeCoords_ = [
		0 1 0.0
		0 0 0.0
		1 1 0.1
		1 0 0.1
		2 1 0.2
		2 0 0.2
	];
	% nodeCoords_(:,3) = 0;
	numNodes_ = size(nodeCoords_,1); numDOFs_ = 6*numNodes_;
	eNodMat_ = [
		2 4 1
		3 1 4
		4 6 3
		5 3 6
	];
	
	%% Boundary Conditions
	freeDOFs_ = (13:numDOFs_)'; %% example free DOFs
	F_ = sparse(numDOFs_,1); F_(27) = 1;
	F_ = F_(freeDOFs_);
    t = 0.1;          % thickness [m]
else
	nodeCoords_ = load('nodeCoords_.mat').nodeCoords_;
	numNodes_ = size(nodeCoords_,1); numDOFs_ = 6*numNodes_;
	eNodMat_ = load('eNodMat_.mat').eNodMat_;
	freeDOFs_ = load('freeDOFs_.mat').freeDOFs_;
	F_ = load('F_.mat').F_;
    t = 0.01;          % thickness [m]
end
%% Material / Section (you can replace with your own in your original file)
E = 70e9;         % Young's modulus [Pa]
nu = 0.3;          % Poisson's ratio [-]
rho = 2700;
kappa = 5/6;       % shear correction
freq = 50; % Hz
SetElement('Shell133');
%% Shell Settings
refVec_ = [1 0 0]; %% The Reference Vector to setup the local frame for each element

%% Compute the Global Stiffness Matrix K_ with dimensions numDOFs_-by-numDOFs_ (Mindlin-Reissner Theory)
[K_, M_] = assembleGlobalStiffness_MR(nodeCoords_, eNodMat_, t, E, nu, rho, kappa, refVec_);

%% Solve (example)
U_ = zeros(numDOFs_,1);
U_(freeDOFs_) = K_(freeDOFs_,freeDOFs_)\F_;
disp([min(U_) max(U_)]);
sigmaMem_all = computeMembraneStressAtGPs_MR(nodeCoords_, eNodMat_, U_, E, nu, refVec_);

U2_ = zeros(numDOFs_,1);
U2_(freeDOFs_) = (K_(freeDOFs_,freeDOFs_) - (2*pi*freq)^2*M_(freeDOFs_,freeDOFs_))\F_;
disp([min(U2_) max(U2_)]);


figure;
visObj.vertices = nodeCoords_;
visObj.faces = eNodMat_;
hd = patch(visObj, 'FaceVertexCData', U_(3:6:end,:));
colormap('parula'); colorbar;
set(hd, 'faceColor', 'interp', 'EdgeColor', 'k');
axis('tight', 'equal', 'on');
view(2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local functions (keep your structure: these can be placed where your
% empty functions are in your original codebase)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [K, M] = assembleGlobalStiffness_MR(nodeCoords_, eNodMat_, t, E, nu, rho, kappa, refVec_)
	global align2GlobalFrame_;
	global optMine_;
	numNodes = size(nodeCoords_,1);
	numElems = size(eNodMat_,1);
	ndofs = 6*numNodes;
	align2GlobalFrame_ = zeros(3,3,numElems);
	if optMine_
		tmp = 6*eNodMat_; eDofMat_ = [tmp-5 tmp-4 tmp-3 tmp-2 tmp-1 tmp];
		eDofMat_ = eDofMat_(:,[1 4 7 10 13 16  2 5 8 11 14 17  3 6 9 12 15 18]);
		[eKi, eKj, eKk] = GetLowerEleStiffMatIndices();
		iK = eDofMat_(:,eKi)';
		jK = eDofMat_(:,eKj)';
		sK = zeros(numel(eKk), numElems);
		for e = 1:numElems
			conn = eNodMat_(e,:);
			Xe = nodeCoords_(conn,:);  % 3x3 (XYZ of the triangle nodes)
			[Ke_global, R] = triMindlinReissner_3gp(Xe, t, E, nu, kappa, refVec_);
			align2GlobalFrame_(:,:,e) = R;
			eKs = Ke_global(eKk);
			sK(:,e) = eKs;
		end
		tmpK = sparse(iK, jK, sK, ndofs, ndofs);
		K = tmpK + tmpK' - diag(diag(tmpK));	
	else
		global Ks_;
		Ks_ = zeros(18,18,numElems);
		K = sparse(ndofs, ndofs);
		for e = 1:numElems
			conn = eNodMat_(e,:);
			Xe = nodeCoords_(conn,:);  % 3x3 (XYZ of the triangle nodes)
			[Ke_global, R] = triMindlinReissner_3gp(Xe, t, E, nu, kappa, refVec_);
			align2GlobalFrame_(:,:,e) = R;
			% Local-to-global transformation and assembly is already handled inside
			% triMindlinReissner_3gp -> it returns a GLOBAL Ke (18x18) ready to assemble
			elDofs = zeros(1,18);
			for i = 1:3
				gi = conn(i);
				base = (gi-1)*6;
				elDofs(1, (i-1)*6+(1:6)) = base + (1:6);
			end
			K(elDofs, elDofs) = K(elDofs, elDofs) + Ke_global;
			Ks_(:,:,e) = Ke_global;
		end	
	end
	
	M = sparse(ndofs, ndofs);
	for e = 1:numElems
		conn = eNodMat_(e,:);
		Xe = nodeCoords_(conn,:);  % 3x3 (XYZ of the triangle nodes)
		%[Ke_global, R] = triMindlinReissner_3gp(Xe, t, E, nu, kappa, refVec_);
		Me_global = triMindlinReissnerMass_3gp(Xe, t, rho, refVec_);
		% Local-to-global transformation and assembly is already handled inside
		% triMindlinReissner_3gp -> it returns a GLOBAL Ke (18x18) ready to assemble
		elDofs = zeros(1,18);
		for i = 1:3
			gi = conn(i);
			base = (gi-1)*6;
			elDofs(1, (i-1)*6+(1:6)) = base + (1:6);
		end
		M(elDofs, elDofs) = M(elDofs, elDofs) + Me_global;
	end		
end

function [Ke_global, R] = triMindlinReissner_3gp(Xe, t, E, nu, kappa, refVec_)
	global optMine_;
	% Xe: 3x3 global coordinates of the triangle nodes
	% DOF ordering per node: [u v w rx ry rz] (global axes)
	% Build element local frame
	if optMine_
		[R, origin, t1, t2] = ComputeLocalFrameAtGivenPosition([0 0], Xe);
	else
		x1 = Xe(1,:).'; x2 = Xe(2,:).'; x3 = Xe(3,:).';
		v12 = x2 - x1; v13 = x3 - x1;
		e3 = cross(v12, v13); nrm = norm(e3);
		if nrm < eps, error('Degenerate triangle.'); end
		e3 = e3 / nrm;
		r0 = refVec_(:); r0 = r0 / max(norm(r0), eps);
		t0 = r0 - (r0.'*e3)*e3; % project to the plane
		if norm(t0) < 1e-12
			t0 = v12;
		end
		e1 = t0 / norm(t0);
		e2 = cross(e3, e1); e2 = e2 / norm(e2);
		R = [e1(:), e2(:), e3(:)]; % columns are local basis in global coords	
	end
	Tnode = blkdiag(R, R);     % 6x6 per node
	T = blkdiag(Tnode, Tnode, Tnode); % 18x18
	
	% Transform global node coords to LOCAL (for in-plane x,y)
	if optMine_
		XeL = GlobalFrame2Local_Coords(Xe, R, origin, 1);
		dN_dxi = DeShapeFunction([0 0])';
	else
		x1l = [0;0;0];
		x2l = R.'*(x2 - x1);
		x3l = R.'*(x3 - x1);
		XeL = [x1l.'; x2l.'; x3l.']; % local coords (origin at node 1)
		% Natural coordinates of linear triangle nodes:
		% (xi,eta): node1=(0,0), node2=(1,0), node3=(0,1)
		dN_dxi = [-1 -1; 1 0; 0 1]; % each row: [dNi/dxi, dNi/deta]		
	end

	
	% Mapping from (xi,eta) -> (x,y) is affine: x = sum Ni * xi_local
	x_local = XeL(:,1); y_local = XeL(:,2);
	J = [x_local'; y_local'] * dN_dxi; % 2x2, [dx/dxi dx/deta; dy/dxi dy/deta]
	detJ = det(J);
	if detJ <= 0, error('Nonpositive Jacobian.'); end
	invJT = inv(J).';
	
	% Derivatives of shape functions w.r.t physical x,y (constant over element)
	dN_dxdy = dN_dxi * inv(J); % 3x2: [dNi/dx, dNi/dy]
	dNdx = dN_dxdy(:,1); dNdy = dN_dxdy(:,2);
	
	% Element area
	A = 0.5 * detJ;
	
	if optMine_
		[Dm, Db, Ds] = HookeLaw_SHELL(E, nu, t);
	else
		% Constitutive matrices
		Dm = E/(1-nu^2) * [ 1,  nu,     0;
							nu, 1,      0;
							0,  0, (1-nu)/2 ];
		Db = E*t^3/(12*(1-nu^2)) * [ 1,  nu,     0;
									nu, 1,      0;
									0,  0, (1-nu)/2 ];
		Gs = E/(2*(1+nu));
		Ds = kappa * Gs * t * eye(2);
	end
	
	% Build B-matrices (membrane and bending are constant)
	Bm = zeros(3,18);
	Bb = zeros(3,18);
	for a = 1:3
		ia = (a-1)*6;
		% membrane (u,v)
		Bm(:, ia+(1:6)) = [ dNdx(a),      0,        0,    0,       0, 0;
							0,       dNdy(a),       0,    0,       0, 0;
							dNdy(a), dNdx(a),       0,    0,       0, 0];
		% bending curvatures (rx, ry)
		Bb(:, ia+(1:6)) = [ 0, 0, 0, dNdx(a),       0, 0;
							0, 0, 0,      0,   dNdy(a), 0;
							0, 0, 0, dNdy(a),  dNdx(a), 0];
	end
	
	% Shear B depends on N at GP: use 3-point quadrature
	gp = [1/6, 1/6;
		2/3, 1/6;
		1/6, 2/3];
	w = [1/3, 1/3, 1/3]; % weights sum to 1
	K_shear_local = zeros(18);
	for ig = 1:3
		xi = gp(ig,1); eta = gp(ig,2);
		N = [1 - xi - eta; xi; eta];
		Bs = zeros(2,18);
		for a = 1:3
			ia = (a-1)*6;
			Bs(:, ia+(1:6)) = [ 0, 0, dNdx(a),     N(a),      0, 0;
								0, 0, dNdy(a),        0,   N(a), 0];
		end
		K_shear_local = K_shear_local + (Bs.' * Ds * Bs) * (A * w(ig));
	end
	
	K_mem_local = (Bm.' * Dm * Bm) * (t * A);
	K_ben_local = (Bb.' * Db * Bb) * A;
	
	% Drilling rotation small penalty to stabilize (rz DOF)
	alpha = 1e-3;  kdr = alpha * E * t * A;
	K_drill_local = zeros(18);
	for a = 1:3
		ia = (a-1)*6;
		K_drill_local(ia+6, ia+6) = K_drill_local(ia+6, ia+6) + kdr/3;
	end
	
	Ke_local = K_mem_local + K_ben_local + K_shear_local + K_drill_local;
	
	% Transform to GLOBAL DOFs
	Ke_global = T * Ke_local * T';
end

function [eKi, eKj, eKk] = GetLowerEleStiffMatIndices()
	global eleType_;
	dimK = eleType_.nEleNodes*eleType_.nEleNodeDOFs;
	rowMat = (1:dimK)'; rowMat = repmat(rowMat, 1, dimK);
	colMat = (1:dimK); colMat = repmat(colMat, dimK, 1);
	valMat = (1:dimK^2)'; valMat = reshape(valMat, dimK, dimK);
	eKi = tril(rowMat); [~, ~, eKi] = find(eKi);
	eKj = tril(colMat); [~, ~, eKj] = find(eKj);
	eKk = tril(valMat); [~, ~, eKk] = find(eKk);
end

function [HLm, HLb, HLs] = HookeLaw_SHELL(E, nu, t)
	% Plane stress stiffness matrix
	%% Membrane
	HLm = E/(1-nu^2)*[
			1	nu	0
			nu	1	0
			0	0	(1 - nu)/2
	];
	%% Bending
	%% t: Shell Thickness
	HLb = E*t^3/(12*(1-nu^2))*[
		1	nu	0
		nu	1	0
		0	0	(1 - nu)/2
	];
	%% Shear
	kappa = 5/6;
	Gs = E/(2*(1+nu));
	% HLs = kappa*E/(2*(1+nu))*eye(2);
	HLs = kappa * Gs * t * eye(2);
end

function Me_global = triMindlinReissnerMass_3gp(Xe, t, rho, refVec_)
	% Consistent element mass matrix for a 3-node Mindlin–Reissner triangular shell.
	% DOFs per node: [u v w rx ry rz] in GLOBAL axes.
	% Inputs:
	%   Xe      : 3x3 node coordinates of the element in GLOBAL frame (rows: nodes, cols: X,Y,Z)
	%   t       : thickness
	%   rho     : mass density
	%   refVec_ : 1x3 reference vector to define in-plane e1 direction
	% Output:
	%   Me_global : 18x18 element mass matrix in GLOBAL DOFs
	%
	% Uses 3-point triangle quadrature (exact for N_i N_j products).
	% Translational inertia:  rho * t
	% Rotational inertia:     rho * I,  I = t^3/12  (about e1,e2); no inertia for r_z.
	
	% ---- Build element local frame (same as stiffness routine) ----
	x1 = Xe(1,:).'; x2 = Xe(2,:).'; x3 = Xe(3,:).';
	v12 = x2 - x1; v13 = x3 - x1;
	e3 = cross(v12, v13); nrm = norm(e3);
	if nrm < eps, error('Degenerate triangle in mass matrix.'); end
	e3 = e3 / nrm;
	r0 = refVec_(:); r0 = r0 / max(norm(r0), eps);
	t0 = r0 - (r0.'*e3)*e3;     % project refVec onto the element plane
	if norm(t0) < 1e-12, t0 = v12; end
	e1 = t0 / norm(t0);
	e2 = cross(e3, e1); e2 = e2 / norm(e2);
	
	R = [e1(:), e2(:), e3(:)];        % local basis in global coords
	Tnode = blkdiag(R, R);            % 6x6 (trans+rot) per node
	T = blkdiag(Tnode, Tnode, Tnode); % 18x18, local->global mapping
	
	% ---- Local coordinates for area & quadrature weights ----
	x1l = [0;0;0];
	x2l = R.'*(x2 - x1);
	x3l = R.'*(x3 - x1);
	XeL = [x1l.'; x2l.'; x3l.'];     % rows: nodes, cols: local x,y,z
	
	% Jacobian for natural -> physical mapping (affine triangle)
	dN_dxi = [-1 -1; 1 0; 0 1];
	x_local = XeL(:,1); y_local = XeL(:,2);
	J = [x_local.'; y_local.'] * dN_dxi;  % 2x2
	detJ = det(J);
	if detJ <= 0, error('Nonpositive Jacobian in mass matrix.'); end
	A = 0.5 * detJ;                  % physical area
	
	% ---- Triangle 3-point quadrature (barycentric) ----
	gp = [1/6, 1/6;
		2/3, 1/6;
		1/6, 2/3];
	w = [1/3, 1/3, 1/3];             % weights sum to 1; physical weight is A*w(i)
	
	% ---- Inertias ----
	mT = rho * t;           % translational mass per unit area
	IR = rho * (t^3/12);    % rotary inertia per unit area (about e1,e2)
	
	% ---- Assemble local (element) mass matrix in the LOCAL frame ----
	Me_local = zeros(18);
	
	for ig = 1:3
		xi  = gp(ig,1); eta = gp(ig,2);
		N = [1 - xi - eta; xi; eta];   % shape functions at GP
	
		% N matrix for translations: maps [u v w] per node
		Ntr = zeros(3,18);   % rows: u,v,w; cols: 18 element DOFs
		for a = 1:3
			ia = (a-1)*6;
			Na = N(a);
			Ntr(:, ia+(1:6)) = [ Na, 0,  0,  0, 0, 0;
								0,  Na, 0,  0, 0, 0;
								0,  0,  Na, 0, 0, 0 ];
		end
	
		% N matrix for rotations: maps [rx ry] per node (no inertia for rz)
		Nro = zeros(2,18);   % rows: rx, ry
		for a = 1:3
			ia = (a-1)*6;
			Na = N(a);
			Nro(:, ia+(1:6)) = [ 0, 0, 0, Na, 0, 0;
								0, 0, 0, 0, Na, 0 ];
		end
	
		dA = A * w(ig);
		Me_local = Me_local + (mT * (Ntr.' * Ntr) + IR * (Nro.' * Nro)) * dA;
	end
	
	% ---- Map to GLOBAL DOFs ----
	Me_global = T * Me_local * T.';   % since u_g = T u_l
	
end

function sigmaMem_all = computeMembraneStressAtGPs_MR(nodeCoords_, eNodMat_, U_, E, nu, refVec_)
	% Compute membrane (in-plane) stress at 3 Gaussian points per triangular shell element
	% Output:
	%   sigmaMem_all: 2x2x3xNe  (2x2 stress tensor in local coords, 3 GPs, for each element)
	%
	% DOF ordering per node (global): [u v w rx ry rz]
	% Convention: u_g = T * u_l  =>  u_l = T.' * u_g
	
	numElems = size(eNodMat_,1);
	sigmaMem_all = zeros(2,2,3,numElems);
	
	% Linear triangle derivatives in natural (xi,eta)
	dN_dxi = [-1 -1; 1 0; 0 1];
	
	% 3-point triangle quadrature (barycentric)
	gp = [1/6, 1/6;
		2/3, 1/6;
		1/6, 2/3];
	
	% Membrane constitutive (plane stress)
	Dm = E/(1-nu^2) * [ 1,  nu,     0;
						nu, 1,      0;
						0,  0, (1-nu)/2 ];
	
	for e = 1:numElems
		conn = eNodMat_(e,:);
		Xe = nodeCoords_(conn,:);  % 3x3 global coordinates
	
		% ----- Build local frame (same as in your element routine) -----
		x1 = Xe(1,:).'; x2 = Xe(2,:).'; x3 = Xe(3,:).';
		v12 = x2 - x1; v13 = x3 - x1;
		e3 = cross(v12, v13); nrm = norm(e3);
		if nrm < eps, error('Degenerate triangle in element %d.', e); end
		e3 = e3 / nrm;
		r0 = refVec_(:); r0 = r0 / max(norm(r0), eps);
		t0 = r0 - (r0.'*e3)*e3;  % project to plane
		if norm(t0) < 1e-12, t0 = v12; end
		e1 = t0 / norm(t0);
		e2 = cross(e3, e1); e2 = e2 / norm(e2);
	
		R = [e1(:), e2(:), e3(:)];     % 3x3
		Tnode = blkdiag(R, R);         % 6x6
		T = blkdiag(Tnode, Tnode, Tnode); % 18x18
	
		% ----- Local coordinates (for Jacobian) -----
		x1l = [0;0;0];
		x2l = R.'*(x2 - x1);
		x3l = R.'*(x3 - x1);
		XeL = [x1l.'; x2l.'; x3l.'];   % 3x3, local coords
	
		x_local = XeL(:,1); y_local = XeL(:,2);
		J = [x_local.'; y_local.'] * dN_dxi;  % 2x2
		detJ = det(J);
		if detJ <= 0, error('Nonpositive Jacobian in element %d.', e); end
	
		% Shape function derivatives w.r.t. physical x,y (constant over element)
		dN_dxdy = dN_dxi * inv(J); % 3x2
		dNdx = dN_dxdy(:,1); dNdy = dN_dxdy(:,2);
	
		% ----- Membrane B-matrix (local) -----
		Bm = zeros(3,18);
		for a = 1:3
			ia = (a-1)*6;
			Bm(:, ia+(1:6)) = [ dNdx(a),     0, 0, 0, 0, 0;
								0,       dNdy(a), 0, 0, 0, 0;
								dNdy(a), dNdx(a), 0, 0, 0, 0];
		end
	
		% ----- Local element displacement vector -----
		elDofs = zeros(1,18);
		for i = 1:3
			base = (conn(i)-1)*6;
			elDofs((i-1)*6+(1:6)) = base + (1:6);
		end
		ue_g = U_(elDofs);       % 18x1, global
		ue_l = T.' * ue_g;       % 18x1, local
	
		% ----- Membrane strain/stress (constant over element) -----
		eps_m = Bm * ue_l;           % 3x1 (Voigt: [ex, ey, gxy])
		sig_v = Dm * eps_m;          % 3x1
		sig_mat = [sig_v(1) sig_v(3);
				sig_v(3) sig_v(2)]; % 2x2 tensor in local (e1,e2)
	
		% ----- Store at all 3 Gauss points (identical for CST membrane) -----
		for ig = 1:3
			sigmaMem_all(:,:,ig,e) = sig_mat;
		end
	end
end
