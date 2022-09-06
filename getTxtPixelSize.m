function width = getTxtPixelSize(str,fontName,fontSize)

if nargin > 1
    getPixSizeUIC = uicontrol('Style', 'text', 'Visible', 'off', 'FontName', fontName, 'FontSize', fontSize);
else
    getPixSizeUIC = uicontrol('Style', 'text', 'Visible', 'off');
end
getPixSizeUIC.String = str;
width = getPixSizeUIC.Extent(3);
delete(getPixSizeUIC)