function VisualizeModalMode(varargin)
	%%Invoking Form
	%%VisualizeModalMode(arg); arg = 1, 2, ...
	%%VisualizeModalMode(arg1, arg2); arg1 = arg above, arg2 = scalar or 'meshWise'	
	%%VisualizeModalMode(arg1, arg2, arg3); arg1 = arg above, arg2 = scalar; arg3 = 'meshWise'
	global modalSpace_;
	global naturalFreqs_;
	global U_;
	global domainType_; global numNodes_;
	
	if 0==numel(naturalFreqs_), error('There is no modal results available!'); return; end
	if nargin<=4	
		switch nargin
			case 1
				if isscalar(varargin{1}) & varargin{1}<=size(modalSpace_,2)
					U_ = modalSpace_(:,varargin{1});
					Deformation('T');					
				else					
					error('Wrong input for visualizing modal mode!');
				end
			case 2
				if isscalar(varargin{1}) & varargin{1}<=size(modalSpace_,2)
					U_ = modalSpace_(:,varargin{1});
					if ~isscalar(varargin{2}) & ~strcmp(varargin{2}, 'meshWise')
						error('Wrong input for visualizing modal mode!');
					else	
						Deformation('T', varargin{2});
					end
				else					
					error('Wrong input for visualizing modal mode!');
				end
			case 3
				if isscalar(varargin{1}) & varargin{1}<=size(modalSpace_,2)					
					U_ = modalSpace_(:,varargin{1});
					if isscalar(varargin{2}) & strcmp(varargin{3}, 'meshWise')
						Deformation('T', varargin{2}, varargin{3});
					else	
						error('Wrong input for visualizing modal mode!');
					end					
				else
					error('Wrong input for visualizing modal mode!');			
				end			
		end
	else
		error('Wrong input for visualizing modal mode!')
	end
end