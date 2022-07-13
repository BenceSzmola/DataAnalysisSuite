function mb = operationDoneMsg(msg,msgTitle)

mName = mfilename;
DASloc = mfilename('fullpath');
iconFile = [DASloc(1:end-length(mName)), 'iqon\checkMahk.jpg'];

[icondata,iconcmap] = imread(iconFile); 

if (nargin < 1) || isempty(msg)
    msg = 'Operation completed!';
end
if (nargin < 2) || isempty(msgTitle)
    msgTitle = '';
end
mb = msgbox(msg,msgTitle,'custom',icondata,iconcmap);

if nargout == 0
    clear mb
end