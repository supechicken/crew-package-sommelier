## Patches for running sommelier on Chrome OS shell
- `data_driver.patch`: Re-add deleted `noop` data driver
- `direct_scale.patch`: Re-add [direct scale mode](https://chromium-review.googlesource.com/c/chromiumos/platform2/+/3700920) (reverted), necessary for fixing the scale
- `drm_device.patch`: Re-add `--drm-device` command line parameter support, necessary for enabling hardware acceleration
- `shm_driver.patch`: Re-add deleted `noop` shm driver
- `virtwl_device.patch`: Set `virtwl` device to `/dev/null` (the `virtwl` device only exists on Crostini VMs)
