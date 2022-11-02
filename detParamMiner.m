function [dets, detBorders, detParams, evComplexes] = detParamMiner(dTyp,dets,detBorders,fs,rawData,detData,dogData,tAxis)

numDets = length(dets);
% detInds = dets;
dets2del = false(numDets, 1);

switch dTyp
    case 1
        detParams = struct('RawAmplitudePeakT',cell(numDets,1),'RawAmplitudeP2P',cell(numDets,1),...
            'BpAmplitudePeakT',cell(numDets,1),'BpAmplitudeP2P',cell(numDets,1),...
            'Length',cell(numDets,1),'Frequency',cell(numDets,1),'NumCycles',cell(numDets,1),...
            'AUC',cell(numDets,1),'RiseTime',cell(numDets,1),'RiseTime2080',cell(numDets,1),...
            'DecayTime',cell(numDets,1),'DecayTime8020',cell(numDets,1),'DecayTau',cell(numDets,1),...
            'FWHM',cell(numDets,1),'NumInComplex',cell(numDets,1),'NumSimultEvents',nan);
    case 2
        detParams = struct('RawAmplitudePeakT',cell(numDets,1),'RawAmplitudeP2P',cell(numDets,1),'Length',cell(numDets,1),...
            'AUC',cell(numDets,1),'RiseTime',cell(numDets,1),'RiseTime2080',cell(numDets,1),...
            'DecayTime',cell(numDets,1),'DecayTime8020',cell(numDets,1),'DecayTau',cell(numDets,1),...
            'FWHM',cell(numDets,1),'NumInComplex',cell(numDets,1),'NumSimultEvents',nan);
end

for i = 1:numDets
    detParams(i).Length = (detBorders(i,2)-detBorders(i,1))/fs;
    detParams(i).RawAmplitudeP2P = max(rawData(detBorders(i,1):detBorders(i,2)))...
        - min(rawData(detBorders(i,1):detBorders(i,2)));
    [~,rawPeakInd] = max(abs(rawData(detBorders(i,1):detBorders(i,2))));
    detParams(i).RawAmplitudePeakT = tAxis(detBorders(i,1) + rawPeakInd - 1);
    if dTyp == 1
        [~,bpPeakInd] = max(abs(dogData(detBorders(i,1):detBorders(i,2))));
        detParams(i).BpAmplitudePeakT = tAxis(detBorders(i,1) + bpPeakInd - 1);
        detParams(i).BpAmplitudeP2P = max(dogData(detBorders(i,1):detBorders(i,2)))...
            - min(dogData(detBorders(i,1):detBorders(i,2)));

        peaks = findpeaks(dogData(detBorders(i,1):detBorders(i,2)));
        detParams(i).NumCycles = length(peaks);
        
        [cfs,f] = cwt(dogData(detBorders(i,1):detBorders(i,2)),'amor',...
            fs,'FrequencyLimits',[1,1000]);
        maxCfs = max(abs(cfs(:)));
        [r,~] = find(abs(cfs)==maxCfs,1);
        detParams(i).Frequency = f(r);
%         detParams(i).Frequency = 0;
    end
    detParams(i).AUC = trapz(detData(detBorders(i,1):detBorders(i,2)));
    detParams(i).RiseTime = (dets(i) - detBorders(i,1))/fs;
    detParams(i).DecayTime = (detBorders(i,2) - dets(i))/fs;
    
    peak20 = detData(dets(i))*0.2;
    peak80 = detData(dets(i))*0.8;
    indsBelow80 = find(detData <= peak80);
    indsBelow20 = find(detData <= peak20);
    indsBelow80pre = indsBelow80(indsBelow80 < dets(i));
    indsBelow80post = indsBelow80(indsBelow80 > dets(i));
    indsBelow20pre = indsBelow20(indsBelow20 < dets(i));
    indsBelow20post = indsBelow20(indsBelow20 > dets(i));
    pre20Ind = max(indsBelow20pre);
    pre80Ind = max(indsBelow80pre);
    post20Ind = min(indsBelow20post);
    post80Ind = min(indsBelow80post);
    if ~isempty(pre20Ind) && ~isempty(pre80Ind) && ~isempty(post20Ind) && ~isempty(post80Ind) && (post80Ind - post20Ind) > 2
        detParams(i).RiseTime2080 = (pre80Ind - pre20Ind)/fs;
        detParams(i).DecayTime8020 = (post20Ind - post80Ind)/fs;
        if ~isempty(detParams(i).DecayTime8020)
            expFit = fit(linspace(1,(post20Ind-post80Ind)+1,(post20Ind-post80Ind)+1)',detData(post80Ind:post20Ind)','exp1');
            detParams(i).DecayTau = expFit.b;
        end
    else
        detParams(i).RiseTime2080 = nan;
        detParams(i).DecayTime8020 = nan;
        detParams(i).DecayTau = nan;
    end
    
    halfmax = detData(dets(i))/2;
    aboveHM = find(detData > halfmax);
    aboveHMtInd = find(aboveHM==dets(i));
    steps = diff(aboveHM);
    steps = [0,steps,length(detData)];
    disconts = find(steps~=1);
    lowbord = aboveHM(disconts(find((disconts)<aboveHMtInd,1,'last')));
    highbord = aboveHM(disconts(find(disconts>aboveHMtInd,1))-1);
    if ~isempty(highbord) && ~isempty(lowbord)
        detParams(i).FWHM = (highbord-lowbord)/fs;
    else
        detParams(i).FWHM = nan;
    end
    
end

dets(dets2del) = [];
detBorders(dets2del,:) = [];
detParams(dets2del) = [];

maxSepInComplex = 0.1;
maxSepInComplex = round(maxSepInComplex * fs);
[evComplexes, detParams] = extractEvComplexes(detParams,detBorders,maxSepInComplex);