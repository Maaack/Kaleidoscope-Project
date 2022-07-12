# Kaleidoscope Project
A Godot Wild Jam #47 gamejam game. Theme is "Symmetry"

Made in Godot 3.4.4

## Installation
The project requires that the Wwise `addons/wwise/bin/` be populated
with the build of Wwise for your specific hardware.
1. Go to https://github.com/alessandrofama/wwise-godot-integration/releases
2. Download the zip for your system (ie. Win64, MacOS, Linux).
3. Unzip the archive.
4. From the archive, navigate down until you see two folders `debug` and `release`.
5. Go up one folder.
6. Copy the folder (ie. `win64`, `linux`)
7. Navigate to `addons/wwise/bin/` from your project root directory.
8. Paste folder into the directory.

Resulting structure should look similar to the following:
`/addons/wwise/bin/linux/debug/libWwiseGDNative.so`
`/addons/wwise/bin/linux/release/libWwiseGDNative.so`

Make sure `Wwise` has checked `Enable` in the Plugins menu of your Project Settings. 