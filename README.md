# CheerLights for MATLAB

A MATLAB package that reads the live CheerLights color, its history, and the CheerLights palette.

[![Release](https://img.shields.io/github/v/release/cheerlights/cheerlights-matlab-package)](https://github.com/cheerlights/cheerlights-matlab-package/releases) [![MATLAB](https://img.shields.io/badge/MATLAB-R2025b%2B-blue)](https://www.mathworks.com/products/matlab.html) [![CI](https://github.com/cheerlights/cheerlights-matlab-package/actions/workflows/ci.yml/badge.svg)](https://github.com/cheerlights/cheerlights-matlab-package/actions/workflows/ci.yml) [![License: MIT](https://img.shields.io/badge/license-MIT-yellow)](LICENSE)

[CheerLights](https://cheerlights.com) is a global network of lights that all show the same color, set by anyone on the [CheerLights Discord](https://cheerlights.com/discord).
This package reads the public CheerLights feed (ThingSpeak channel 1417), so a MATLAB figure, a plot, or hardware you drive from MATLAB can follow the color.
It needs no API key and no toolboxes beyond MATLAB.

## Quick start

Download `cheerlights.mltbx` from the [latest release](https://github.com/cheerlights/cheerlights-matlab-package/releases/latest), then install it in MATLAB R2026b or later:

```matlab
mpminstall("cheerlights.mltbx", Prompt=false)
```

In MATLAB R2025b, double-click the file or run `matlab.addons.install("cheerlights.mltbx")`.
Then read the current color:

```matlab
cheerlights.currentColor()
```

Installing prints a link to the [Getting Started guide](toolbox/doc/GettingStarted.m), which walks through the current color, the palette, the history, and `watch`.

## Example

```matlab
color = cheerlights.currentColor()
history = cheerlights.colorHistory(3)
cheerlights.hexToRGB(color.Hex, "uint8")
```

Output from version 1.0.0 in MATLAB R2026b on 2026-10-30:

```text
color =
  struct with fields:
    Name: "purple"
     Hex: "#800080"
     RGB: [0.5020 0 0.5020]
    Time: 30-Oct-2026 14:15:22

history =
  3×4 timetable
            Time              Name         Hex                    RGB                 EntryID
    ____________________    ________    _________    _____________________________    _______
    30-Oct-2026 13:28:03    "green"     "#008000"          0    0.50196          0    1067097
    30-Oct-2026 14:00:21    "cyan"      "#00ffff"          0          1          1    1067098
    30-Oct-2026 14:15:22    "purple"    "#800080"    0.50196          0    0.50196    1067099

ans =
  1×3 uint8 row vector
   128     0   128
```

`color.RGB` works anywhere MATLAB takes a color, such as `figure(Color=color.RGB)`.
The `uint8` triplet is what an RGB LED or a NeoPixel strip takes.

## Features

- The current color as a struct with its name, HEX value, RGB values, and the UTC time it was set: `cheerlights.currentColor()`, `currentColorName()`, `currentHex()`.
- The last 1 to 8000 color changes as a timetable, oldest first: `cheerlights.colorHistory(count)`.
- A function called each time the color changes, on a timer you stop and delete: `cheerlights.watch(@(c) set(f, Color=c.RGB))`.
- The 11 official colors with their HEX and RGB values, as the feed publishes them: `cheerlights.colors()`.
- Name and HEX helpers: `colorToHex("Old Lace")` gives `"#fdf5e6"`, `hexToRGB("#ffa500", "uint8")` gives `[255 165 0]`, `isValidColor(["red" "teal"])` gives `[true false]`.
- A 10-second timeout on every request, and errors with IDs you can catch: `cheerlights:feedUnavailable`, `cheerlights:noColor`, `cheerlights:unknownColor`, `cheerlights:invalidHex`.

Every function has help text: `help cheerlights.watch`.

## Limits

- It reads the color; it does not set it. Set the color with `/cheerlights red` on the [CheerLights Discord](https://cheerlights.com/discord).
- `watch` checks the feed on a timer, every 15 seconds by default and no faster than every 5. For changes the moment they happen, subscribe to `mqtt.cheerlights.com` with Industrial Communication Toolbox.
- Tested in MATLAB R2025b and R2026b on Windows.
  Building the package from source needs R2026b, for `matlab.toml` and `PackageTask`.

## Development

The repository is a MATLAB project defined by [`matlab.toml`](matlab.toml) (R2026b).
Clone it, then run the build from the project folder:

```matlab
buildtool            % code checks and unit tests (no network)
buildtool live       % tests against the real CheerLights feed
buildtool package    % release/cheerlights.mltbx, from the [[package]] table in matlab.toml
```

The package's name, version, and metadata live in `matlab.toml`; bump `version` there for a release.

## License

MIT, see [LICENSE](LICENSE).
CheerLights is a project by Hans Scharler.
Learn more and join in at [cheerlights.com](https://cheerlights.com).
