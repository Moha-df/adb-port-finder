# ADB Port Scanner

A port scanning tool for wireless ADB (Android Debug Bridge) connection.

## Description

This Windows batch script automatically scans Android device ports to establish a wireless ADB connection. It uses Nmap to detect open ports and attempts to connect via ADB.

## Why This Tool?

Android devices have a known limitation where the ADB port changes dynamically, even after setting it with `adb tcpip`. This happens because:
- The port can change after device reboot
- The port can change when wireless debugging is toggled
- The port can change when the device reconnects to WiFi

This tool solves this problem by automatically scanning and finding the correct port, eliminating the need to manually check the Wireless Debugging settings each time.

> **Note:** While the port changes dynamically, you can set a static IP address for your Android device in your router settings or through the device's network configuration. This ensures you always know the device's IP address, making it easier to use this tool.

## Prerequisites

- Windows OS
- [Nmap](https://nmap.org/download.html)
- [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools) (ADB)

## Installation

1. Install Nmap from the [official website](https://nmap.org/download.html)
2. Install Android SDK Platform Tools from [Google's website](https://developer.android.com/studio/releases/platform-tools)
3. Add installation paths to your system PATH

## Usage

```bash
adb_nmap_scanner.bat <IP_ADDRESS>
```

Example:
```bash
adb_nmap_scanner.bat 192.168.0.100
```

## Features

- Automatic scan of default ADB port (5555)
- Scan of port ranges 30000-50000, 50000-65535, and 1-29999
- Automatic ADB connection testing on each open port
- Detailed error messages and troubleshooting suggestions

## Troubleshooting

If the connection fails, verify that:
- Wireless debugging is enabled on your tablet
- The IP address is correct
- The tablet and PC are on the same WiFi network

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details. 