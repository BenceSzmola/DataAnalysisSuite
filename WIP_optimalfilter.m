function WIP_optimalfilter %(filename,srate,w1,w2,doplot,save,noisech,refch)

%%% bemenetek:
%       filename: vagy fajlnev vagy 0 ha felugro ablakban akarsz valasztani
%       srate: sampling rate Hz-ben
%       w1: also szuro hatar
%       w2: felso szuro hatar
%       doplot: csinaljon-e fig-eket (most hagyd 0-n)
%       save: kimentse e a fig-eket (ezt is 0-n)
%       noisech: a zajt tartalmazo csatorna
%       refch: az eseményt nem tartalmazó csatorna

doplot = 0;
save = 0;
answer = inputdlg({'Filename (0 for browser):','Samplerate:','W1:','W2:','Noise channel:','Reference channel','Window steps size','Min event distance','sd mult'},...
    'Inputs',[1 20],{'0','20000','150','250','0','0','1000','1000','4'});
filename = answer(1);
srate = str2double(answer(2));
w1 = str2double(answer(3));
w2 = str2double(answer(4));
noisech = str2double(answer(5));
refch = str2double(answer(6));
winstepsize = str2double(answer(7));
eventdist = str2double(answer(8));
sdmult = str2double(answer(9));

if strcmp(filename,'0')
    [filename, path] = uigetfile('.rhd','Select the RHD');
    cd(path);
end

fromMES = 0;
if ~ischar(filename)
    if filename == 0
    else
       indataFull = filename;
       fromMES = 1;
       fprintf(1,'Data from MES \n');
    end
else
    %%% Read RHD
    rhd = read_Intan_RHD2000_file(filename);
    indataFull = rhd.ampdata;
    fprintf(1,'Data from console \n');
end
assignin('base','indata',indataFull);
len = size(indataFull,1)-1;
ivec = 1:len;
if refch ~= 0
    ivec([1 refch]) = ivec([refch 1]);
end
dogged = zeros(size(indataFull,2),len);
assignin('base','dog',dogged);
power = zeros(size(indataFull,2),len);

%%% Filters
for i = ivec
    if fromMES == 0
        t_scale = rhd.tdata;
    end
    indata = indataFull(i,:);
    if i ~= noisech && noisech ~= 0
        indata = indata - indataFull(noisech,:);
    end
    %%% Substract mean from lfp 
%     indataMS = indata - mean(indata,2);

    %%% Apply DoG (from BuzsakiLab)
    GFw1       = makegausslpfir( w1, srate, 6 );
    GFw2       = makegausslpfir( w2, srate, 6 );
    lfpLow     = firfilt( indata, GFw2 );      % lowpass filter
    eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
    lfpLow     = lfpLow - eegLo;            % difference of Gaussians
    
    dogged(:,i) = lfpLow;

    %%%% Apply DoG (from BuzsakiLab) with meansubstract
    %GFw1MS       = makegausslpfir( w1, srate, 6 );
    %GFw2MS       = makegausslpfir( w2, srate, 6 );
    %lfpLowMS     = firfilt( indataMS, GFw2MS );      % lowpass filter
    %eegLoMS      = firfilt( lfpLowMS, GFw1MS );   % highpass filter
    %lfpLowMS     = lfpLowMS - eegLoMS;            % difference of Gaussians
    
    %%% Instantaneous power (from BuzsakiLab)
    ripWindow  = pi / mean( [w1 w2] );
    powerWin   = makegausslpfir( 1 / ripWindow, srate, 4 );

    rip        = lfpLow;
    rip        = abs(rip);
    ripPower0  = firfilt( rip, powerWin );
    ripPower0  = max(ripPower0,[],2);
    
    power(:,i) = ripPower0;
    
end

%%% Alapzaj meghatározása
quietiv = zeros(len,2);
for i = ivec
    currpow = power(:,i);
    bigs = find(currpow>2*std(currpow));
    if bigs(1) ~= 1
        bigs = cat(1,1,bigs);
    end
    ivs = diff(bigs);
    [bigmax, indx] = max(ivs);
    quietiv(i,:) = [bigs(indx) bigs(indx)+bigmax];
