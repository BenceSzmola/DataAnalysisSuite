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

poi = find(cellfun(@(x)ischar(x)&&contains(x,'Ca2+ detection'),alldata{:,:,1}));
ROInums = textscan(alldata{:,:,1}{poi+1},'%d# ;');
ROInums = ROInums{:};
ROInums = double(ROInums);

% % % Szinkron tüzelések mátrixa
corrmat = zeros(length(ROInums));
for i = 1:num_f
    poi = find(cellfun(@(x)ischar(x)&&contains(x,'Active'),alldata{:,:,i}))+2;
    if isempty(poi)
        continue
    end
    while ~isempty(alldata{:,:,i}{poi})
        [~,pausespot] = textscan(alldata{:,:,i}{poi},'%*f ; ');
        actives = cell2mat(textscan(alldata{:,:,i}{poi}(pausespot:end),'%d#'));
        display(actives)
        if actives ~= 0 
            for j = 1:length(actives)
                for k = 1:length(actives)
                    if j~=k
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
    cmap(i+1,:) = [1 1-i/(maxcorr+1) 1-i/(maxcorr+1)];
end
assignin('base','rgbmat',rgbmat);
surf(corrmat);
colormap(cmap)

ticks = 0:(maxcorr/(maxcorr+1)):maxcorr-0.1;
ticks = ticks+(maxcorr/(maxcorr+1)/2);
tlabs = 0:maxcorr;
tlabs = tlabs(:);

colorbar('Ticks',ticks,'TickLabels',tlabs)
view(0,90)
% axis tight
axis([1 length(ROInums)+1 1 length(ROInums)+1])

ax = gca;
set(ax,'XTick',ROInums+0.5);
set(ax,'YTick',ROInums+0.5);
set(ax,'YTickLabel',num2str(ROInums));
set(ax,'XTickLabel',num2str(ROInums));
% XTick = get(ax, 'XTick')
% XTickLabel = get(ax, 'XTickLabel')
% set(ax,'XTick',XTick+0.5)
% set(ax,'XTickLabel',XTickLabel)
% 
% YTick = get(ax, 'YTick')
% YTickLabel = get(ax, 'YTickLabel')
% set(ax,'YTick',YTick+0.5)
% set(ax,'YTickLabel',YTickLabel)

% for i = 1:length(corrmat)
%     for j = 1:length(corrmat)
%         if corrmat(i,j) ~= 0 && i~=j
%             x = [i-1 i i i-1];
%             y = [j-1 j-1 j j];
%             corr = corrmat(i,j);
%             coladj = 1/length(fnames);
%             color = [1 1-(coladj*corr) 1-(coladj*corr)];
%             patch(x,y,color);
%             axis([0 length(ROInums) 0 length(ROInums)]);
%             xticks([ROInums]);
%             yticks([ROInums]);
%             grid on;
%         end
%     end
% end
