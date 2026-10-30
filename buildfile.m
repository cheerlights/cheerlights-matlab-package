function plan = buildfile
%BUILDFILE Build the CheerLights package: check the code, run the tests, package the .mltbx.
%   buildtool              check and unit tests (no network)
%   buildtool live         tests against the real CheerLights feed
%   buildtool package      check, unit tests, then release/cheerlights.mltbx from matlab.toml

import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

plan("clean") = CleanTask;

plan("check") = CodeIssuesTask(["toolbox" "tests"], ...
    WarningThreshold=0, ...
    Results="results/code-issues.sarif");

plan("test") = TestTask("tests/unit", ...
    SourceFiles="toolbox", ...
    Dependencies="check", ...
    TestResults="results/test-results.xml") ...
    .addCodeCoverage("results/coverage.xml");

plan("live") = TestTask("tests/live", ...
    SourceFiles="toolbox", ...
    TestResults="results/live-results.xml", ...
    Description="Run the tests against the real CheerLights feed");

plan("package") = PackageTask(Dependencies="test");

plan.DefaultTasks = ["check" "test"];
end
