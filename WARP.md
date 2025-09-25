# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Garmin Connect IQ watchface application specifically designed for the Fenix 5X smartwatch, written in MonkeyC. The project implements a clean, minimalist clockwatch with battery indicator, step counter, time, and date display.

## Development Commands

### Building
```pwsh
# Build the watchface for Fenix 5X
monkeyc -d fenix5x -o Fenix5XClockwatch.prg -m manifest.xml source/*.mc -z resources/strings/strings.xml -z resources/drawables/drawables.xml
```

### Testing and Simulation
```pwsh
# Start the Connect IQ simulator (background process)
Start-Process connectiq

# Run in simulator after building
monkeydo Fenix5XClockwatch.prg fenix5x
```

### Resource Compilation
```pwsh
# Compile individual resource files if needed
monkeyc -z resources/strings/strings.xml
monkeyc -z resources/drawables/drawables.xml
```

## Architecture Overview

### Core Components
- **`Fenix5XClockwatchApp.mc`**: Main application entry point extending `Application.AppBase`. Manages app lifecycle and returns the initial view/delegate pair.
- **`Fenix5XClockwatchView.mc`**: Primary watchface view extending `WatchUi.WatchFace`. Handles all drawing operations, time formatting, and display updates.
- **`Fenix5XClockwatchDelegate.mc`**: Input delegate extending `WatchUi.WatchFaceDelegate`. Currently handles power budget management for performance monitoring.

### Display Architecture
The watchface uses a manual drawing approach rather than relying heavily on XML layouts:
- Time display: Centered large font with 12/24 hour format detection
- Date display: Below time using medium font with day/month/day format
- Battery indicator: Top-left corner with color coding (Green >50%, Yellow 20-50%, Red <20%)
- Step counter: Top-right corner showing daily step count via ActivityMonitor API

### Resource Structure
- **`manifest.xml`**: Defines app metadata, permissions (Positioning), target device (fenix5x), and SDK requirements
- **`resources/layouts/layout.xml`**: Minimal layout with TimeLabel (though mostly unused due to manual drawing)
- **`resources/strings/strings.xml`**: Localized strings (currently only AppName)
- **`resources/drawables/drawables.xml`**: Drawable resources including launcher icon

## Key Technical Details

### Time and Date Handling
- Uses `System.getClockTime()` for current time
- Respects device 12/24 hour setting via `System.getDeviceSettings().is24Hour`
- Date formatting uses `Time.Gregorian.info()` with `FORMAT_MEDIUM`

### System Integration
- Battery level from `System.getSystemStats().battery`
- Activity data from `ActivityMonitor.getInfo().steps`
- Device settings integration for time format preferences

### Performance Considerations
- Power budget monitoring implemented in delegate
- Separate sleep/wake lifecycle methods for power optimization
- Manual drawing reduces resource overhead compared to complex layouts

## Development Notes

### Device Compatibility
Currently targets only Fenix 5X (product ID "fenix5x" in manifest.xml). To add device support, modify the `<iq:products>` section in manifest.xml with additional product IDs.

### Customization Points
- Color constants are hardcoded in view methods - extract to constants for easier theming
- Layout positioning uses fixed pixel offsets - could benefit from responsive positioning
- Font sizes are fixed - consider dynamic sizing based on display dimensions

### MonkeyC Specifics
- Uses Toybox imports for all system APIs
- Leverages type annotations (`as Dc`, `as Void`, etc.) for Connect IQ 3.0+ compatibility
- Error handling is minimal - consider adding null checks for ActivityMonitor data

## Required Tools

- Garmin Connect IQ SDK (minimum version 1.2.0 as specified in manifest)
- MonkeyC compiler (`monkeyc` command)
- Connect IQ simulator (`connectiq` command)
- MonkeyDo test runner (`monkeydo` command)