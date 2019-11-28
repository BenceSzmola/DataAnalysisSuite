function FMA_testing(filename,filttype,order,ripple,w1,w2,srate)

%%% Read RHD to filter
rhd = read_Intan_RHD2000_file_cl(filename);

%%% Create datafile for FMA
tscale = rhd.t_data(1):(1/srate):(rhd.t_data(1)+(length(rhd.t_amplifier)-1)*(1/srate));
fmadata = transpose(cat(1,tscale,rhd.amplifier_data));

%%% Run FMA filter
filtered = Filter(fmadata,'order',order,'ripple',ripple,'filter',filttype,'passband',[w1 w2],'nyquist',srate/2);

%%% Plotting
for i = 2:size(filtered,2)
    figure('Name',sprintf('Channel %d', i-1));
    plot(filtered(:,1),filtered(:,i));
    title(sprintf('Channel %d', i-1));
    savefig(strcat(filename(1:end-4),'_CH',num2str(i-1),'FmaFilt','.fig'));
end

    
