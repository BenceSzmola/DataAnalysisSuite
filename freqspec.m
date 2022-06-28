function [faxis,psd] = freqspec(data,Fs,plots,fmin,fmax,titleXtra)
% from matlab help
% [faxis,psd] = freqspec(data,Fs,plots,fmin,fmax)

if nargin == 0 || isempty(data)
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_szb(filename);
    data = data.amplifier_data;
    cd(oldpath)
end

if nargin < 2
    Fs = 20000;
    fprintf(1,'Using default sampling frequency (20 kHz)\n')
end

if nargin < 5
    fmin = 0;
    fmax = 500;
end

if nargin < 3
    plots = 1;
end

if nargin < 6
    titleXtra = '';
% else
%     titleXtra = [' - ',titleXtra];
end

L = max(size(data));
numchan = min(size(data));
if size(data,1) > size(data,2)
    data = data';
end

if nargout ~= 0
    faxis = [];
    psd = [];
end

for i = 1:numchan
    Y = fft(data(i,:));

    P2 = abs(Y/L);
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:floor(L/2))/L;
    inds2use = (round(f) > fmin) & (round(f) < fmax);
    f = f(inds2use);
    P1 = P1(inds2use);
    if plots
        figure
        plot(f,P1)
        if strcmp(titleXtra,'')
            title(['FFT spectrum channel #',num2str(i),titleXtra])
        else
            title(['FFT spectrum - ',titleXtra])
        end
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
    end
    
    if nargout ~= 0
        faxis = [faxis; f];
        psd = [psd; P1];
    end
end