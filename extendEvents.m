function newBorders = extendEvents(detBorders,detDataModQ,thr,extThr)

    newBorders = detBorders;
    for j = 1:size(detBorders,1)
        if j == 1
            newBorders(j,1) = extBorders(1:detBorders(j,1),j,1);
        else
            newBorders(j,1) = extBorders(detBorders(j-1,2):detBorders(j,1),j,1);
        end
        if j == size(detBorders,1)
            newBorders(j,2) = extBorders(detBorders(j,2):length(detDataModQ),j,2);
        else
            newBorders(j,2) = extBorders(detBorders(j,2):detBorders(j+1,1),j,2);
        end
    end
    
    function ind = extBorders(interV,j,startOrStop)
        if startOrStop == 1
            if extThr > thr
                ind = find(detDataModQ(detBorders(j,1):detBorders(j,2)),1,'first');
            else
                ind = find(~detDataModQ(interV),1,'last');
            end
        elseif startOrStop == 2
            if extThr > thr
                ind = find(detDataModQ(detBorders(j,1):detBorders(j,2)),1,'last');
            else
                ind = find(~detDataModQ(interV),1,'first');
            end
        end
                
        if isempty(ind)
            if startOrStop == 1
                ind = detBorders(j,1);
            elseif startOrStop == 2
                ind = detBorders(j,2);
            end
        else
            if extThr > thr
                ind = detBorders(j,1)+ind-1;
            else
                ind = interV(1)+ind-1;
            end
        end
        
    end    

end