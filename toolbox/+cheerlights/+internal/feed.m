function tt = feed(count)
%FEED Read the latest COUNT color changes from the CheerLights feed (ThingSpeak channel 1417).
%   TT = cheerlights.internal.feed(COUNT) returns a timetable, oldest first,
%   with the variables Name, Hex, RGB, and EntryID (see parseFeed).
%
%   Errors with the ID cheerlights:feedUnavailable when the feed cannot be
%   reached or answers with an error.

arguments
    count (1,1) double {mustBeInteger, mustBeInRange(count, 1, 8000)}
end

url = "https://api.thingspeak.com/channels/1417/feed.json";
options = weboptions(Timeout=10, ContentType="json");
try
    response = webread(url, "results", count, options);
catch cause
    err = MException("cheerlights:feedUnavailable", ...
        "Could not read the CheerLights feed: %s", cause.message);
    err = addCause(err, cause);
    throw(err)
end
tt = cheerlights.internal.parseFeed(response);
end
