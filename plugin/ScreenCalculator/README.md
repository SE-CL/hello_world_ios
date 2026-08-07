# ScreenCalculator Theos plugin

This is a visible, user-triggered overlay scaffold. Build on a jailbroken device with Theos:

```sh
make package FINALPACKAGE=1
```

Install the generated `.deb` with a package manager, then respring. The blue `OCR` button is always visible and toggles a notification named `SCUserCaptureToggled`.

Screen capture and OCR should be connected only to an explicit user action and should reuse the Flutter/Vision pipeline. The scaffold intentionally does not implement hidden background capture.
