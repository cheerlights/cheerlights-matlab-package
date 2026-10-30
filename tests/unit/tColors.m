classdef tColors < matlab.unittest.TestCase
    % The color table and the name and HEX conversions (no network).

    methods (Test)
        function elevenOfficialColors(testCase)
            palette = cheerlights.colors();
            testCase.verifySize(palette, [11 3]);
            testCase.verifyEqual(palette.Properties.VariableNames, {'Name', 'Hex', 'RGB'});
            testCase.verifyEqual(palette.Name(1:3), ["red"; "green"; "blue"]);
            testCase.verifyEqual(palette.Hex(palette.Name == "oldlace"), "#fdf5e6");
            testCase.verifyEqual(palette.RGB(palette.Name == "green", :), [0 128 0] / 255);
        end

        function colorToHexKnownNames(testCase)
            testCase.verifyEqual(cheerlights.colorToHex("green"), "#008000");
            testCase.verifyEqual(cheerlights.colorToHex('orange'), "#ffa500");
            testCase.verifyEqual(cheerlights.colorToHex(["red" "pink"]), ["#ff0000" "#ffc0cb"]);
        end

        function colorToHexIgnoresCaseAndSpaces(testCase)
            testCase.verifyEqual(cheerlights.colorToHex("Old Lace"), "#fdf5e6");
            testCase.verifyEqual(cheerlights.colorToHex("  MAGENTA "), "#ff00ff");
        end

        function warmwhiteMeansOldlace(testCase)
            testCase.verifyEqual(cheerlights.colorToHex("warmwhite"), "#fdf5e6");
            testCase.verifyTrue(cheerlights.isValidColor("Warm White"));
        end

        function colorToHexUnknownNameErrors(testCase)
            testCase.verifyError(@() cheerlights.colorToHex("teal"), "cheerlights:unknownColor");
            testCase.verifyError(@() cheerlights.colorToHex(["red" "teal"]), "cheerlights:unknownColor");
        end

        function isValidColorIsElementwise(testCase)
            testCase.verifyEqual(cheerlights.isValidColor(["Red" "teal"; "cyan" ""]), [true false; true false]);
            testCase.verifyFalse(cheerlights.isValidColor("#ff0000"));
        end

        function hexToRGBDouble(testCase)
            testCase.verifyEqual(cheerlights.hexToRGB("#ffa500"), [255 165 0] / 255);
            testCase.verifyEqual(cheerlights.hexToRGB('00FFff'), [0 1 1]);
        end

        function hexToRGBUint8(testCase)
            rgb = cheerlights.hexToRGB("#ffa500", "uint8");
            testCase.verifyClass(rgb, "uint8");
            testCase.verifyEqual(rgb, uint8([255 165 0]));
        end

        function hexToRGBOneRowPerValue(testCase)
            testCase.verifyEqual(cheerlights.hexToRGB(["#ff0000" "#0000ff"], "uint8"), uint8([255 0 0; 0 0 255]));
        end

        function hexToRGBRejectsBadValues(testCase)
            for bad = ["#ff00", "#gg0000", "red", "#ff00000", ""]
                testCase.verifyError(@() cheerlights.hexToRGB(bad), "cheerlights:invalidHex", bad);
            end
        end

        function hexToRGBRejectsUnknownOutputType(testCase)
            testCase.verifyError(@() cheerlights.hexToRGB("#ff0000", "single"), "MATLAB:validators:mustBeMember");
        end
    end
end
