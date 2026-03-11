# iClick

**iClick** is a lightweight macOS auto-clicker built with **SwiftUI**.

It simulates mouse clicks at a configurable rate, which can be useful for testing, repetitive tasks, or accessibility workflows.

## Requirements

- macOS (Apple Silicon or Intel)
- Xcode (to build/run from source)

## Permissions (Important)

iClick uses macOS **Accessibility** permissions to simulate mouse clicks.

When you first run the app, macOS will prompt you to grant access:

1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Enable **iClick**
3. Quit and relaunch the app if needed

> This project includes an `NSAccessibilityUsageDescription` entry in `Info.plist` explaining why the permission is required.

## Build & Run (from source)

1. Clone the repo
2. Open the project in **Xcode**
3. Select the **iClick** scheme
4. Run (`⌘R`)

## Tech Stack

- Swift
- SwiftUI
- macOS Accessibility APIs (for input simulation)

## Roadmap / Ideas

- Start/Stop toggle + global hotkey
- Click interval (CPS) slider
- Choose mouse button (left/right)
- Click at cursor vs fixed coordinates
- Click count limit (e.g., stop after N clicks)
- Menu bar mode (status bar app)

## Disclaimer

Use responsibly. Auto-clicking may violate the terms of service of some apps/games/websites. You are responsible for how you use this tool.

## License

Add a license if you plan to distribute this publicly (MIT, Apache-2.0, etc.).
