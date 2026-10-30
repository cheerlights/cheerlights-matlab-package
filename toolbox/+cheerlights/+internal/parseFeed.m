function tt = parseFeed(response)
%PARSEFEED Turn a decoded ThingSpeak feed response into a timetable of color changes.
%   TT = cheerlights.internal.parseFeed(RESPONSE) takes the struct that
%   webread returns for channel 1417's feed.json and returns a timetable,
%   oldest first, with the variables Name, Hex, RGB, and EntryID (int64, 0
%   when the feed gives none). Row times are UTC datetimes.
%
%   Entries with no color name are dropped. An entry without a HEX value
%   takes the HEX of its color name; an unknown name gets "" and NaN RGB.

entries = struct([]);
if isstruct(response) && isfield(response, "feeds")
    entries = response.feeds;
end
if iscell(entries)
    % webread returns a cell array when the entries do not share one set of fields
    entries = entries(cellfun(@isstruct, entries));
else
    entries = num2cell(entries);
end

n = numel(entries);
names = strings(n, 1);
hexes = strings(n, 1);
ids = zeros(n, 1, "int64");
times = NaT(n, 1, TimeZone="UTC");
for k = 1:n
    e = entries{k};
    names(k) = lower(strtrim(text(e, "field1")));
    hexes(k) = lower(strtrim(text(e, "field2")));
    if hexes(k) == ""
        hexes(k) = cheerlights.internal.lookup(names(k));
    end
    id = str2double(text(e, "entry_id"));
    if ~isnan(id)
        ids(k) = int64(id);
    end
    stamp = text(e, "created_at");
    if stamp ~= ""
        times(k) = datetime(stamp, InputFormat="yyyy-MM-dd'T'HH:mm:ssXXX", TimeZone="UTC");
    end
end

keep = names ~= "";
names = names(keep);
hexes = hexes(keep);
rgb = nan(numel(names), 3);
for k = 1:numel(hexes)
    if cheerlights.internal.isHex(hexes(k))
        rgb(k, :) = cheerlights.hexToRGB(hexes(k));
    end
end
tt = timetable(times(keep), names, hexes, rgb, ids(keep), ...
    VariableNames=["Name" "Hex" "RGB" "EntryID"], DimensionNames=["Time" "Variables"]);
tt = sortrows(tt);
end

function s = text(entry, name)
% A field's value as a string; a missing field or a JSON null reads as "".
s = "";
if isfield(entry, name) && ~isempty(entry.(name))
    s = string(entry.(name));
end
end
