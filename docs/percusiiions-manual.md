<h1>Percusiiions Manual</h1>

A simple 16 step, 8 track, step sequencer. Pattern and settings persist through reboots.

- [General Info](#general-info)
- [Orientation](#orientation)
- [Step Page](#step-page)
- [Settings Page](#settings-page)

## General Info

Relies on host device to provide MIDI clock.

## Orientation

![Image of Grid orientation for Percusiiions]()

All documentation is relative to Grid (both Zero and One) oriented with the USB C port on the top left of the device.

Pages:

Reset the current page to default by holding all four corner buttons for 10 seconds.
Toggle between pages by holding any four adjacent pads for 2 seconds.

- Step
- Settings

> [!NOTE] Grid Zeros display both pages at the same time;
> Top half is Settings page, bottom half is Step page.

## Step Page

Bright light

## Settings Page

Each track has the following controls:

- Mute/unmute
- Clear
- Reset on stop toggle
- Manual reset (quantized to the incoming clock)
- Speed multiplier
- Record toggle
  - Flashes while on
  - Hold for 1 second to trigger one shot record which waits for the first step to start.
- Velocity
  - Hold to bring up velocity select view
- Shuffle type (last 4 pads of the row)
  - 0%
  - Groove (range of 3)
  - Custom (hold pad to "extract" the groove of the current track. Clears this shuffle pattern if the track sequence is empty when "extracting".)
