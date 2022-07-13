function numOutput = numSelCharConverter(charInput)

% numOutput = numSelCharConverter(charInput)
% converts characters representing a range of numbers or a selection of numbers to integers
% e.g.: '1-6' --> 1:6
% e.g.: '1,4,6' --> [1,4,6]

if ischar(charInput)
    hyphPos = find(charInput == '-');
    if length(hyphPos) > 1
        eD = errordlg('Only use 1 interval, or input channels sepearated by comma!');
        pause(1)
        if ishandle(eD)
            close(eD)
        end
        return
    elseif isempty(hyphPos)
        numOutput = str2num(charInput);
    else
        firstPart = charInput(1:hyphPos-1);
        secondPart = charInput(hyphPos+1:end);
        numOutput = str2num(firstPart):str2num(secondPart);
    end
else
    numOutput = charInput;
end