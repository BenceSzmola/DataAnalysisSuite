function [dets,detBorders,detParams] = wavyDet(data,taxis,fs,minLen,sdmult,w1,w2,refch,showFigs)
%% Parameters
% srate = 20000;
if nargin ~= 0
    fs = round(fs,4);
    % mindist = 50;
    % runavgwindow = 0.25;
    % minlen = 0.02;
    minLen = round(minLen,4);
    % sdmult = 3;
    sdmult = round(sdmult,4);
    w1 = round(w1,4);
    w2 = round(w2,4);
    if size(data,1) > size(data,2)
        data = data';
    end
end

% Checking whether refchan validation is requested 
% 0 => not reqeusted; nonzero number => number of refchan; 
% dataseries => refchan itself
if refch == 0
    refVal = 0;
elseif isnumber(refch) && (refch~=0)
    refVal = 1;
else % Only one data channel is given + the refchannel in a separate array
    refVal = 2;
end

%% Input data handling

% Usage from commandline
if nargin == 0
    minLen = 0.01;
    sdmult = 3;
    w1 = 5;
    w2 = 40;
    fs = 20000;
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_cl(filename);
    cd(oldpath)
    goodch = input('Which is the leadchan?\n');
    refch = input('Which is the refchan?\n');
    if refch ~= 0
        data = data.amplifier_data(goodch,:)-data.amplifier_data(refch,:);
    else
        data = data.amplifier_data(goodch,:);
    end
end

if size(data,1) > size(data,2)
    data = data';
end

% dets = nan(size(data));
% detBorders = cell(min(size(data)),1);
detParams = cell(min(size(data)),1);

dogged = DoG(data,fs,w1,w2);

% Finding above threshold segments on refchan
if refVal ~= 0
    switch refVal
        case 1
            refData = data(refch,:);
        case 2
            refData = refch;
    end
    refDogged = DoG(refData,fs,w1,w2);
    [refCoeffs,~,~] = cwt(refData,fs,'amor','FrequencyLimits',[w1 w2]);
    refInstE = trapz(abs(refCoeffs).^2);
    refThr = mean(refInstE) + std(refInstE);
    
    [refDets,refDetMarks,aboveRefThr,belowRefThr] = refDetAlg(refInstE,[],refThr,fs);
else
    refDogged = [];
    refInstE = [];
    refThr = [];
    refDets = [];
end

instE = zeros(size(data));
quietThr = nan(size(data,1),1);
quietSegs = cell(size(data,1),1);
qSegsInds = cell(size(data,1),1);
thr = nan(size(data,1),1);
extThr = nan(size(data,1),1);
for i = 1:min(size(data))
    if i == refch
        continue
    end
    
    %% Apply periodic filt
    % data = periodicNoise(data,srate,1000);

    %% CWT
    mb = msgbox('Computing wavelet transform...');

    [coeffs,~,~] = cwt(data(i,:),fs,'amor','FrequencyLimits',[w1 w2]);
    coeffs = abs(coeffs);

    %% Z-score

    z_coeffs = (coeffs-mean(mean(coeffs)))/std(std(coeffs));
    % assignin('base','zizz',z_coeffs)
    delete(mb);

    %% Threshold calculation and detection

    % Instantaneous energy integral approach
    currInstE  = trapz(abs(coeffs).^2);
    instE(i,:) = currInstE;
%     thr = mean(instE) + sdmult*std(instE);
    quietThr(i) = mean(currInstE) + std(currInstE);
    quietSegs{i} = currInstE(currInstE < quietThr(i));
    qSegsInds{i} = currInstE;
    qSegsInds{i}(currInstE>=quietThr(i)) = nan;
    
    thr(i) = mean(quietSegs{i}) + sdmult*std(quietSegs{i});
    extThr(i) = mean(quietSegs{i}) + std(quietSegs{i});
    
end
    
    [dets,detBorders] = commDetAlg(taxis,data,instE,dogged,refch,refDogged,refDets,fs,...
        thr,refVal,minLen,extThr);
        
%     dets(i,:) = validDets;
%     detBorders{i} = validDetBorders;
    
for i = 1:min(size(data))
    detParams{i} = detParamMiner(1,dets(i,:),detBorders{i},fs,data(i,:),instE(i,:),dogged(i,:));

    %% Plotting
    if showFigs
        xtraFig = figure('Name',['Chan#',num2str(i)],'Visible','off');

        if refVal ~= 0
            sp1 = subplot(311);
            sp2 = subplot(312);
            sp3 = subplot(313);
            linkaxes([sp1,sp2,sp3],'x')
            
            plot(sp3,taxis,belowRefThr)
            hold(sp3,'on')
            plot(sp3,taxis,aboveRefThr,'-r')
            yline(sp3,refThr,'Color','g','LineWidth',1);
            hold(sp3,'off')

            xlabel(sp3,'Time [s]')
            ylabel(sp3,'CWT coefficient magnitude')
            title(sp3,'Instant energy of reference channel')
            legend(sp3,{'Inst.E.','Above threshold'})
        else
            sp1 = subplot(211);
            sp2 = subplot(212);
            linkaxes([sp1,sp2],'x')
        end
        
        plot(sp1,taxis,dogged(i,:))
        hold(sp1,'on')
        plot(sp1,taxis,dets(i,:),'*r','MarkerSize',10)
        hold(sp1,'off')
        xlabel(sp1,'Time [s]')
        ylabel(sp1,'Voltage [\muV]')
        title(sp1,['DoG of channel #',num2str(i)])

        plot(sp2,taxis,instE(i,:))
        hold(sp2,'on')
        plot(sp2,taxis,dets(i,:),'*r','MarkerSize',10)
        yline(sp2,thr(i),'Color','g');
        yline(sp2,quietThr(i),'Color','k');
        plot(sp2,taxis,qSegsInds{i},'-m')
        legend(sp2,'Inst. Energy integral','Detections','Detection threshold',...
            'Quiet threshold','Quiet segments')
        hold(sp2,'off')
        xlabel(sp2,'Time [s]')
        ylabel(sp2,'CWT coefficient magnitude')
        title(sp2,'Instantaneous energy based on CWT')

        xtraFig.Visible = 'on';
        
    end
end

if refVal == 1
    dets(refch,:) = refDetMarks;
end