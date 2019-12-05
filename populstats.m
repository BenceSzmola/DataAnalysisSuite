function populstats

% % % Reading CSVs into a 3D cell
[fnames,path] = uigetfile('*.csv','Select the event detector CSVs!','Multiselect','on');
oldpath = cd(path);
num_f = length(fnames);
for i = 1:num_f
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
cd(oldpath);
assignin('base','AD',alldata);

% % % Getting num of ROIs
ROInums = textscan(alldata{:,:,1}{2},'Num of ROIs: %d');
ROInums = ROInums{:};
ROInums = double(1:ROInums);
ROInums = ROInums(:);

% % % User selects which statistic they want
statlist = {'Synchron firing';'Pos-ROIs'};
[statind,~] = listdlg('PromptString','Select statistic:',...
                           'ListString',statlist);

switch statind
    case 1
        % % % Synchron firing       
        corrmat = zeros(length(ROInums));
        for i = 1:num_f
            poi = find(cellfun(@(x)ischar(x)&&contains(x,'Active'),alldata{:,:,i}))+2;
            if isempty(poi)
                continue
            end
            while ~isempty(alldata{:,:,i}{poi})
                [~,pausespot] = textscan(alldata{:,:,i}{poi},'%*f');
                actives = cell2mat(textscan(alldata{:,:,i}{poi}(pausespot+3:end),'%d#'));
                actives = unique(actives);
                display(actives)
                if actives ~= 0 
                    for j = 1:length(actives)
                        for k = 1:length(actives)
                            if actives(j)~=actives(k)
                                corrmat(actives(j),actives(k)) = corrmat(actives(j),actives(k))+1;
                            end
                        end
                    end
                end
                poi = poi+1;
            end
        end

        % % %  padding of corrmat
        corrmat = cat(2,corrmat,corrmat(:,end));
        corrmat = cat(1,corrmat,corrmat(end,:));
        assignin('base','corrmat',corrmat);
        maxcorr = max(corrmat,[],'all');

        % % % Create patchy graph
        rgbmat(:,:,1) = ones(size(corrmat));
        rgbmat(:,:,2) = (maxcorr-corrmat)/maxcorr;
        rgbmat(:,:,3) = (maxcorr-corrmat)/maxcorr;
        for i = 0:maxcorr
            cmap(i+1,:) = [1 1-i/(maxcorr) 1-i/(maxcorr)];
        end
        assignin('base','rgbmat',rgbmat);
        assignin('base','cmap',cmap);
        figure('Name','Synchronous firing of ROIs','NumberTitle','off')
        surf(corrmat);
        xlabel('ROI #')
        ylabel('ROI #')
        title('Synchronous firing of ROIs');
        colormap(cmap)

        ticks = 0:(maxcorr/(maxcorr+1)):maxcorr-0.1;
        ticks = ticks+(maxcorr/(maxcorr+1)/2);
        tlabs = 0:maxcorr;
        tlabs = tlabs(:);

        cb = colorbar('Ticks',ticks,'TickLabels',tlabs);
        cb.Label.String = 'Number of synchron firing';
        view(0,90)
        axis([1 length(ROInums)+1 1 length(ROInums)+1])

        ax = gca;
        set(ax,'XTick',ROInums+0.5);
        set(ax,'YTick',ROInums+0.5);
        set(ax,'YTickLabel',num2str(ROInums));
        set(ax,'XTickLabel',num2str(ROInums));
    case 2
        % % % Pos-ROI
        
        [vrdata_fname,vrpath] = uigetfile('*.csv','Select the CSV containing the VR data!');
        if vrdata_fname ~= 0
            oldpath = cd(vrpath);
            opts = detectImportOptions(vrdata_fname);
            opts.ImportErrorRule = 'omitrow';
            opts.MissingRule = 'omitrow';
            vrdata = readtable(vrdata_fname,opts);
            cd(oldpath);
            assignin('base','vrdata',vrdata)
            vrtime = vrdata.Time;
            if any(contains(vrtime,','))
                vrtime = str2double(strrep(vrtime,',','.'));
            else
                vrtime = str2double(vrtime);
            end
            vrpos = vrdata.Position;
            if any(contains(vrpos,','))
                vrpos = str2double(strrep(vrpos,',','.'));
            else
                vrpos = str2double(vrpos);
            end

