function dogged = DoG(varargin)
%Possible ways to call the function (output always optional):
%output = DoG(w1,w2)
%output = DoG(fs,w1,w2)
%output = DoG(data,fs,w1,w2)

%(from BuzsakiLab)

if nargin < 2
    errordlg('Not enough input arguments! (check: help DoG)')
elseif nargin == 2
    w1 = varargin{1};
    w2 = varargin{2};
    fs = 20000;
    fprintf(1,'Using 20000 Hz sampling frequency')
elseif nargin == 3
    fs = varargin{1};
    w1 = varargin{2};
    w2 = varargin{3};
elseif nargin == 4
    data = varargin{1};
    % rounding because data coming from GUI might not be converted proper
    fs = round(varargin{2},4);
    w1 = round(varargin{3},4);
    w2 = round(varargin{4},4);
end

if nargin < 4 || isempty(varargin{1})
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_szb(filename);
    data = data.amplifier_data;
    cd(oldpath)
end

if size(data,1) > size(data,2)
    data = data';
end

numchans = min(size(data));
dogged = zeros(size(data));
for i = 1:numchans
    GFw1       = makegausslpfir( w1, fs, 6 );
    GFw2       = makegausslpfir( w2, fs, 6 );
    lfpLow     = firfilt( data(i,:), GFw2 );      % lowpass filter
    eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
    lfpLow     = lfpLow - eegLo;            % difference of Gaussians

    dogged(i,:) = lfpLow;
end

if nargin < 4
    t = linspace(0,length(data)/fs,length(data));
    figure('Name','DoG result')
    j = 1;
    for i = 1:size(data,1)
        sp1 = subplot(size(data,1),2,j);
        j = j+1;
        plot(t,data(i,:))
        title(['Raw LFP - ch#',num2str(i)])
        xlabel('Time [s]')
        ylabel('Voltage [\muV]')
        axis tight
        sp2 = subplot(size(data,1),2,j);
        plot(t,dogged(i,:))
        title(['DoG filtered LFP - ch#',num2str(i)])
        xlabel('Time [s]')
        ylabel('Voltage [\muV]')
        axis tight
        linkaxes([sp1,sp2],'x')
        j = j+1;
    end
end
    
if nargout == 0
    clear dogged
end