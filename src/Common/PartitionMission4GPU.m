function [tarA, opt] = PartitionMission4GPU(varargin)
	%varargin{1} src matrix
	%varargin{2} maximum partitions 
	if 1 == nargin 
		maxDivisionsOnGPU = 8; %experienced
	elseif 2==nargin
		maxDivisionsOnGPU = varargin{2}; 
	end
	nn = length(varargin{1});
	[rowIndexK colIndexK valK] = find(varargin{1});
	numNonZeros = length(valK);
	requiredMem4A = numNonZeros*2*4+numNonZeros*8; %%storing row&col indices in int, nonZeros in double
	handleGPU = gpuDevice(1); reset(handleGPU); 
	avaVRAM = handleGPU.AvailableMemory;
	safeFac = 0.8; 
	safeAvaVRAM = safeFac*avaVRAM;
	if requiredMem4A > safeAvaVRAM
		opt = 0; tarA = [];
		warning('Failed to perform computing on GPU due to VRAM limitation! Back to CPU.');
	else
		opt = 1;
		maxSingleBufferOnGPU = round(safeAvaVRAM/maxDivisionsOnGPU);
		subMatGPU = SubMatStruct4GPU();
		numDivisionsOnGPU = 1 + floor(requiredMem4A/maxSingleBufferOnGPU);
		tarA = repmat(subMatGPU,numDivisionsOnGPU,1);
		step = round(numNonZeros/numDivisionsOnGPU);
		for ii=1:1:numDivisionsOnGPU
			if ii==numDivisionsOnGPU
				tmp = sparse(rowIndexK(step*(ii-1)+1:end),colIndexK(step*(ii-1)+1:end),...
					valK(step*(ii-1)+1:end), nn, nn);
			else
				range = step*(ii-1)+1:step*ii;
				tmp = sparse(rowIndexK(range'),colIndexK(range'),valK(range'), nn, nn);
			end
			tarA(ii).mat = gpuArray(tmp);
		end		
	end
end
function val = SubMatStruct4GPU()
	val = struct(				...
		'ith',				0, 	...
		'mat',				ones(1,1,'gpuArray') ...	
	);	
end