function [dogged] = DoG(data,fs,w1,w2) 
%% (from BuzsakiLab)

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