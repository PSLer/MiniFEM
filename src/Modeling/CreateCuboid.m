function CreateCuboid(resCtrl, varargin)
	%% Syntax: 
	%% CreateCuboid(resCtrl); "resCtrl" includes three positive integers
	%% CreateCuboid(resCtrl, boundingBoxCtrl); "boundingBoxCtrl" is a 2-by-3 array
	global eleType_;
	global nelx_; global nely_; global nelz_;
	global boundingBox_;
	global numEles_;
	global materialIndicatorField_;
	if ~strcmp(eleType_.eleName, 'Solid188')
		error('Only Works with 3D Solid188 Element!');
	end
	if 3~=numel(resCtrl), error('Wrong Input for the Resolution Control!'); end
	nelx_ = resCtrl(1); nely_ = resCtrl(2); nelz_ = resCtrl(3);
	if 2==nargin
		boundingBox_ = varargin{1};
		if ~(2==size(boundingBox_,1) && 3==size(boundingBox_,2))
			error('Wrong Input for the Bounding Box Control!');
		end
	else
		boundingBox_ = [0 0 0; nelx_ nely_ nelz_];
	end
	GenerateCartesianMesh3D(ones(nely_, nelx_, nelz_));
	materialIndicatorField_ = ones(numEles_,1);
	EvaluateMeshQuality();
end