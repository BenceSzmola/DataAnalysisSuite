function removeUIcompFocus(handle)

set(handle, 'Enable', 'off');
drawnow;
set(handle, 'Enable', 'on');

end