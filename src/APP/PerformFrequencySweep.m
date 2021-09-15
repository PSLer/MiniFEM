function PerformFrequencySweep(freqList, varargin)
	global outPath_;
	global F_;
	global K_;
	global M_;
	global U_;
	global loadingCond_;
	global loadedDOFs_;
	
	if isempty(loadingCond_), error('No Loads!'); end
	if isempty(F_), ApplyBoundaryCondition(); end
	if isempty(K_), AssembleStiffnessMatrix(); end
	if isempty(M_), AssembleMassMatrix(); end
	tStart = tic;
	freqList = freqList(:);
	numFreq = length(freqList);

	for ii=1:numFreq
		iFreq = freqList(ii);
		disp([' Freq.: ' sprintf('%12.3f',iFreq) 'Hz | Progress.: ' sprintf('%6i',ii) ' | Total.: ' sprintf('%6i',numFreq)]);		
		if 1==nargin
			U_ = SolvingDynamicLinearSystemEquations(iFreq);
		elseif 2==nargin
			if strcmp(varargin{1}, 'DIRECT') || strcmp(varargin{1}, 'ITERATIVE')
				U_ = SolvingDynamicLinearSystemEquations(iFreq, varargin{1});
			else
				error('Wrong Input!');
			end	
		else
			error('Wrong Input!');
		end
		fileName = sprintf(strcat(outPath_, 'frequencyResponse-step-%d.mat'), ii);
		save(fileName, 'U_');		
	end
	fid = fopen(strcat(outPath_, 'frequencyList.dat'), 'w');
	fprintf(fid, '%16.6e\n', freqList);
	fclose(fid);
	disp(['Perform Frequency Sweep Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
	ShowDeformation('T');
end