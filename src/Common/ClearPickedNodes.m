function ClearPickedNodes()
	global pickedNodeCache_;
	global hdPickedNode_;
	set(hdPickedNode_, 'visible', 'off');
	hdPickedNode_ = [];
	pickedNodeCache_ = [];	
end