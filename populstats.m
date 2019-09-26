function populstats

% % % Reading CSVs into a 3D cell
[fnames,path] = uigetfile('*.csv','Select the CSVs!','Multiselect','on');
cd(path);
for i = 1:length(fnames)
    temp={};
    fileID = fopen(fnames{i});
    line = '';
    while ischar(line)
        line = fgetl(fileID);
        if ~ischar(line)
            break
        end
        line_c = {line};
        temp = cat(1,temp,line_c);
    end
    assignin('base','temporo',temp);
    alldata{:,:,i} = temp;
    fclose(fileID);
end
assignin('base','AD',alldata);

poi = find(cellfun(@(x)ischar(x)&&contains(x,'Ca2+ detection'),alldata{:,:,1}));
ROInums = textscan(alldata{:,:,1}{poi+1},'%d# ;');
ROInums = ROInums{:};

% % % Szinkron tüzelések mátrixa
corrmat = zeros(length(ROInums));
for i = 1:length(fnames)
    poi = find(cellfun(@(x)ischar(x)&&contains(x,'Active'),alldata{:,:,i}))+2;
    [~,pausespot] = textscan(alldata{:,:,i}{poi},'%*f ; ');
    actives = cell2mat(textscan(alldata{:,:,i}{poi}(pausespot:end),'%d#'));
end
assignin('base','actives',actives);