function t = watch(callback, options)
%WATCH Call a function each time the CheerLights color changes.
%   T = cheerlights.watch(CALLBACK) checks the CheerLights feed every 15
%   seconds and calls CALLBACK(COLOR) with the new color each time it
%   changes, starting with the current color. COLOR is the struct that
%   cheerlights.currentColor returns. T is the running timer; stop it with
%   stop(T) and delete(T).
%
%   T = cheerlights.watch(CALLBACK, Period=SECONDS) checks every SECONDS
%   seconds instead, 5 or more.
%
%   Example: print each new color as it arrives
%       t = cheerlights.watch(@(c) fprintf("%s  %s\n", c.Name, c.Hex));
%       % ...later
%       stop(t); delete(t)
%
%   Example: keep a figure in the current color
%       f = figure;
%       t = cheerlights.watch(@(c) set(f, Color=c.RGB));
%
%   A feed that cannot be reached is skipped with a warning
%   (cheerlights:watchSkipped) and checked again on the next period.
%
%   See also cheerlights.currentColor, timer.

arguments
    callback (1,1) function_handle
    options.Period (1,1) double {mustBeGreaterThanOrEqual(options.Period, 5)} = 15
end

t = timer(Name="CheerLights watch", Period=options.Period, ...
    ExecutionMode="fixedSpacing", BusyMode="drop", ...
    TimerFcn=@check, UserData=struct(EntryID=int64(-1), Name=""));
start(t)

    function check(src, ~)
        try
            latest = cheerlights.internal.feed(1);
        catch err
            warning("cheerlights:watchSkipped", "Skipped a CheerLights check: %s", err.message)
            return
        end
        if isempty(latest)
            return
        end
        latest = latest(end, :);
        seen = src.UserData;
        if latest.EntryID == seen.EntryID || latest.Name == seen.Name
            src.UserData.EntryID = latest.EntryID;
            return
        end
        src.UserData = struct(EntryID=latest.EntryID, Name=latest.Name);
        callback(struct(Name=latest.Name, Hex=latest.Hex, RGB=latest.RGB, Time=latest.Time))
    end
end
