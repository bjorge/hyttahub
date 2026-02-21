# Template Example

This is a Flutter template application that includes a Tauri 2 wrapper for native desktop builds.

## Building for Desktop (macOS, Windows, Linux)

To build a native desktop executable that uses the stable Firebase Web SDK instead of native CocoaPods or C++ binaries, you can use the included Tauri wrapper.

### Prerequisites

1. Ensure you have the [Rust toolchain](https://rustup.rs/) installed:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
2. Ensure you have the Tauri CLI installed:
   ```bash
   cargo install tauri-cli --version "^2.0.0"
   ```

### Build Commands

From this `template` directory, run the following commands sequentially:

1. Build the Flutter Web application:
   ```bash
   flutter build web
   ```

2. Package the web build into a native desktop application using Tauri:
   ```bash
   cd src-tauri
   cargo tauri build
   ```

The compiled executables and installers (e.g., `.app` and `.dmg` for macOS, `.exe` for Windows, `.AppImage` for Linux) will be generated inside the `src-tauri/target/release/bundle/` directory.

### Development Mode & Debugging

If you want to run the desktop app in development mode (which enables the right-click "Inspect Element" Web Inspector for debugging Firebase):

```bash
flutter build web
cd src-tauri
cargo tauri dev
```
