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

- **Dual timezone display** - Primary local time and secondary timezone with timezone names (EST, PST, CET, etc.)
- **Date display** with day of week
- **Heart rate (pulse) display** - Real-time heart rate monitoring
- **Battery percentage indicator** with color coding (Green >50%, Yellow 20-50%, Red <20%)
- **Step counter display** for daily activity tracking
- **Weekly run distance** tracking from activity data
- **Last run information** displaying recent running activity
- **Round watch optimized layout** - All data positioned for visibility on round displays

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
- **Secondary time**: Configurable timezone offset with timezone name display (e.g., EST, PST, CET)
- 12/24 hour format support based on device settings
- Real-time updates for both timezones
- Supports common timezones: EST, PST, MST, CST, AST, UTC, CET, EET, MSK, JST, AEST

### Heart Rate Monitor
- Real-time pulse/heart rate display in beats per minute (bpm)
- Shows "--" when heart rate data is unavailable
- Red color coding for visibility
- Positioned on the left side of the display

### Battery Indicator
- Color-coded battery percentage
- Green: >50%, Yellow: 20-50%, Red: <20%
- Positioned closer to center for round watch visibility

### Step Counter
- Shows current day's step count
- Positioned closer to center for round watch visibility
- Uses ActivityMonitor API

### Weekly Run Distance
- Displays total weekly running distance in kilometers
- Calculated from activity data
- Positioned for round watch visibility
- Orange color coding for visibility

### Last Run Information
- Shows distance of the most recent run
- Displays "No run" when no running activity is available
- Positioned for round watch visibility
- Purple color coding

### Date Display
- Shows day of week, month, and day
- Positioned below the timezones
- Uses medium-sized font

### Round Watch Optimization
- All corner elements moved closer to center for better visibility on round displays
- Layout adjusted to ensure all data is readable on circular watch faces

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
private var secondaryTimezoneOffset = -5; // EST
// Supported timezones with names:
// -8 = PST, -7 = MST, -6 = CST, -5 = EST, -4 = AST
// 0 = UTC, +1 = CET, +2 = EET, +3 = MSK
// +8 = CST (China), +9 = JST, +10 = AEST
// Other offsets will display as UTC+X
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