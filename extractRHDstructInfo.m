function rhdInfoCell = extractRHDstructInfo(varargin)
    if (nargin == 1) && isstruct(varargin{1})
        rhdStruct = varargin{1};
    elseif (nargin == 2) && (ischar(varargin{1}) && ischar(varargin{2}))
        rhdStruct = read_Intan_RHD2000_file_szb([varargin{1},varargin{2}]);
    else
        eD = errordlg('To get RHD info, either input the rhd structure or the path and filename of the RHD file!');
        pause(1)
        if ishandle(eD)
            close(eD)
        end
        return
    end
    
    customChanNames = string({rhdStruct.amplifier_channels.custom_channel_name});
    customChanNames = sprintf('%s | ',customChanNames);
    customChanNames = customChanNames(1:end-3);
    electrImpeds = num2str([rhdStruct.amplifier_channels.electrode_impedance_magnitude], '%.2e | ');
    electrImpeds = electrImpeds(1:end-2);
    rhdInfoCell = { 'Filename', rhdStruct.filename;...
                    'Fs', num2str(rhdStruct.fs);...
                    'Actual lower bandwidth', num2str(rhdStruct.frequency_parameters.actual_lower_bandwidth);...
                    'Actual upper bandwidth', num2str(rhdStruct.frequency_parameters.actual_upper_bandwidth);...
                    'Actual impedance test freq.', num2str(rhdStruct.frequency_parameters.actual_impedance_test_frequency);...
                    'Custom channel names', customChanNames;...
                    'Electrode impedance magnitudes', electrImpeds};
end