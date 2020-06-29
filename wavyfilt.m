function [recdata] = wavyfilt(data)
%%
srate = 20000;
dt = 1/srate;
step = 0.05;
win = step*2;
upthr = 2.7;
lowthr = 1.6;
minwidth = 0.01;
mindist = 0.03;
ratio = 0.99;
declvl = 6;

%%
if nargin == 0
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
tax = 0:dt:(length(data)*dt)-dt;

%%
[c,l] = wavedec(data,declvl,'db5');
approx = appcoef(c,l,'db5');
[cds] = detcoef(c,l,[1:declvl]);
% deleting undesired freqs
c(1:sum(l(1:2))) = 0;
c(sum(l(1:3)):end) = 0;
assignin('base','c',c)
assignin('base','l',l)
assignin('base','approx',approx)
assignin('base','cds',cds)

%%
figure
subplot(declvl+1,1,1)
plot(approx)
title('Approximation Coefficients')
for i = 1:declvl
    subplot(declvl+1,1,i+1)
    plot(cds{i})
    title(['Level ',num2str(i) ' Detail Coeffs'])
end

%%
recdata = waverec(c,l,'db5');
assignin('base','recdata',recdata)
figure
subplot(2,1,1)
plot(data)
title('O G')
subplot(2,1,2)
plot(recdata)
title('reconstructed')
axis tight
