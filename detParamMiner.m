function detParams = detParamMiner(dTyp,dets,detBorders,fs,rawData,detData,dogData)

switch dTyp
    case 1
        detParams = struct('RawAmplitudeP2P',[],'BpAmplitudeP2P',[],'Length',[],'Frequency',[],...
                'AUC',[],'RiseTime',[],'DecayTime',[],'FWHM',[]);
    case 2
        detParams = struct('RawAmplitudeP2P',[],'Length',[],'AUC',[],...
            'RiseTime',[],'DecayTime',[],'FWHM',[]);
end


numDets = length(find(~isnan(dets)));
detInds = find(~isnan(dets));
for i = 1:numDets
    detParams(i).Length = (detBorders(i,2)-detBorders(i,1))/fs;
    detParams(i).RawAmplitudeP2P = max(rawData(detBorders(i,1):detBorders(i,2)))...
        - min(rawData(detBorders(i,1):detBorders(i,2)));
    if dTyp == 1
        detParams(i).BpAmplitudeP2P = max(dogData(detBorders(i,1):detBorders(i,2)))...
            - min(dogData(detBorders(i,1):detBorders(i,2)));

        [cfs,f] = cwt(dogData(detBorders(i,1):detBorders(i,2)),'amor',...
            fs,'FrequencyLimits',[1,500]);
        maxCfs = max(abs(cfs));
        [r,~] = find(abs(cfs)==maxCfs,1);
        detParams(i).Frequency = f(r);
%         detParams(i).Frequency = 0;
    end
    detParams(i).AUC = trapz(detData(detBorders(i,1):detBorders(i,2)));
    detParams(i).RiseTime = (detInds(i) - detBorders(i,1))/fs;
    detParams(i).DecayTime = (detBorders(i,2) - detInds(i))/fs;
    
    
    
    halfmax = detData(detInds(i))/2;
    aboveHM = find(detData > halfmax);
    aboveHMtInd = find(aboveHM==detInds(i));
    steps = diff(aboveHM);
    steps = [0,steps,length(detData)];
    disconts = find(steps~=1);
    lowbord = aboveHM(disconts(find((disconts)<aboveHMtInd,1,'last')));
    highbord = aboveHM(disconts(find(disconts>aboveHMtInd,1))-1);
    detParams(i).FWHM = (highbord-lowbord)/fs;
end