classdef tArguments < matlab.unittest.TestCase
    % Argument checks that fail before anything reaches the network.

    methods (Test)
        function historyCountRange(testCase)
            for bad = {0, 8001, 2.5, -1, NaN, [5 6]}
                testCase.verifyError(@() cheerlights.colorHistory(bad{1}), ?MException);
            end
        end

        function watchNeedsAFunctionHandle(testCase)
            testCase.verifyError(@() cheerlights.watch("disp"), ?MException);
        end

        function watchPeriodAtLeastFiveSeconds(testCase)
            testCase.verifyError(@() cheerlights.watch(@disp, Period=1), "MATLAB:validators:mustBeGreaterThanOrEqual");
        end
    end
end
