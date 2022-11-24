function unifiedIvs = intervalUnify(intervalCell)

unifiedIvs = zeros(0,2);
for ivSet = 1:length(intervalCell)
    for iv = intervalCell{ivSet}'
        if isempty(unifiedIvs)
            unifiedIvs(end+1,:) = iv';
        else
            matchRows = find(any(ismember(unifiedIvs,iv(1):iv(2)),2));
            if ~isempty(matchRows)
                temp = unifiedIvs(matchRows,:);
                unifiedIvs(matchRows(1),:) = [min([iv(1); temp(:,1)]), max([iv(2); temp(:,2)])];
                if length(matchRows) > 1
                    unifiedIvs(matchRows(2:end),:) = [];
                end
            else
                unifiedIvs(end+1,:) = iv';
            end
        end
    end
end
unifiedIvs = sort(unifiedIvs,1);
