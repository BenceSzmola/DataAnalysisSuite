function ArtSupp(data)

%% Parameters

fs = 20000;

%% Input data handling

if nargin == 0
    [filename,path] = uigetfile('*.rhd');
    oldpath = cd(path);
    data = read_Intan_RHD2000_file_cl(filename);
    cd(oldpath)
end

%% Independent Component Analysis

[icaEEG,A,W]=fastica(data); % Finding the ICs
PlotEEG(icaEEG,fs,[],[],'Independent components')

%% CWT of ICs

for i = 1:size(data,1)
    figure
    cwt(icaEEG(i,:),'amor',fs,'FrequencyLimit',[0 500])
    title(['Cwt of IC #',num2str(i)])
end

%% wICA style suppression (Makarov et al)

nICs = 1:size(icaEEG,1); % Components to be processed, e.g. [1, 4:7]
Kthr = 1.25;             % Tolerance for cleaning artifacts, try: 1, 1.15,...
ArtefThreshold = 4;      % Threshold for detection of ICs with artefacts
                         % Set lower values if you manually select ICs with 
                         % artifacts. Otherwise increase
verbose = 'on';          % print some intermediate results                         
                         
icaEEG2 = RemoveStrongArtifacts(icaEEG, nICs, Kthr, ArtefThreshold, fs, verbose); 

figure('color','w');
PlotEEG(icaEEG2, fs, [], [], 'wavelet filtered ICs');

Data_wICA = A*icaEEG2;
figure('color','w');
PlotEEG(Data_wICA, fs, [], [], 'wICA cleanned EEG');