# Fenix 5X Clockwatch

[![Build Status](https://github.com/podkolzzzin/garmin-fenix5x-clockwatch/workflows/Build%20Garmin%20Connect%20IQ%20Watchface/badge.svg)](https://github.com/podkolzzzin/garmin-fenix5x-clockwatch/actions)

A custom clockwatch face designed specifically for the Garmin Fenix 5X smartwatch.

## Quick Start

### Download Pre-built Watchface

1. Go to the [Actions](https://github.com/podkolzzzin/garmin-fenix5x-clockwatch/actions) tab
2. Click on the latest successful build
3. Download the `fenix5x-clockwatch-latest` artifact
4. Extract the `.prg` file and install it on your Fenix 5X

### Install on Device

1. Connect your Fenix 5X to your computer via USB
2. Copy the `Fenix5XClockwatch.prg` file to the `GARMIN/APPS` folder on your device
3. Safely eject your device
4. On your watch, go to Settings → Watch Face → Connect IQ and select the new watchface

## Features

- **Dual timezone display** - Primary local time and secondary timezone
- **Date display** with day of week
- **Battery percentage indicator** with color coding (Green >50%, Yellow 20-50%, Red <20%)
- **Step counter display** for daily activity tracking
- **Weekly run distance** tracking from activity data
- **Last run information** displaying recent running activity
- Optimized for Fenix 5X display dimensions

## Project Structure

```
├── source/                          # MonkeyC source files
│   ├── Fenix5XClockwatchApp.mc     # Main application entry point
│   ├── Fenix5XClockwatchView.mc    # Watch face view implementation  
│   └── Fenix5XClockwatchDelegate.mc # Input delegate for user interactions
├── resources/                       # Resource files
│   ├── drawables/                   # Images and icons
│   ├── fonts/                       # Custom fonts (if any)
│   ├── layouts/                     # UI layout definitions
│   ├── strings/                     # Localized strings
│   └── settings/                    # App settings (if any)
├── manifest.xml                     # App manifest and device compatibility
└── README.md                        # This file
```

## Development Setup

1. **Install Garmin Connect IQ SDK**
   - Download from [Garmin Developer Portal](https://developer.garmin.com/connect-iq/)
   - Add the SDK bin directory to your PATH

2. **Install Visual Studio Code with Connect IQ Extension** (recommended)
   - Install the "Connect IQ" extension for VS Code
   - Configure the extension to point to your SDK installation

3. **Alternative: Use Eclipse with Connect IQ Plugin**
   - Download Eclipse IDE
   - Install the Connect IQ plugin from Garmin

## Building the Project

Using Connect IQ SDK command line:

```bash
# Generate project files (if needed)
monkeyc -o Fenix5XClockwatch.prg -m manifest.xml -z resources/strings/strings.xml -z resources/drawables/drawables.xml source/*.mc

# Build for Fenix 5X
monkeyc -d fenix5x -o Fenix5XClockwatch.prg -m manifest.xml $(shell find . -name "*.mc") -z $(shell find resources -name "*.xml")
```

## Testing

1. **Simulator Testing**
   ```bash
   # Start the simulator
   connectiq &
   
   # Run in simulator
   monkeydo Fenix5XClockwatch.prg fenix5x
   ```

2. **Device Testing**
   - Connect your Fenix 5X via USB
   - Use Garmin Express or Connect IQ app to sideload
   - Or use `monkeydo` with device connection

## Continuous Integration

This project includes automated build and artifact publishing using GitHub Actions:

### GitHub Actions Workflow

- **Triggers**: Automatic builds on push/PR to main/master branches, plus manual trigger
- **Build Process**: Compiles the watchface using Garmin Connect IQ SDK
- **Artifacts**: Publishes `.prg` files for download from GitHub Actions
- **Releases**: Automatic release creation for Git tags

### Downloading Built Artifacts

1. **Latest Builds**: Go to Actions tab → select latest workflow run → download artifacts
2. **Releases**: Check the Releases page for tagged versions
3. **Per-commit**: Each commit generates an artifact with the commit SHA

### Setting Up Production Builds

The current workflow uses a demonstration environment. For production builds with the official Garmin SDK:

1. See `.github/CICD_SETUP.md` for detailed setup instructions
2. Host the official Connect IQ SDK in your own storage
3. Update the workflow to download from your hosted location

For more details, see [CI/CD Setup Guide](.github/CICD_SETUP.md).

## Features Implementation

### Dual Timezone Display
- **Primary time**: Local timezone displayed prominently in the center
- **Secondary time**: Configurable timezone offset (default: UTC-5)
- 12/24 hour format support based on device settings
- Real-time updates for both timezones

### Battery Indicator
- Color-coded battery percentage
- Green: >50%, Yellow: 20-50%, Red: <20%
- Displayed in top-left corner

### Step Counter
- Shows current day's step count
- Displayed in top-right corner
- Uses ActivityMonitor API

### Weekly Run Distance
- Displays total weekly running distance in kilometers
- Calculated from activity data
- Positioned in bottom-left corner
- Orange color coding for visibility

### Last Run Information
- Shows distance of the most recent run
- Displays "No data" when no running activity is available
- Positioned in bottom-right corner
- Purple color coding

### Date Display
- Shows day of week, month, and day
- Positioned below the timezones
- Uses medium-sized font

## Customization

The clockwatch can be customized by modifying:

- **Colors**: Edit the color constants in `Fenix5XClockwatchView.mc`
- **Layout**: Modify positioning in the `onUpdate()` method
- **Secondary timezone**: Change the `secondaryTimezoneOffset` variable (in hours from local time)
- **Features**: Add/remove elements by editing the drawing functions
- **Resources**: Add custom fonts or images in the resources directory

### Timezone Configuration
To change the secondary timezone, edit the `secondaryTimezoneOffset` variable in `Fenix5XClockwatchView.mc`:
```monkeyc
private var secondaryTimezoneOffset = -5; // UTC-5 (EST)
// Examples:
// 0 = UTC
// +1 = Central European Time
// -8 = Pacific Standard Time
```

## Device Compatibility

This clockwatch is specifically designed for:
- Garmin Fenix 5X

To support additional devices, update the `manifest.xml` file with additional product IDs.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on simulator and device
5. Submit a pull request

## License

This project is open source. See LICENSE file for details.

## Resources

- [Garmin Connect IQ Documentation](https://developer.garmin.com/connect-iq/)
- [Connect IQ API Reference](https://developer.garmin.com/connect-iq/api-docs/)
- [MonkeyC Programming Guide](https://developer.garmin.com/connect-iq/programmers-guide/)