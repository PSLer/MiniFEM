function ExportSysMat(opt)
    global outPath_;	
    switch opt
		case 'K'
			global K_;
			semiK = tril(K_);
			[row col val] = find(semiK);
			dim = length(semiK);
			nNonVals = length(row);
			fid = fopen(strcat(outPath_, '/K.dat'), 'w');
			fprintf(fid, '%d %d %d\n', [dim dim nNonVals]);
			fprintf(fid, '%d %d %e\n', [row col val]');
			fclose(fid);
		case 'M'
			global M_;
			semiM = tril(M_);
			[row col val] = find(semiM);
			dim = length(semiM);
			nNonVals = length(row);
			fid = fopen(strcat(outPath_, '/M.dat'), 'w');
			fprintf(fid, '%d %d %d\n', [dim dim nNonVals]);
			fprintf(fid, '%d %d %e\n', [row col val]');
			fclose(fid);		
	end
end