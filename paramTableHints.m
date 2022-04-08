function paramTableHints(ev)

if isempty(ev.Indices)
    return    
end

paramHint = '';
switch ev.Source.Data{ev.Indices(1),1}
    case 'RawAmplitudePeakT'
        paramHint = 'Time point of the event''s peak amplitude on the raw recording';
    case 'RawAmplitudeP2P'
        paramHint = 'Peak to peak amplitude of the event on the raw recording';
    case 'BpAmplitudePeakT'
        paramHint = 'Time point of the event''s peak amplitude on the bandpass filtered recording';
    case 'BpAmplitudeP2P'
        paramHint = 'Peak to peak amplitude of the event on the bandpass filtered recording';
    case 'Length'
        paramHint = 'Time duration of the event in [ms]';
    case 'Frequency'
        paramHint = 'Frequency at which the event had its peak spectral power';
    case 'NumCycles'
        paramHint = 'Number of oscillations in the bandpass filtered event';
    case 'AUC'
        paramHint = 'Area under the event''s curve';
    case 'RiseTime'
        paramHint = 'Time it took for the signal to rise to the event''s peak from the baseline';
    case 'RiseTime2080'
        paramHint = 'Time it took for the signal to rise from 20% to 80% of the event''s peak amplitude';
    case 'DecayTime'
        paramHint = 'Time it took for the signal to decay from the event''s peak back to baseline';
    case 'DecayTime8020'
        paramHint = 'Time it took for the signal to decay from 80% to 20% of the event''s peak amplitude';
    case 'DecayTau'
        paramHint = 'Exponent value of the exponential curve fitted to the decaying signal';
    case 'FWHM'
        paramHint = 'Full width at half maximum: the time it took for the signal to rise from 50% of the peak amplitude and then decay back to 50%';
    case 'NumSimultEvents'
        paramHint = 'Number of events from the other data type which coincided with the currently shown event';
    case 'AvgSpeed'
        paramHint = 'Average of the recorded velocity values during the event';
    case 'RelPos'
        paramHint = 'Average of the relative (within a lap) position values recoded during the event';
end


if ~isempty(paramHint)
    msgbox(paramHint,[ev.Source.Data{ev.Indices(1),1}],'modal')
end
            
temp = ev.Source.Data;
ev.Source.Data = {''};
ev.Source.Data = temp;
