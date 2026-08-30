<h1>Iiinst & Siiiq</h1>

A collection of instrument and sequencer scripts for iii devices.

- [Scripts](#scripts)
- [Installation](#installation)
- [Running diii locally](#running-diii-locally)
  - [Install diii](#install-diii)
  - [Launch diii](#launch-diii)
  - [Installing scripts locally](#installing-scripts-locally)
- [Troubleshooting](#troubleshooting)
  - [Flip Device Mode](#flip-device-mode)
  - [DeviceNotFoundError(f"can't find iii device")](#devicenotfounderrorfcant-find-iii-device)
  - [Uploading script gets stuck on "-- receiving script" step](#uploading-script-gets-stuck-on----receiving-script-step)
- [Credits](#credits)

## Scripts

| Name                                                              | Compatable Devices  | Type       | Description                             |
| ----------------------------------------------------------------- | ------------------- | ---------- | --------------------------------------- |
| [Piiiano](./manuals/piiiano-manual.pdf)                           | Grid (Zero and One) | Instrument | Grid based chromatic midi keyboard      |
| [Iiimpact](./manuals/iiimpact-manual.pdf)                         | Grid (Zero and One) | Instrument | Drum pad midi instrument                |
| [Fadiiir](./manuals/fadiiir-manual.pdf)                           | Grid (Zero and One) | Controller | 16 configurable virtual faders          |
| [Percusiiions](./manuals/percusiiions-manual.pdf)                 | Grid (Zero and One) | Sequencer  | Simple 16 step, 8 track, step sequencer |
| [Melodiiies](./manuals/melodiiies-manual.pdf)                     | Grid (Zero and One) | Sequencer  | Scale aware polyphonic step sequencer   |
| [Multiii Body Problem](./manuals/multiii-body-problem-manual.pdf) | Arc                 | Sequencer  | Scale aware polyphonic step sequencer   |

## Installation

> [!NOTE] Make sure your iii device is running the latest firmware! Updating firmware can be done via the diii browser tool linked below.

1. Open [`https://monome.org/diii/`](https://monome.org/diii/) in your browser
2. Connect your iii device
3. Click `Connect` to link your iii device. *Make sure it is in iii mode, not the regular serial mode!*
4. Click `Upload` and select the script of choice from your computer.

> [!NOTE] It is good practice to clear any active iii scripts before installing a new one. If a larger script is already running while attempting to upload a new script, the upload can fail.

## Running diii locally

This is an alternative to using [`https://monome.org/diii/`](https://monome.org/diii/) in your browser. This method is mostly for development purposes, it is not recommended for most users.

### Install diii

Based on steps outlined in the monome [diii cli install docs](https://monome.org/docs/iii/diii-cli/).

1. Install [uv](https://docs.astral.sh/uv/#installation).

### Launch diii

![diii console image](images/diii_console.png)

**VS Code:**

1. Run the Launch diii task: `ctrl+shift+p` type `run task` and select `Launch diii`
2. Terminal: Open a new terminal in VS Code and run `diii`

**Terminal:**

```bash
# Windows (PowerShell):
./.venv/Scripts/activate.ps1; diii

# Linux/MacOS (Bash):
source .venv/Scripts/activate && diii
```

To exit `diii`, type `q` into the console and press `enter`. For other `diii` commands check out the docs [here](https://github.com/monome/iii?tab=readme-ov-file#run).

### Installing scripts locally

**VS Code Steps:**

1. Open this folder in VS Code
2. Run launch diii Task: `ctrl+shift+p` type `run task` and select `Launch diii`
3. Connect your iii enabled `Arc` or `Grid` (Zero/One)
4. Run the commands below

**Command Line Steps:**

1. Choose a script to install from the [Scripts](#scripts) section.
2. Launch `diii` *[see this for more details](#launch-diii).*
3. Connect your iii enabled `Arc` or `Grid` (Zero/One)
4. Open your terminal of choice and run the following commands:

```bash
^^clear
^^upload <path to the script>
```

## Troubleshooting

### Flip Device Mode

Here is a [description of device modes](https://github.com/monome/iii?tab=readme-ov-file#modes) when running `iii` compatible firmware. Follow steps outlined in that section of the `iii` docs to flip the device between `iii` and `standard serial` modes.

### DeviceNotFoundError(f"can't find iii device")

Error message:

```shell
  File "C:\Users\jguza\source\repos\iiiano\.venv\Lib\site-packages\diii\cli.py", line 43, in upload
    iii.connect()
  File "C:\Users\jguza\source\repos\iiiano\.venv\Lib\site-packages\diii\iii.py", line 48, in connect
    self.serial = self.find_device()
                  ^^^^^^^^^^^^^^^^^^
  File "C:\Users\jguza\source\repos\iiiano\.venv\Lib\site-packages\diii\iii.py", line 30, in find_device
    portinfo = find_serial_port('USB VID:PID=CAFE:1101')
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "C:\Users\jguza\source\repos\iiiano\.venv\Lib\site-packages\diii\iii.py", line 21, in find_serial_port
    raise DeviceNotFoundError(f"can't find iii device")
diii.exceptions.DeviceNotFoundError: can't find iii device
```

**Solution:** This is likely due to the device not connected to the computer or not being in iii mode. Follow the instructions [here](https://github.com/monome/iii?tab=readme-ov-file#modes) to flip modes.

If you run into a problem that isn't captured in this section, please [submit issues here](https://github.com/JGuzak/iiiano/issues). Make sure to include things like system information and screenshots/logs for the best chance of assistance.

### Uploading script gets stuck on "-- receiving script" step

Sometimes scripts don't clear properly when attempting to upload new scripts.

**Solution:** Follow one of the two suggestions to clear the currently loaded script then re-flash the desired script:

- [force clear iii script by following steps outlined in the `iii` docs](https://github.com/monome/iii?tab=readme-ov-file#modes)
- disconnect/reconnect the device, launch `diii` if it isn't already running, run `^^c` to clear the script

## Credits

Big thanks to the following individuals for testing early builds, suggesting features, and being over all great humans;

- Juicy Noise Bits
