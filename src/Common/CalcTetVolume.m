function vols = CalcTetVolume(vertices)
	numTets = size(vertices,3);
	vols = zeros(numTets,1);
	for ii=1:numTets
		iVertex = vertices(:,:,ii);
		A = [iVertex(2,:)-iVertex(1,:); iVertex(3,:)-iVertex(1,:); iVertex(4,:)-iVertex(1,:)];
		vols(ii) = det(A)/6;
	end
end