classdef tLiveFeed < matlab.unittest.TestCase
    % Against the real CheerLights feed (needs the internet).

    methods (TestClassSetup)
        function needsTheFeed(testCase)
            try
                [~] = webread("https://api.thingspeak.com/channels/1417/feed.json", "results", 1, weboptions(Timeout=10));
            catch err
                testCase.assumeFail("The CheerLights feed cannot be reached: " + err.message);
            end
        end
    end

    methods (Test)
        function currentColorIsACheerLightsColor(testCase)
            color = cheerlights.currentColor();
            testCase.verifyEqual(sort(string(fieldnames(color)))', ["Hex" "Name" "RGB" "Time"]);
            testCase.verifyTrue(cheerlights.isValidColor(color.Name), color.Name);
            testCase.verifyEqual(color.Hex, cheerlights.colorToHex(color.Name));
            testCase.verifyEqual(color.RGB, cheerlights.hexToRGB(color.Hex));
            testCase.verifyEqual(color.Time.TimeZone, 'UTC');
            testCase.verifyLessThan(color.Time, datetime("now", TimeZone="UTC") + minutes(5));
        end

        function nameAndHexAgree(testCase)
            testCase.verifyTrue(cheerlights.isValidColor(cheerlights.currentColorName()));
            testCase.verifyTrue(cheerlights.internal.isHex(cheerlights.currentHex()));
        end

        function historyHasTheAskedCount(testCase)
            history = cheerlights.colorHistory(25);
            testCase.verifyEqual(height(history), 25);
            testCase.verifyTrue(issorted(history.Time));
            testCase.verifyTrue(issorted(history.EntryID));
            testCase.verifyEqual(height(cheerlights.colorHistory()), 10);
        end

        function watchCallsBackWithTheCurrentColor(testCase)
            box = containers.Map();   % a handle, so the callback can hand the color back
            t = cheerlights.watch(@(c) keep(box, c), Period=5);
            testCase.addTeardown(@() delete(t));
            deadline = tic;
            while toc(deadline) < 20 && ~isKey(box, "color")
                pause(0.25)
            end
            stop(t)
            testCase.assertTrue(isKey(box, "color"), "watch did not call back within 20 s");
            testCase.verifyTrue(cheerlights.isValidColor(box("color").Name));
        end
    end
end

function keep(box, color)
box("color") = color;   %#ok<NASGU> containers.Map is a handle; the caller reads it
end
