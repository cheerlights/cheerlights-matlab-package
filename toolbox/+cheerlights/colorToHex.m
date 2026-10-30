function hex = colorToHex(name)
%COLORTOHEX HEX value of a CheerLights color name.
%   HEX = cheerlights.colorToHex(NAME) returns the HEX value of each
%   CheerLights color in NAME, such as "#008000" for "green". Case and
%   spaces do not matter ("Old Lace" works), and the older name "warmwhite"
%   means "oldlace". NAME can be a string array or a character vector.
%
%   Example:
%       cheerlights.colorToHex("green")             % "#008000"
%       cheerlights.colorToHex(["red" "Old Lace"])  % ["#ff0000" "#fdf5e6"]
%
%   Errors with the ID cheerlights:unknownColor when a name is not a
%   CheerLights color. Check first with cheerlights.isValidColor.
%
%   See also cheerlights.isValidColor, cheerlights.colors, cheerlights.hexToRGB.

arguments
    name {mustBeText}
end

hex = cheerlights.internal.lookup(name);
unknown = hex == "";
if any(unknown, "all")
    name = string(name);
    error("cheerlights:unknownColor", """%s"" is not a CheerLights color. The colors are: %s.", ...
        name(find(unknown, 1)), join(cheerlights.colors().Name, ", "))
end
end