end
assignin('base','intervals',quietiv);
[~, ind] = max(diff(quietiv,1,2));
quietiv = quietiv(ind,:);
assignin('base','bestinterval',quietiv);

%%%%%%%%%%%%%%
%%% SWR detect
%%%%%%%%%%%%%%
for i = ivec
   
%     winstepsize = 1000;
%     eventdist = 1000;
    currpow = power(:,i);
    assignin('base',['currpow',num2str(i)],currpow);
    quiet = currpow(quietiv(1):quietiv(2));
%     for q = 2:size(quietiv,1)
%         quiet = cat(1,quiet,(currpow(quietiv(q,1):quietiv(q,2))));
%     end
    assignin('base',['quiet',num2str(i)],quiet);
    peaks = zeros(round(length(currpow)/winstepsize),2);
    peaknum = 2;
    ripsd = mean(quiet) + sdmult*std(quiet);
    if i == refch
        ripsd = mean(currpow) + sdmult*std(currpow);
    end
    figure('Name',['Channel',num2str(i)],'NumberTitle','off');
    %theaxe = axes;
    xscala = t_scale(1):(t_scale(2)-t_scale(1)):t_scale(1)+(t_scale(2)-t_scale(1))*(length(indata)-1);
    ax1=subplot(2,1,1);
    plot(xscala,dogged(:,i));
    grid on;
    title('DoG');
    ax2=subplot(2,1,2);
    plot(xscala,currpow); hold on;
    title('Instantaneous power');
    grid on;
    linkaxes([ax1 ax2],'x');
    %plot(xscala,ripPower0); hold on;
    for j = 1:winstepsize:(length(currpow)-winstepsize*2)
        [peak, index] = max(currpow(j:j+(winstepsize*2)));
        index = j+index-1;
        if (peak > ripsd) %&& ((index-peaks(peaknum-1,1)) > 500)
            peaks(peaknum,:) = [index, peak];
        end
        peaks(peaknum,1) = index;
        peaknum = peaknum + 1;
    end
    assignin('base','peaksvol1',peaks);
%     [As,idx] = sort(peaks);
%     peaks = unique(peaks,'first','rows');
%     peaks=peaks(sort(idx(ij)));
    peaks = unique(peaks,'stable','rows');
    nonzind = find(peaks(:,2));
    peaks = peaks(nonzind,:);
    ppeaks = peaks;
    assignin('base','upeaksvol1',ppeaks);
    for k = 2:size(peaks,1)-1
        if (((peaks(k,1) - peaks(k-1,1)) < eventdist) && (peaks(k,2) < peaks(k-1,2))) || ...
                (((peaks(k+1,1) - peaks(k,1)) < eventdist) && (peaks(k,2) < peaks(k+1,2)))
            ppeaks(k,2) = 0;
        end        
    end
    if ((peaks(2,1)-peaks(1,1)) < eventdist) && (peaks(1,2) < peaks(2,2))
        ppeaks(1,2) = 0;
    end
    if ((peaks(end,1)-peaks(end-1,1)) < eventdist) && (peaks(end,2) < peaks(end-1,2))
        ppeaks(end,2) = 0;
    end
    assignin('base','peaksvol2',ppeaks);
    nonzind = find(ppeaks(:,2));
    ppeaks = ppeaks(nonzind,:);
%     assignin('base',['peaks', num2str(i)],ppeaks);
    assignin('base','rips',currpow);
    %%% Hossz alapján kiszûrés
    widths = zeros(size(ppeaks,1),1);
    for ii = 1:size(ppeaks,1)
        iii = ppeaks(ii,1);
        while currpow(iii) > ripsd
            iii = iii - 1;
        end
        lowedge = iii;
        assignin('base','lowedge',lowedge);
        iii = ppeaks(ii,1);
        while currpow(iii) > ripsd
            iii = iii + 1;
        end
        highedge = iii;
        assignin('base','highedge',highedge);
