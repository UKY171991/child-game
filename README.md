# 🎮 Fun Kids Learning App

Welcome to your new Flutter app! This app is designed to help children learn alphabets, numbers, and have fun popping balloons!

## 🚀 Quick Start (Web)
The easiest way to run the app **right now** is on the Web, as it requires no extra installation.

```powershell
flutter run -d chrome
```

## 🛠️ Troubleshooting & Setup

### 1. Windows App (`flutter run -d windows`)
**Error:** `Unable to find suitable Visual Studio toolchain`
**Fix:** You need to install Visual Studio 2022 (Community Edition is free).
1.  Download from [visualstudio.microsoft.com](https://visualstudio.microsoft.com/downloads/).
2.  During installation, check the box **"Desktop development with C++"**.
3.  After install, run `flutter doctor` to verify.

### 2. Mobile App (`flutter run -d android`)
**Issue:** No connected devices found.
**Fix:**
*   **Real Phone:** Connect your Android phone via USB and enable **USB Debugging** in "Developer Options".
*   **Emulator:** Open Android Studio, go to "Device Manager", and create/start a virtual device.
*   **Check Emulators:** Run `flutter emulators` to see available ones. Launch one with `flutter emulators --launch <device_id>`.

## ✨ Features
*   **🅰️ Learn:** Interactive Alphabet and Number grids.
*   **🎈 Play:** A fun "Pop the Ball" game with score tracking.
*   **🎨 Design:** Colorful, animated, and child-friendly interface.

## 📦 Commands
*   `flutter run -d chrome` - Run on Web.
*   `flutter run -d windows` - Run on Windows (requires VS C++).
*   `flutter run -d android` - Run on Android (requires device).
*   `flutter build apk` - Build an installation file for Android.
