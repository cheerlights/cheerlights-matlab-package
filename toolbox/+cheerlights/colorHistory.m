function history = colorHistory(count)
%COLORHISTORY The most recent CheerLights color changes.
%   HISTORY = cheerlights.colorHistory() returns the last 10 changes.
%   HISTORY = cheerlights.colorHistory(COUNT) returns the last COUNT
%   changes, from 1 to 8000.
%
%   HISTORY is a timetable, oldest first, with UTC row times (Time) and the
%   variables Name, Hex, RGB (from 0 to 1), and EntryID (the change's
%   number in the feed, int64).
%
%   Example: the colors of the last 50 changes as a strip
%       history = cheerlights.colorHistory(50);
%       image(permute(history.RGB, [3 1 2])); axis off
%       title("The last 50 CheerLights colors, oldest on the left")
%
%   Example: which colors people picked most
%       history = cheerlights.colorHistory(8000);
%       histogram(categorical(history.Name))
%
%   Errors with the ID cheerlights:feedUnavailable when the feed cannot be
%   reached.
%
%   See also cheerlights.currentColor, cheerlights.colors.

arguments
    count (1,1) double {mustBeInteger, mustBeInRange(count, 1, 8000)} = 10
end

history = cheerlights.internal.feed(count);
end
