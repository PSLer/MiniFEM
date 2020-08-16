function RemoveGlyphs(userHandle)
	userHandle = reshape(userHandle, size(userHandle,1)*size(userHandle,2)*size(userHandle,3), 1);
	for ii=1:1:length(userHandle)
		set(userHandle(ii),'visible','off');
	end
end