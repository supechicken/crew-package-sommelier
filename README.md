Patches and scripts for running sommelier on Chrome OS developer mode shell

## Contents
- `platform2/`: Git submodule, linked to `platform2` repository (contain source code of `sommelier`)
- `sommelier_src/`: Symbolic link to `platform2/vm_tools/sommelier` (source code of `sommelier`)
- `detect_dpi/`: Simple script for detecting the screen DPI (the DPI returned by `xdpyinfo` doesn't correct)
- `patches/`: Patches for running sommelier on Chrome OS natively.
- `sommelier-wrapper`: Wrapper script for `sommelier` binary, will insert `--drm-device` to command line (required by enabling hardware acceleration)
- `sommelier.env`: Set environment variables
- `sommelierd`: `sommelier` daemon manager
- `sommelierrc`: Executes by `sommelier` X11 daemon after `Xwayland` is ready, will set text DPI/cursor theme

#### `patches/`
- `data_driver.patch`: Re-add deleted `noop` data driver
- `shm_driver.patch`: Re-add deleted `noop` shm driver
- `virtwl_device.patch`: Set `virtwl` device to `/dev/null` (the `virtwl` device only exists on Crostini VMs)
- `drm_device.patch`: Re-add `--drm-device` command line parameter support, required by enabling hardware acceleration on X/Wayland

#### `detect_dpi/`
- `detect_dpi.html`: Used to import `detect_dpi.js`
- `detect_dpi.js`: Get screen DPI by mesuring a `div` with 1 inch wide in pixels
- `detect_dpi.rb`: Create an HTTP server for `detect_dpi.js`
- `http_server.rb`: An library for creating an HTTP server, adapted from [`crew-launcher`](https://github.com/chromebrew/crew-launcher/blob/stable/lib/http_server.rb)
