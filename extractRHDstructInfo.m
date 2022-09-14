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
    
    customChanNames = {rhdStruct.amplifier_channels.custom_channel_name}';
    electrImpeds = cellfun(@(x) num2str(x,'%.2e'), {rhdStruct.amplifier_channels.electrode_impedance_magnitude},'UniformOutput', false)';
    rhdInfoCell = cell(2,1);
    rhdInfoCell{1} = {  'Filename', rhdStruct.filename;...
                        'Fs', num2str(rhdStruct.fs);...
                        'Actual lower bandwidth', num2str(rhdStruct.frequency_parameters.actual_lower_bandwidth);...
                        'Actual upper bandwidth', num2str(rhdStruct.frequency_parameters.actual_upper_bandwidth);...
                        'Actual impedance test freq.', num2str(rhdStruct.frequency_parameters.actual_impedance_test_frequency)  };
    rhdInfoCell{2} = [ customChanNames, electrImpeds   ];
end