%             gradi = gradient(vrpos);
%             artepos = find(abs(gradi)>abs(mean(gradi)+5*std(gradi)));
%             if ~isempty(artepos)
%                 vrtime = vrtime(1:artepos(1)-1);
%                 vrpos = vrpos(1:artepos(1)-1);
%             end
            vrpos = vrpos - min(vrpos);
        end
        assignin('base','vrt',vrtime)
        assignin('base','vrp',vrpos)
        
        posROI = [];
        for i = 1:num_f
            poi = find(cellfun(@(x)ischar(x)&&contains(x,'Active'),alldata{:,:,i}))+2;
            if isempty(poi)
                continue
            end
            while ~isempty(alldata{:,:,i}{poi})
                evpos = zeros(1,length(ROInums)+1);
                [evt,pausespot] = textscan(alldata{:,:,i}{poi},'%f');
                tmatch = abs(vrtime-cell2mat(evt))<0.1;
                temp = vrpos(tmatch);
                if ~isempty(temp)
                    evpos(1,1) = temp(1);

                    actives = cell2mat(textscan(alldata{:,:,i}{poi}(pausespot+3:end),'%d#'));
                    actives = unique(actives);
                    display(actives)
                    if actives ~= 0 
                        evpos(1,actives+1) = 1;
                    end
                    display(evpos)
                    posROI = cat(1,posROI,evpos);
                end
                poi = poi+1;
            end
        end
        assignin('base','posROI',posROI)
        
        i = 1;
        while i <= size(posROI,1)
            display('Start of while')
            display(i)
            display(posROI)
            nears = find(abs(posROI(:,1) - posROI(i,1)) < 1); %%% tolerancia értéket bel?ni!
            nears(nears == i) = [];
            display(nears)
            for j = 1:length(nears)
                posROI(i,2:end) = posROI(i,2:end) + posROI(nears(j),2:end);
            end
            display('After first loop')
            display(posROI)
            posROI(nears,:) = [];
            display('After second proc')
            display(posROI)
            
            i = i+1;
        end
        
        assignin('base','proc_posROI',posROI)
        
        posROI_pad = cat(2,posROI,posROI(:,end));
        % % % Create placefield graph
%         tracksteps = linspace(0,max(posROI(:,1)),50);
        tracksteps = linspace(0,max(vrpos),50);
        [X,Y] = meshgrid(tracksteps,1:(length(ROInums)+1));
        Z = zeros(size(X));
        for i = 1:size(posROI,1)
            finds = find(abs(tracksteps-posROI(i,1))<1);
            for j = 1:length(finds)
                Z(:,finds(j)) = posROI_pad(i,2:end);
            end
        end
        
        figure
        surfax = subplot(2,1,2);
        surf(X,Y,Z)
        view(0,90)
        axis tight
        
        ax = gca;
        set(ax,'YTick',ROInums+0.5);
        set(ax,'YTickLabel',num2str(ROInums));
        
        imaxis = subplot(2,1,1);
        [vrpicfname,path] = uigetfile({'*.png';'*.jpg';'*.jpeg'},'Choose the VR track!');
        oldpath = cd(path);
        vrpicnumeric = imread(vrpicfname);
        vrpicnumeric = imrotate(vrpicnumeric,90);
        % % % ide még maybe aspect ratio check
        cd(oldpath);
%         vrpicnumeric = imresize(vrpicnumeric,[length(vrpicnumeric),100]);
        [vrpic]=imshow(vrpicnumeric,'Parent',imaxis);
%         linkaxes([imaxis,surfax],'x');
end
