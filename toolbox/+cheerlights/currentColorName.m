function name = currentColorName()
%CURRENTCOLORNAME Name of the current CheerLights color, such as "red".
%   NAME = cheerlights.currentColorName() returns a string.
%
%   See also cheerlights.currentColor, cheerlights.currentHex.

name = cheerlights.currentColor().Name;
end
