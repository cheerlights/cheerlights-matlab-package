classdef tParseFeed < matlab.unittest.TestCase
    % Reading ThingSpeak feed responses (no network): a real response saved
    % from channel 1417 and the odd shapes the feed has produced over the years.

    methods (Test)
        function realResponse(testCase)
            response = jsondecode(fileread(fullfile(fileparts(mfilename("fullpath")), "..", "fixtures", "feed-5.json")));
            tt = cheerlights.internal.parseFeed(response);

            testCase.verifyClass(tt, "timetable");
            testCase.verifyEqual(height(tt), 5);
            testCase.verifyEqual(tt.Properties.VariableNames, {'Name', 'Hex', 'RGB', 'EntryID'});
            testCase.verifyEqual(tt.Properties.DimensionNames{1}, 'Time');
            testCase.verifyEqual(tt.Name', ["blue" "oldlace" "green" "cyan" "purple"]);
            testCase.verifyEqual(tt.Hex(end), "#800080");
            testCase.verifyEqual(tt.RGB(end, :), [128 0 128] / 255);
            testCase.verifyEqual(tt.EntryID(end), int64(1067099));
            testCase.verifyEqual(tt.Time(end), datetime(2026, 10, 30, 14, 15, 22, TimeZone="UTC"));
            testCase.verifyTrue(issorted(tt.Time));
        end

        function missingHexComesFromTheName(testCase)
            response = struct(feeds=struct(created_at="2013-12-24T23:59:00Z", entry_id=7, field1="Warm White", field2=[]));
            tt = cheerlights.internal.parseFeed(response);
            testCase.verifyEqual(tt.Name, "warm white");
            testCase.verifyEqual(tt.Hex, "#fdf5e6");
        end

        function unknownNameKeepsNaNColor(testCase)
            response = struct(feeds=struct(created_at="2012-01-01T00:00:00Z", entry_id=8, field1="plum", field2=[]));
            tt = cheerlights.internal.parseFeed(response);
            testCase.verifyEqual(tt.Hex, "");
            testCase.verifyTrue(all(isnan(tt.RGB)));
        end

        function entriesWithDifferentFields(testCase)
            % jsondecode (and webread) give a cell array when entries do not share fields
            response = jsondecode(['{"feeds":[' ...
                '{"created_at":"2026-10-30T14:00:21Z","entry_id":2,"field1":"cyan","field2":"#00FFFF"},' ...
                '{"created_at":"2026-10-30T13:00:00Z","entry_id":1,"field1":"red"},' ...
                '{"created_at":"2026-10-30T14:30:00Z","entry_id":3,"field1":null,"field2":null}]}']);
            testCase.assertClass(response.feeds, "cell");
            tt = cheerlights.internal.parseFeed(response);
            testCase.verifyEqual(tt.Name, ["red"; "cyan"], "oldest first, the empty entry dropped");
            testCase.verifyEqual(tt.Hex, ["#ff0000"; "#00ffff"]);
        end

        function emptyFeed(testCase)
            tt = cheerlights.internal.parseFeed(struct(feeds=[]));
            testCase.verifyEqual(height(tt), 0);
            testCase.verifyEqual(tt.Properties.VariableNames, {'Name', 'Hex', 'RGB', 'EntryID'});
            testCase.verifyEqual(height(cheerlights.internal.parseFeed(struct())), 0);
        end
    end
end
