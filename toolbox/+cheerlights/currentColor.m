function color = currentColor()
%CURRENTCOLOR The current CheerLights color.
%   COLOR = cheerlights.currentColor() reads the CheerLights feed
%   (ThingSpeak channel 1417) and returns a struct with the fields:
%       Name - color name, such as "red" (string)
%       Hex  - HEX value, such as "#ff0000" (string)
%       RGB  - [red green blue] from 0 to 1, for MATLAB graphics
%       Time - when the color was set (UTC datetime)
%
%   Example: fill a figure with the color everyone is looking at
%       color = cheerlights.currentColor();
%       figure(Color=color.RGB, Name="CheerLights is " + color.Name);
%
%   Errors with the ID cheerlights:feedUnavailable when the feed cannot be
%   reached, and cheerlights:noColor when it returns no color.
%
%   See also cheerlights.currentColorName, cheerlights.currentHex,
%   cheerlights.colorHistory, cheerlights.watch.

latest = cheerlights.internal.feed(1);
if isempty(latest)
    error("cheerlights:noColor", "The CheerLights feed returned no color.")
end
latest = latest(end, :);
color = struct(Name=latest.Name, Hex=latest.Hex, RGB=latest.RGB, Time=latest.Time);
end
