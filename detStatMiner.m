function detStats = detStatMiner(dets,detBorders,fs,rawData,detData,dogData)

detStats = struct('RawAmplitude',[],'BpAmplitude',[],'Length',[],'Frequency',[],...
            'AUC',[],'RiseTime',[],'DecayTime',[],'FWHM',[]);
        
       
numDets = length(find(~isnan(dets)));
detInds = find(~isnan(dets));
for i = 1:numDets
    detStats(i).Length = (detBorders(i,2)-detBorders(i,1))/fs;
    detStats(i).RawAmplitude = max(abs(rawData(detBorders(i,1):detBorders(i,2))));
    detStats(i).BpAmplitude = max(abs(dogData(detBorders(i,1):detBorders(i,2))));
    detStats(i).AUC = trapz(detData(detBorders(i,1):detBorders(i,2)));
    detStats(i).RiseTime = (detInds(i) - detBorders(i,1))/fs;
    detStats(i).DecayTime = (detBorders(i,2) - detInds(i))/fs;
    detStats(i).Frequency = 0;
    
    halfmax = detData(detInds(i))/2;
    aboveHM = find(detData > halfmax);
    aboveHMtInd = find(aboveHM==detInds(i));
    steps = diff(aboveHM);
    steps = [0,steps,length(detData)];
    disconts = find(steps~=1);
    lowbord = aboveHM(disconts(find((disconts)<aboveHMtInd,1,'last')));
    highbord = aboveHM(disconts(find(disconts>aboveHMtInd,1))-1);
    detStats(i).FWHM = (highbord-lowbord)/fs;
end