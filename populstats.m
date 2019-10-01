function populstats

% % % Reading CSVs into a 3D cell
[fnames,path] = uigetfile('*.csv','Select the CSVs!','Multiselect','on');
cd(path);
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
assignin('base','AD',alldata);

% % % Getting num of ROIs
poi = find(cellfun(@(x)ischar(x)&&contains(x,'Ca2+ detection'),alldata{:,:,1}));
ROInums = textscan(alldata{:,:,1}{poi+1},'%d# ;');
ROInums = ROInums{:};
ROInums = double(ROInums);

% % % User selects which statistic they want
statlist = {'Synchron firing';'Time-ROIs'};
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
        % % % Time-ROI
        for i = 1:num_f
            poi = find(cellfun(@(x)ischar(x)&&contains(x,'Active'),alldata{:,:,i}))+2;
            if isempty(poi)
                continue
            end
            j = 1;
            while ~isempty(alldata{:,:,i}{poi})
                [evt,pausespot] = textscan(alldata{:,:,i}{poi},'%*f');
                evts(j,:,i) = evt;
                actives = cell2mat(textscan(alldata{:,:,i}{poi}(pausespot+3:end),'%d#'));
                actives = unique(actives);
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
                j = j+1;
            end
        end
end
