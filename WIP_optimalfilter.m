function WIP_optimalfilter %(filename,srate,w1,w2,doplot,save,noisech,refch)

% bemenetek:
%       filename: vagy fajlnev vagy 0 ha felugro ablakban akarsz valasztani
%       srate: sampling rate Hz-ben
%       w1: also szuro hatar
%       w2: felso szuro hatar
%       doplot: csinaljon-e fig-eket (most hagyd 0-n)
%       save: kimentse e a fig-eket (ezt is 0-n)
%       noisech: a zajt tartalmazo csatorna
%       refch: az eseményt nem tartalmazó csatorna
%       window step size: peakkeresés ablakának lépése
%       Min event distance
%       sd mult: threshold meghatározásához hányszoros sd-t használjon
%       qsd mult: csendes szakaszokat hányszoros sd alapján határozza meg
%       sec : hány sec-es csendesszakasz alapján számoljon
%       Event length lower bound
%       Event length upper bound

answer = inputdlg({'Filename (0 for browser):','Samplerate: (Hz)','W1: (Hz)','W2: (Hz)','Noise channel:','Reference channel','Window steps size (ms)','Min event distance (ms)','sd mult','quiet sd mult','quietinterval lenght (s)','Event length lower bound (ms)','Event length upper bound (ms)'},...
    'Inputs',[1 20],{'0','20000','150','250','0','0','50','50','2','2','1','10','inf'});
filename = answer(1);
srate = str2double(answer(2));
w1 = str2double(answer(3));
w2 = str2double(answer(4));
noisech = str2double(answer(5));
refch = str2double(answer(6));
winstepsize = str2double(answer(7))*20;
eventdist = str2double(answer(8))*20;
sdmult = str2double(answer(9));
qsdmult = str2double(answer(10));
sec = str2double(answer(11));
widthlower = str2double(answer(12));
widthupper = str2double(answer(13));
 
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
noref = 1:len;
if refch ~= 0
    ivec([1 refch]) = ivec([refch 1]);
    noref(noref==refch) = [];
end
assignin('base','noref',noref);
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
% quietiv = zeros(len,2);
piccolo = zeros(size(indataFull,2),len);
for i = ivec
    if i == refch
        continue
    end
    currpow = power(:,i);
%     bigs = find(currpow>(mean(currpow)+2*std(currpow)));
%     if bigs(1) ~= 1
%         bigs = cat(1,1,bigs);
%     end
%     ivs = diff(bigs);
%     assignin('base',['ivs',num2str(i)],ivs);
%     [bigmax, indx] = max(ivs);
%     quietiv(i,:) = [bigs(indx) bigs(indx)+bigmax];
    %%% Közös intervallumot keres változat
    quietthresh(i) = (mean(currpow) + qsdmult*std(currpow));
    piccolo(1:length(find(currpow < (mean(currpow) + qsdmult*std(currpow)))),i) = find(currpow < (mean(currpow) + qsdmult*std(currpow)));
end
assignin('base','quietthresh',quietthresh);
assignin('base','piccolo',piccolo);
sect = intersect(piccolo(:,noref(1)),piccolo(:,noref(2)));
for i = noref(3):noref(end)
    sect = intersect(piccolo(:,i),sect);
end
assignin('base','runsect',sect);
qsect = diff(sect);
louds = qsect(qsect>1);
assignin('base','runlouds',louds);
[~, inds] = ismember(qsect,louds);
goodinds = find(inds~=0);
if(goodinds(1) ~= 1)
    goodinds = cat(1,1,goodinds);
end
assignin('base','runginds',goodinds);
[quietivlen, ind] = max(diff(goodinds));
quietiv = [sect(goodinds(ind)), sect(goodinds(ind))+quietivlen];
quietivs = zeros(size(indataFull,2),2,len);
quietivs(1,:,1) = quietiv;
assignin('base','intervals',quietiv);
quietivT = (quietiv/srate)+t_scale(1);
assignin('base','intervalsT',quietivT);


%%% Ha tul rovid az interval akkor csatornankent hozzarakok 
if (quietiv(2)-quietiv(1)) < sec*srate
    maxnum = 0;
    for i = noref
        extquiets = piccolo(:,i);
        diffquiets = diff(extquiets);
        extlouds = diffquiets(diffquiets>1);
        [~, inds] = ismember(diffquiets,extlouds);
        extgoodinds = find(inds~=0);
        if(extgoodinds(1) ~= 1)
            extgoodinds = cat(1,1,extgoodinds);
        end
        goodies = diff(extgoodinds);
        assignin('base',['goodies',num2str(i)],goodies);
