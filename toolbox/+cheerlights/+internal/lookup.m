function hex = lookup(names)
%LOOKUP HEX values of CheerLights color names, "" where a name is not a CheerLights color.
%   HEX = cheerlights.internal.lookup(NAMES) ignores case and spaces, and
%   reads the older name "warmwhite" as "oldlace".

names = lower(replace(string(names), " ", ""));
names(names == "warmwhite") = "oldlace";
palette = cheerlights.colors();
[found, where] = ismember(names, palette.Name);
hex = strings(size(names));
hex(found) = palette.Hex(where(found));
end
