function [dogged] = DoG(w1,w2) 
%[dogged] = DoG(data,fs,w1,w2)
%(from BuzsakiLab)

fs = 20000;
% if nargin == 0 || isempty(data)
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_szb(filename);
    data = data.amplifier_data;
    cd(oldpath)
% end

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

if nargout == 0
    clear dogged
end