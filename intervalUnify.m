function unifiedIvs = intervalUnify(intervalCell,minMatchNum)

unifiedIvs = zeros(0,2);
matchTimes = zeros(0,1);
for ivSet = 1:length(intervalCell)
    for iv = intervalCell{ivSet}'
        if isempty(unifiedIvs)
            unifiedIvs(end+1,:) = iv';
            matchTimes(end+1)   = 1;
        else
            matchRows = find(any(ismember(unifiedIvs,iv(1):iv(2)),2));
            if ~isempty(matchRows)
                temp = unifiedIvs(matchRows,:);
                unifiedIvs(matchRows(1),:) = [min([iv(1); temp(:,1)]), max([iv(2); temp(:,2)])];
                matchTimes(matchRows(1))   = matchTimes(matchRows(1)) + 1;
                if length(matchRows) > 1
                    unifiedIvs(matchRows(2:end),:) = [];
                    matchTimes(matchRows(2:end))   = [];
                end
            else
                unifiedIvs(end+1,:) = iv';
                matchTimes(end+1)   = 1;
            end
        end
    end
end

if (nargin < 2) || isempty(minMatchNum) || isnan(minMatchNum)
    minMatchNum = floor(.5*length(intervalCell));
end
unifiedIvs(matchTimes < minMatchNum,:) = [];

unifiedIvs = sort(unifiedIvs,1);