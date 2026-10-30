function palette = colors()
%COLORS The official CheerLights colors.
%   PALETTE = cheerlights.colors() returns a table with one row per
%   CheerLights color and the variables Name (string), Hex (string, such as
%   "#ff0000"), and RGB (1-by-3 double from 0 to 1, ready for MATLAB
%   graphics). The HEX values are the ones the CheerLights feed publishes.
%
%   Example: draw a swatch of every color
%       palette = cheerlights.colors();
%       bar(1:height(palette), ones(height(palette), 1), FaceColor="flat", CData=palette.RGB);
%       xticks(1:height(palette)); xticklabels(palette.Name);
%
%   See also cheerlights.colorToHex, cheerlights.isValidColor, cheerlights.hexToRGB.

name = ["red"; "green"; "blue"; "cyan"; "white"; "oldlace"; ...
    "purple"; "magenta"; "yellow"; "orange"; "pink"];
hex = ["#ff0000"; "#008000"; "#0000ff"; "#00ffff"; "#ffffff"; "#fdf5e6"; ...
    "#800080"; "#ff00ff"; "#ffff00"; "#ffa500"; "#ffc0cb"];
palette = table(name, hex, cheerlights.hexToRGB(hex), VariableNames=["Name" "Hex" "RGB"]);
end
