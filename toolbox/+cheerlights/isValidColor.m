function tf = isValidColor(name)
%ISVALIDCOLOR True for each name that is a CheerLights color.
%   TF = cheerlights.isValidColor(NAME) returns a logical array the size of
%   NAME. Case and spaces do not matter, and the older name "warmwhite"
%   counts as "oldlace".
%
%   Example:
%       cheerlights.isValidColor(["Red" "teal"])   % [true false]
%
%   See also cheerlights.colorToHex, cheerlights.colors.

arguments
    name {mustBeText}
end

tf = cheerlights.internal.lookup(name) ~= "";
end
