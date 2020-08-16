function FrequencySweep(varargin)
	%%Invoking Form
	%%FrequencySweep(); == BRUTAL FrequencySweep
	%%FrequencySweep(arg); arg = 'MSM', or integer array (BRUTAL, only target nodes get stored)
	%%FrequencySweep(arg1, arg2); arg1 = 'MSM', arg2 = integer array
	global domainType_;
	global freqRange_;
	global freqSweepStep_;
	global iFreq_;
	global freqSweepSamplings_; 
	global solSpace_; solSpace_ = [];
	index = 0;
	for ii=freqRange_(1):freqSweepStep_:freqRange_(2)
		index = index + 1; freqSweepSamplings_(index) = ii;
	end
	
	tic;
	if nargin<=2
		switch nargin
			case 0
				for jj=1:1:length(freqSweepSamplings_)
					disp([sprintf('%d',jj) ' sampling points passed from ' ...
						sprintf('%d',length(freqSweepSamplings_)) ' in total!']);
					iFreq_ = freqSweepSamplings_(jj);
					solSpace_(:,jj) = SolvingDynamicFEM('printP_OFF');
				end				
			case 1				
				if strcmp('MSM', varargin{1})
					global K_; global M_; global F_; x = zeros(size(F_));
					global Kq_; global Mq_; global Fq_;
					global modalSpace_; global freeDofs_; 			
					ModalAnalysis();
					if ~isempty(modalSpace_)
						Kq_ = modalSpace_(freeDofs_,:)'*(K_*modalSpace_(freeDofs_,:));
						Mq_ = modalSpace_(freeDofs_,:)'*(M_*modalSpace_(freeDofs_,:));
						Fq_ = modalSpace_'*F_;
						for jj=1:1:length(freqSweepSamplings_)
							disp([sprintf('%d',jj) ' sampling points passed from ' ...
								sprintf('%d',length(freqSweepSamplings_)) ' in total!']);
							iFreq_ = freqSweepSamplings_(jj);
							Tq = Kq_ - (2*pi*iFreq_)^2*Mq_;
							y = Tq\Fq_; x(freeDofs_) = modalSpace_(freeDofs_,:)*y;
							solSpace_(:,jj) = x;
						end				
					end				
				elseif isnumeric(varargin{1})
					tarNods = varargin{1}; tarNods = double(int32(tarNods(:)));
					switch domainType_
						case '2D'
							tarDOFs = 2*tarNods+(-1:0);
							tarDOFs = reshape(tarDOFs', numel(tarDOFs), 1);
						case '3D'
							tarDOFs = 3*tarNods+(-2:0);
							tarDOFs = reshape(tarDOFs', numel(tarDOFs), 1);						
					end
					for jj=1:1:length(freqSweepSamplings_)
						disp([sprintf('%d',jj) ' sampling points passed from ' ...
							sprintf('%d',length(freqSweepSamplings_)) ' in total!']);
						iFreq_ = freqSweepSamplings_(jj);
						x = SolvingDynamicFEM('printP_OFF');
						solSpace_(:,jj) = x(tarDOFs);
					end						
				else
					error('Wrong input for frequency sweep! Error code: AAA');
				end
			case 2
				if strcmp(varargin{1}, 'MSM') & isnumeric(varargin{2})
					tarNods = varargin{2}; tarNods = double(int32(tarNods(:)));
					switch domainType_
						case '2D'
							tarDOFs = 2*tarNods+(-1:0);
							tarDOFs = reshape(tarDOFs', numel(tarDOFs), 1);
						case '3D'
							tarDOFs = 3*tarNods+(-2:0);
							tarDOFs = reshape(tarDOFs', numel(tarDOFs), 1);						
					end
					global K_; global M_; global F_; x = zeros(size(F_));
					global Kq_; global Mq_; global Fq_;
					global modalSpace_; global freeDofs_; 			
					ModalAnalysis();
					if ~isempty(modalSpace_)
						Kq_ = modalSpace_(freeDofs_,:)'*(K_*modalSpace_(freeDofs_,:));
						Mq_ = modalSpace_(freeDofs_,:)'*(M_*modalSpace_(freeDofs_,:));
						Fq_ = modalSpace_'*F_;
						for jj=1:1:length(freqSweepSamplings_)
							disp([sprintf('%d',jj) ' sampling points passed from ' ...
								sprintf('%d',length(freqSweepSamplings_)) ' in total!']);
							iFreq_ = freqSweepSamplings_(jj);
							Tq = Kq_ - (2*pi*iFreq_)^2*Mq_;
							y = Tq\Fq_; 
							solSpace_(:,jj) = modalSpace_(tarDOFs,:)*y;
						end				
					end	
				else
					error('Wrong input for frequency sweep! Error code: CCC');
				end
		end
	else
		error('Wrong input for frequency sweep! Error code: BBB');
	end
	disp(['Frequency sweep costs: ' sprintf('%10.3g',toc) 's']);	
end