%         [goodielen, ind] = max(goodies);
        tempivs = zeros(length(goodies),2);
        tempivs(1,:) = quietiv;
%         goodies(ind) = 0;
        indx = 1;
        while (sum(tempivs(:,2)-tempivs(:,1))) < (sec*srate+(quietiv(2)-quietiv(1)))
            indx = indx + 1;
            [goodielen, ind] = max(goodies);
            tempivs(indx,:) = [extquiets(extgoodinds(ind)) , extquiets(extgoodinds(ind))+goodielen];
            goodies(ind) = 0;
%             indx = indx + 1;
        end
        assignin('base',['fulltempivs',num2str(i)],tempivs);
        tempivs = tempivs(any(tempivs,2),:);
        tempivs2 = tempivs;
        assignin('base',['tempivs',num2str(i)],tempivs);
        assignin('base',['extgoodies',num2str(i)],goodies);  
%         maxnum = 0;
        for j = 2:size(tempivs,1)
            overlap = intersect(tempivs(j,1):tempivs(j,2),tempivs(1,1):tempivs(1,2));
            if length(overlap) > 1
                tempivs2(j,:) = [];
                tempivs2 = cat(1,tempivs2,[tempivs(j,1) overlap(1)]);
                tempivs2 = cat(1,tempivs2,[overlap(end) tempivs(j,2)]);
            end
        end
        if size(tempivs2,1) > maxnum
            maxnum = size(tempivs2,1);
        end
        quietivs(1:size(tempivs2,1),:,i) = tempivs2;
        assignin('base','quietivs',quietivs);
        assignin('base',['tempivs2',num2str(i)],tempivs2);
    end
    for i = 1:size(quietivs,3)
        quietivs(maxnum+1:end,:,:) = [];
    end
    assignin('base','quietivs',quietivs);
    quietivsT = quietivs;
    quietivsT(:,:,:) = (quietivsT(:,:,:)/srate)+t_scale(1);
    assignin('base','quietivsT',quietivsT);
end
% [~, ind] = max(diff(quietiv,1,2));
% quietiv = quietiv(ind,:);
% assignin('base','bestinterval',quietiv);
allpeaksDP = zeros(size(indataFull,2),2,length(noref));
assignin('base','INITallpeaksDP',allpeaksDP);
%%%%%%%%%%%%%%
%%% SWR detect
%%%%%%%%%%%%%%
for i = ivec
   
%     winstepsize = 1000;
%     eventdist = 1000;
    currpow = power(:,i);
    assignin('base',['currpow',num2str(i)],currpow);
    %%% +1 hogy ne 0-tol indexeljen
    quiet = currpow(quietiv(1)+1:quietiv(2)+1);
    for q = 2:size(quietiv,1)
        quiet = cat(1,quiet,(currpow(quietiv(q,1,i):quietiv(q,2,i))));
    end
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
%     nonzind = find(peaks(:,2));
    peaks = peaks(find(peaks(:,2)),:);
    ppeaks = peaks;
    assignin('base','upeaksvol1',ppeaks);
    for k = 2:size(peaks,1)-1
        if (((peaks(k,1) - peaks(k-1,1)) < eventdist) && (peaks(k,2) < peaks(k-1,2))) || ...
                (((peaks(k+1,1) - peaks(k,1)) < eventdist) && (peaks(k,2) < peaks(k+1,2)))
            ppeaks(k,2) = 0;
        end        
    end
    if size(ppeaks,1)>1
        if ((peaks(2,1)-peaks(1,1)) < eventdist) && (peaks(1,2) < peaks(2,2))
            ppeaks(1,2) = 0;
        end
        if ((peaks(end,1)-peaks(end-1,1)) < eventdist) && (peaks(end,2) < peaks(end-1,2))
            ppeaks(end,2) = 0;
        end
    end
    assignin('base','peaksvol2',ppeaks);
