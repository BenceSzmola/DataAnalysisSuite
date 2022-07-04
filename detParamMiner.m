function [detParams,evComplexes] = detParamMiner(dTyp,dets,detBorders,fs,rawData,detData,dogData,tAxis)

numDets = length(dets);
detInds = dets;

switch dTyp
    case 1
        detParams = struct('RawAmplitudePeakT',cell(numDets,1),'RawAmplitudeP2P',cell(numDets,1),...
            'BpAmplitudePeakT',cell(numDets,1),'BpAmplitudeP2P',cell(numDets,1),...
            'Length',cell(numDets,1),'Frequency',cell(numDets,1),'NumCycles',cell(numDets,1),...
            'AUC',cell(numDets,1),'RiseTime',cell(numDets,1),'RiseTime2080',cell(numDets,1),...
            'DecayTime',cell(numDets,1),'DecayTime8020',cell(numDets,1),'DecayTau',cell(numDets,1),...
            'FWHM',cell(numDets,1),'NumInComplex',cell(numDets,1),'NumSimultEvents',0);
    case 2
        detParams = struct('RawAmplitudePeakT',cell(numDets,1),'RawAmplitudeP2P',cell(numDets,1),'Length',cell(numDets,1),...
            'AUC',cell(numDets,1),'RiseTime',cell(numDets,1),'RiseTime2080',cell(numDets,1),...
            'DecayTime',cell(numDets,1),'DecayTime8020',cell(numDets,1),'DecayTau',cell(numDets,1),...
            'FWHM',cell(numDets,1),'NumInComplex',cell(numDets,1),'NumSimultEvents',0);
end

evComplexes = {};

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
    detParams(i).RiseTime = (detInds(i) - detBorders(i,1))/fs;
    detParams(i).DecayTime = (detBorders(i,2) - detInds(i))/fs;
    
    peak20 = detData(detInds(i))*0.2;
    peak80 = detData(detInds(i))*0.8;
    indsBelow80 = find(detData <= peak80);
    indsBelow20 = find(detData <= peak20);
    indsBelow80pre = indsBelow80(indsBelow80 < detInds(i));
    indsBelow80post = indsBelow80(indsBelow80 > detInds(i));
    indsBelow20pre = indsBelow20(indsBelow20 < detInds(i));
    indsBelow20post = indsBelow20(indsBelow20 > detInds(i));
    pre20Ind = max(indsBelow20pre);
    pre80Ind = max(indsBelow80pre);
    post20Ind = min(indsBelow20post);
    post80Ind = min(indsBelow80post);
    if ~isempty(pre20Ind) && ~isempty(pre80Ind) && ~isempty(post20Ind) && ~isempty(post80Ind)
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
    
    halfmax = detData(detInds(i))/2;
    aboveHM = find(detData > halfmax);
    aboveHMtInd = find(aboveHM==detInds(i));
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
    
    maxSepInComplex = 0.1;
    maxSepInComplex = round(maxSepInComplex * fs);
    if (i ~= numDets) && ~any(detParams(i).NumInComplex) && ((detBorders(i+1,1) - detBorders(i,2)) <= maxSepInComplex)
        detParams(i).NumInComplex = 1;
        detParams(i+1).NumInComplex = 2;
        temp = [i, i+1];
        
        for j = i+2:numDets
            if (detBorders(j,1) - detBorders(j-1,2)) <= maxSepInComplex
                detParams(j).NumInComplex = j-i+1;
                temp = [temp, j];
            else
                break
            end
        end
        evComplexes = [evComplexes; temp];
    elseif ~any(detParams(i).NumInComplex)
        detParams(i).NumInComplex = nan;
    end
    
end