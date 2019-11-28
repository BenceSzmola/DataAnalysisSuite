fig_h = figure;
set(fig_h,'KeyPressFcn', @keypressed_fcn)

function keypressed_fcn(fig,eventDat)

get(fig, 'CurrentKey')
get(fig, 'CurrentCharacter')
get(fig, 'CurrentModifier')
end