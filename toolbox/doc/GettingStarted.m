%% Getting Started with CheerLights
% CheerLights is a global network of lights that all show the same color.
% Anyone can change it, and every CheerLights light in the world follows.
% This package reads that color into MATLAB, so a figure, a plot, or a
% piece of hardware you control from MATLAB can follow it too.
%
% The color comes from the public CheerLights feed, ThingSpeak channel 1417.
% No account or key is needed. Learn more at <https://cheerlights.com cheerlights.com>.

%% The current color
% |cheerlights.currentColor| returns the color's name, HEX value, RGB values
% from 0 to 1, and the time it was set (UTC).
color = cheerlights.currentColor()

%%
% The RGB values work anywhere MATLAB takes a color.
figure(Color=color.RGB, Name="CheerLights is " + color.Name);

%% Change the color
% Set the color from the CheerLights Discord server with a command such as
% |/cheerlights red|. Join at <https://cheerlights.com/discord cheerlights.com/discord>.
% The new color reaches the feed, and every light picks it up the next time
% it checks.

%% The official colors
% CheerLights has eleven colors. |cheerlights.colors| lists them with their
% HEX and RGB values.
palette = cheerlights.colors()

%%
% Convert between names, HEX values, and RGB values. Case and spaces in
% names do not matter.
cheerlights.colorToHex("Old Lace")
cheerlights.hexToRGB("#ffa500")
cheerlights.hexToRGB("#ffa500", "uint8")   % 0 to 255, for LED strips
cheerlights.isValidColor(["red" "teal"])

%% The history
% |cheerlights.colorHistory| returns up to 8000 past changes as a
% timetable, oldest first.
history = cheerlights.colorHistory(50);
head(history)

%%
% Draw the last 50 colors as a strip, oldest on the left.
figure
image(permute(history.RGB, [3 1 2]))
axis off
title("The last 50 CheerLights colors")

%% Follow the color as it changes
% |cheerlights.watch| checks the feed every 15 seconds by default and calls your
% function with each new color. It returns a timer; stop and delete it
% when you are done.
f = figure;
t = cheerlights.watch(@(c) set(f, Color=c.RGB, Name="CheerLights is " + c.Name));

%%
% Stop following the color.
stop(t)
delete(t)
