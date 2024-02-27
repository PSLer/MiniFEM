function CreateRectangle(resCtrl, varargin)
	%% Syntax: 
	%% CreateRectangle(resCtrl); "resCtrl" includes two positive integers
	%% CreateRectangle(resCtrl, boundingBoxCtrl); "boundingBoxCtrl" is a 2-by-2 array
	global eleType_;
	global nelx_; global nely_;
	global boundingBox_;
	global numEles_;
	if ~(strcmp(eleType_.eleName, 'Plane133') || strcmp(eleType_.eleName, 'Plane144'))
		error('Only Works with 2D Plane133 or Plane144 Element!');
	end
	if 2~=numel(resCtrl), error('Wrong Input for the Resolution Control!'); end
	nelx_ = resCtrl(1); nely_ = resCtrl(2);
	if 2==nargin
		boundingBox_ = varargin{1};
		if ~(2==size(boundingBox_,1) && 2==size(boundingBox_,2))
			error('Wrong Input for the Bounding Box Control!');
		end
	else
		boundingBox_ = [0 0; nelx_ nely_];
	end
	GenerateCartesianMesh2D(ones(nely_, nelx_));
	materialIndicatorField_ = ones(numEles_,1);
	EvaluateMeshQuality();
end