function populstats

[fnames,path] = uigetfile('*.csv','Select the CSVs!','Multiselect','on');
cd(path);
temp={};
for i = 1:length(fnames)
    fileID = fopen(fnames{i});
    line = [0];
    display('before while')
    while line(1) ~= -1
        display('in while')
        line = fgetl(fileID);
        line_c = {line};
        display(line)
        temp = cat(1,temp,line_c);
    end
    assignin('base','cell',temp);
    fclose(fileID);
end