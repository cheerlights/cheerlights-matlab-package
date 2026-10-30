function hex = currentHex()
%CURRENTHEX HEX value of the current CheerLights color, such as "#ff0000".
%   HEX = cheerlights.currentHex() returns a string.
%
%   See also cheerlights.currentColor, cheerlights.currentColorName.

hex = cheerlights.currentColor().Hex;
end