%     nonzind = find(ppeaks(:,2));
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
%     assignin('base',['peaks', num2str(i)],ppeaks);
    assignin('base','rips',currpow);
    
    %%% Hossz alapján kiszûrés
    widths = zeros(size(ppeaks,1),1);
    for ii = 1:size(ppeaks,1)
        iii = ppeaks(ii,1);
        while currpow(iii) > ripsd
            if (iii-1)<1
                break
            end
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
        widths(ii) = (highedge - lowedge)/(srate/1000);
        if (widths(ii) < widthlower) || (widths(ii) > widthupper)
            ppeaks(ii,2) = 0;
        end
        assignin('base','widths',widths);
    end
        
    widths = widths((widths>=widthlower) & (widths<=widthupper));
%     nonzind = find(ppeaks(:,2));
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
   
    %%% refcsatorna peakjei
    if i == refch
        refppeaks = ppeaks;
    end
    
    %%% refchan-hoz hasonlítás
    if i ~= refch && refch ~= 0
        for jj = 1:size(ppeaks,1)
            for kk = 1:size(refppeaks,1)
                if (abs(refppeaks(kk,1)-ppeaks(jj,1))<eventdist) && (refppeaks(kk,2) ~=0)
                    ppeaks(jj,2) = 0;
                    continue
                end
            end    
        end    
    end
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
    
    %%% all peaks in one except refch
    if i ~= refch 
        allpeaksDP(1:size(ppeaks,1),:,i) = ppeaks;
%         maxsize = 0;
%         for ii = 1:size(allpeaksDP,3)
%             if max(find(allpeaksDP(:,1,ii))) > maxsize
%                 maxsize = max(find(allpeaksDP(:,1,ii)));
%             end
%         end
%         allpeaksDP(maxsize+1:end,:,:) = [];
%         assignin('base','allpeaksDP',allpeaksDP);
    end
    %%% Átírás idõskálára 
    for ii = 1:size(ppeaks,1)
        ppeaks(ii,1) = ((ppeaks(ii,1)-1)/srate)+t_scale(1);
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
end

maxsize = 0;
for ii = 1:size(allpeaksDP,3)
    if max(find(allpeaksDP(:,1,ii))) > maxsize
        maxsize = max(find(allpeaksDP(:,1,ii)));
    end
end
allpeaksDP(maxsize+1:end,:,:) = [];
assignin('base','allpeaksDP',allpeaksDP);

%%% valid channel crosscheck
consens = zeros(size(allpeaksDP,1),2);
maxpow = 0;
leadchan = 0;
for i = noref
    if (mean(allpeaksDP(:,2,i)) > maxpow)
        maxpow = mean(allpeaksDP(:,2,i));
        leadchan = i;
    end
end
consens = cat(2,allpeaksDP(:,1,leadchan),ones(size(allpeaksDP,1),1));
consens = cat(2,consens,zeros(size(consens,1),len));
display(leadchan);
for i = 1:size(allpeaksDP,3)
    if i ~= leadchan
        [lia,locb] = ismembertol(allpeaksDP(:,1,i),allpeaksDP(:,1,leadchan),1000,'DataScale',1);
        ulocb = unique(locb);
        ulocb = ulocb(find(ulocb));
        for j = 1:size(ulocb)
            consens(ulocb(j),2) = consens(ulocb(j),2) + 1;
            consens(ulocb(j),2+i) = 1;
        end
    end
end
assignin('base','consens',consens);
consensT = consens;
consensT(:,1) = (consensT(:,1)/srate)+t_scale(1);
assignin('base','consensT',consensT);
allpeaksT = allpeaksDP;
allpeaksT(:,1,:) = (allpeaksT(:,1,:)/srate)+t_scale(1);
assignin('base','allpeaksT',allpeaksT);

figure;
plot(xscala,power(:,leadchan)); hold on;
plot(allpeaksT(:,1,leadchan),allpeaksT(:,2,leadchan),'or');
for i = 1:size(consensT,1)
    for j = 1:len
        if consensT(i,j+2) == 1
            currsel = allpeaksT(:,1,j);
            thex = find(abs(currsel-consensT(i,1))<0.05);
            text(consensT(i,1),allpeaksT(thex,2,j),[num2str(j)]);
        end
    end
end


%%%%%%%%%%%%%%%%%%
%%% SWR detect end ----------------------------------------------------
%%%%%%%%%%%%%%%%%%

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

