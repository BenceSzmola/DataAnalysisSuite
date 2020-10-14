function freqspec(data,Fs,fmin,fmax)
% from matlab help

if nargin < 2
    Fs = 20000;
    fprintf(1,'Using default sampling frequency (20 kHz)\n')
end

if nargin < 4
    fmin = 0;
    fmax = 500;
end

L = max(size(data));
numchan = min(size(data));
if size(data,1) > size(data,2)
    data = data';
end

for i = 1:numchan
    Y = fft(data(i,:));

    P2 = abs(Y/L);
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:floor(L/2))/L;
    figure
    plot(f,P1) 
    title(['FFT spectrum channel #',num2str(i)])
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    xlim([fmin fmax])
end