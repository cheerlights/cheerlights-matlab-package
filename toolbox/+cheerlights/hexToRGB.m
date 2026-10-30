function rgb = hexToRGB(hex, outputType)
%HEXTORGB Convert HEX color values to RGB triplets.
%   RGB = cheerlights.hexToRGB(HEX) converts each HEX value, such as
%   "#ffa500" or "ffa500", to a row [red green blue] of doubles from 0 to 1,
%   the form MATLAB graphics use. HEX can be a string array or a character
%   vector; RGB has one row per value.
%
%   RGB = cheerlights.hexToRGB(HEX, "uint8") returns uint8 values from 0 to
%   255 instead, the form most LED libraries use.
%
%   Example:
%       cheerlights.hexToRGB("#ffa500")            % [1 0.6471 0]
%       cheerlights.hexToRGB("#ffa500", "uint8")   % [255 165 0]
%
%   Errors with the ID cheerlights:invalidHex when a value is not six
%   hexadecimal digits.
%
%   See also cheerlights.colorToHex, cheerlights.colors.

arguments
    hex {mustBeText}
    outputType (1,1) string {mustBeMember(outputType, ["double" "uint8"])} = "double"
end

hex = string(hex);
hex = hex(:);
bad = ~cheerlights.internal.isHex(hex);
if any(bad)
    error("cheerlights:invalidHex", "Not a HEX color: ""%s"". Use six hexadecimal digits, such as ""#ffa500"".", ...
        hex(find(bad, 1)))
end

digits = char(erase(strtrim(hex), "#"));
values = zeros(numel(hex), 3);
for c = 1:3
    values(:, c) = hex2dec(string(digits(:, 2*c - 1:2*c)));
end

if outputType == "uint8"
    rgb = uint8(values);
else
    rgb = values / 255;
end
end
