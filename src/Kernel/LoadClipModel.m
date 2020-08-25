function validElements = LoadClipModel(fileName)
	global domainType_;
	global nelx_; global nely_; global nelz_;
	fid = fopen(fileName, 'r');
	fgetl(fid);
	tmp = fscanf(fid, '%s %s', 2);
	DT = fscanf(fid, '%s', 1);
	if ~strcmp(domainType_, DT)
		error('Wrong input valid for currently defined design domain!');		
	end
	tmp = fscanf(fid, '%s', 1);
	switch domainType_
		case '2D'
			tmp = fscanf(fid, '%d %d', 2); tmp = tmp(:)';
			if ~isequal(tmp, [nelx_ nely_])
				error('Wrong input valid for currently defined design domain!');
			end
		case '3D'
			tmp = fscanf(fid, '%d %d %d', 3); tmp = tmp(:)';
			if ~isequal(tmp, [nelx_ nely_ nelz_])
				error('Wrong input valid for currently defined design domain!');
			end
	end
	tmp = fscanf(fid, '%s %s', 2);
	numValidNodes = fscanf(fid, '%d', 1);	
	validElements = fscanf(fid, '%d', [1 numValidNodes])';
	fclose(fid);
end