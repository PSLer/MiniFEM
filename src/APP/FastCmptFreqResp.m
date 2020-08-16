function FastCmptFreqResp(varargin)
	%%Invoking Form
	%%FastCmptFreqResp(arg); arg = iFreq
	%%FastCmptFreqResp(arg1, arg2); arg1 = arg above, arg2 = 'X', 'Y', 'Z', 'T'
	%%FastCmptFreqResp(arg1, arg2, arg3); arg1 = arg1 above, arg2 = arg2 above, arg3 = scalar or 'default'
	%%FastCmptFreqResp(arg1, arg2, arg3, arg4); arg1 = arg above, arg2 = arg2 above, arg3 = arg3 above; arg4 = 'meshWise'
	global Kq_; global Mq_; global Fq_;
	global modalSpace_; global freeDofs_;
	global naturalFreqs_; global iFreq_;
	global U_; U_ = zeros(size(modalSpace_,1),1);
	if isempty(Kq_)
		error('Failed to perform the fast computation since the reduced model is unavailable!');
	end
	if 0==nargin || 4<nargin
		error('Wrong input type for fast computing frequency response!')
	end
	if isscalar(varargin{1})
		if 3*varargin{1}<=max(naturalFreqs_)
			iFreq_ = varargin{1};
			Tq = Kq_ - (2*pi*iFreq_)^2*Mq_;
			y = Tq\Fq_; 
			U_(freeDofs_) = modalSpace_(freeDofs_,:)*y;			
		else
			warning('Inappropriate input frequency for fast computing frequency response!')
		end
	end
	if nargin>1
		Deformation(varargin{2:end});
	end
end