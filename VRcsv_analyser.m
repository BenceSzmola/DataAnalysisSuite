function VRcsv_analyser

% % % Reading CSVs
[fnames,path] = uigetfile('*.csv','Select the VR run CSVs!','Multiselect','on');
assignin('base','fnames',fnames);
oldpath = cd(path);
num_f = length(fnames);

for i = 1:num_f
    opts = detectImportOptions(fnames{i});
    opts.ImportErrorRule = 'omitrow';
    uno_runtable = readtable(fnames{i},opts);
    uno_runtable_t=table2cell(uno_runtable(:,1));
    uno_runtable_p=table2cell(uno_runtable(:,2));
    uno_runtable_v=table2cell(uno_runtable(:,3));
    
    runtable_t{i} = uno_runtable_t;
    runtable_p{i} = uno_runtable_p;
    runtable_v{i} = uno_runtable_v;
end

% assignin('base','pruntable_t',runtable_t);
% assignin('base','pruntable_p',runtable_p);
% assignin('base','pruntable_v',runtable_v);

cd(oldpath);

for i = 1:num_f
    try
        runtable_t{i} = str2double(strrep(runtable_t{i},',','.'));
    catch
        runtable_t{i} = zeros(size(runtable_t{i}));
    end
    try
        runtable_p{i} = str2double(strrep(runtable_p{i},',','.'));
    catch
        runtable_p{i} = zeros(size(runtable_p{i}));
    end
    runtable_p{i} = runtable_p{i} - runtable_p{i}(1);
    try
        runtable_v{i} = cell2mat(runtable_v{i});
    catch
        runtable_v{i} = zeros(size(runtable_v{i}));
    end
end

assignin('base','runtable_t',runtable_t);
assignin('base','runtable_p',runtable_p);
assignin('base','runtable_v',runtable_v);

for i = 1:num_f
    tmax(i) = max(runtable_t{i});
    pmax(i) = max(runtable_p{i});
end

pmax_licks = pmax(pmax>62 & pmax<84);

fprintf(1,'Average lap time: %.2f s\nStandard deviation: %.2f s\nRuns/Licks: %d/%d\n',mean(tmax),std(tmax),num_f,length(pmax_licks));

figure;
plot(tmax,'ok'); hold on;
for i = 1:num_f
    if (pmax(i)<84) && (pmax(i)>62)
        plot(i,tmax(i),'ok','MarkerFaceColor','r'); hold on;
    end
end
title('Lap duration')
ylabel('Time [s]')
xlabel('Lap #')

%%