%         line([highedge highedge],get(theaxe,'YLim'),'Color','r');
%         line([lowedge lowedge],get(theaxe,'YLim'),'Color','r');
        widths(ii) = (highedge - lowedge)/20;
        if widths(ii) < 20
            ppeaks(ii,2) = 0;
        end
        assignin('base','widths',widths);
    end
        
%     widths = widths(widths>=20);
%     nonzind = find(ppeaks(:,2));
%     ppeaks = ppeaks(nonzind,:);
   
    %%% refcsatorna peakjei
    if i == refch
        refppeaks = ppeaks;
    end
    %%% refchan-hoz hasonlítás
    if i ~= refch && refch ~= 0
        for jj = 1:size(ppeaks,1)
            for kk = 1:size(refppeaks,1)
                if abs(refppeaks(kk,1)-ppeaks(jj,1))<eventdist
                    ppeaks(jj,2) = 0;
                    continue
                end
            end    
        end
    end
    %%% Átírás idõskálára
    for ii = 1:size(ppeaks,1)
        ppeaks(ii,1) = (ppeaks(ii,1)/20000)+t_scale(1);
    end
    assignin('base',['peaks', num2str(i)],ppeaks);
    plot(ppeaks(:,1),ppeaks(:,2),'o'); hold on;
    line([t_scale(1), (t_scale(2)-t_scale(1))*length(currpow)],[ripsd ripsd],'Color','r'); hold off;
    
    %%% CSV irás
    if i == ivec(1)
        csvname = strcat(filename(1:end-4),'_events.csv');
        fileID = fopen(csvname,'w');
        fprintf(fileID,'%5s ; %12s ; %12s ; %12s \n','Chan','Peak index','Value','Width');
    end
    for ii = 1: size(ppeaks,1)
        fprintf(fileID,'%d ; %5.2f ; %5.2f ; %5.2f \n',i,ppeaks(ii,1),ppeaks(ii,2),widths(ii));
    end
    if i == ivec(end)
        fclose(fileID);
    end    
    %%%%%%%%%%%%%%%%%%
    %%% SWR detect end ----------------------------------------------------
    %%%%%%%%%%%%%%%%%%
    
    %%% Main filter design
    %[b,a] = butter(n, [w1 w2]/(srate/2));
    %
    %%% Apply main filter
    %filtered = filtfilt(b,a,lfpLow);
    doplot = 0;
    if fromMES == 0
        if doplot
            %%% Plots
            xscala = t_scale(1):(t_scale(2)-t_scale(1)):t_scale(1)+(t_scale(2)-t_scale(1))*(length(indata)-1);
            figure('Name',sprintf('%s CH%d DoG %d-%d clip',filename(1:end-4),i,w1,w2));
            subplot(2,1,1);
            plot(xscala,lfpLow);
            grid on;
            title('DoG');
            subplot(2,1,2);
            plot(xscala,ripPower0);
            title('Instantaneous power');
            grid on;
            if save
                savefig(strcat(filename(1:end-4),'_CH',num2str(i),'_PB',num2str(w1),'-',num2str(w2),'DoG','clip','.fig'));
            end
        end
    end
end

%%% Taken from Buzsakilab
function gwin = makegausslpfir( Fc, Fs, s )

nargs = nargin;
if nargs < 1 || isempty( Fc ), Fc = 100; end
if nargs < 2 || isempty( Fs ), Fs = 1000; end
if nargs < 3 || isempty( s ), s = 4; end
s = max( s, 3 );

sd = Fs / ( 2 * pi * Fc ); 
x = -ceil( s * sd ) : ceil( s * sd ); 
gwin = 1/( 2 * pi * sd ) * exp( -( x.^2/2/sd.^2 ) ); 
gwin = gwin / sum( gwin );

return

%%% Taken from BuzsakiLab
function Y = firfilt(x,W)

if all(size(W)>=2), error('window must be a vector'), end
if numel(x)==max(size(x)), x=x(:); end

C = length(W);
if C > size( x, 1 )
    Y = NaN * ones( size( x ) );
    return
end
D = ceil(C/2) - 1;
Y = filter(W,1,[flipud(x(1:C,:)); x; flipud(x(end-C+1:end,:))]);
clear x
Y = Y(1+C+D:end-C+D,:);

return

