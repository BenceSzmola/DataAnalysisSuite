function [evComplexes, detParams] = extractEvComplexes(detParams,detBorders,maxSepInComplex)
% [evComplexes, detParams] = extractEvComplexes(detParams,detBorders,maxSepInComplex)
% Feed in one channel's data at a time
% input maxSepInComplex in indexes not time stamps


evComplexes = {};
numDets = length(detParams);
[detParams(:).NumInComplex] = deal(nan);

for i = 1:numDets
    if (i ~= numDets) && ~any(detParams(i).NumInComplex) && ((detBorders(i+1,1) - detBorders(i,2)) <= maxSepInComplex)
        detParams(i).NumInComplex = 1;
        detParams(i+1).NumInComplex = 2;
        temp = [i, i+1];

        for j = i+2:numDets
            if (detBorders(j,1) - detBorders(j-1,2)) <= maxSepInComplex
                detParams(j).NumInComplex = j-i+1;
                temp = [temp, j];
            else
                break
            end
        end
        evComplexes = [evComplexes; temp];
    elseif ~any(detParams(i).NumInComplex)
        detParams(i).NumInComplex = nan;
    end
end

end