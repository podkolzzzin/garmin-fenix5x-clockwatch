# Copilot Instructions for Garmin Connect IQ Watchface

## Project Overview
This is a **Garmin Connect IQ watchface** written in **MonkeyC** for the Fenix 5X. The architecture follows Garmin's MVC pattern with three core components:
- `Fenix5XClockwatchApp.mc` - Application entry point that returns initial view/delegate pair
- `Fenix5XClockwatchView.mc` - WatchFace view that handles all UI rendering 
- `Fenix5XClockwatchDelegate.mc` - Input delegate for user interactions and power management

## Key Architecture Patterns

### Resource-Driven UI
- Layouts defined in `resources/layouts/layout.xml` with `Rez.Layouts.WatchFace(dc)` 
- Strings externalized in `resources/strings/strings.xml` using `@Strings.AppName`
- Drawables managed via `resources/drawables/drawables.xml` with `@Drawables.LauncherIcon`
- Access resources using `Rez.` namespace in MonkeyC code

### Drawing Pattern in onUpdate()
The view's `onUpdate(dc)` method follows this pattern:
1. Clear screen: `dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK); dc.clear()`
2. Set color before each draw: `dc.setColor(foreground, background)`
3. Use `dc.drawText(x, y, font, text, justification)` for all text elements
4. Helper functions (`drawBattery`, `drawSteps`) for modular UI components

### System Data Access
- Time: `System.getClockTime()` for hours/minutes, `Gregorian.info(Time.now())` for date
- Device settings: `System.getDeviceSettings().is24Hour` for time format
- Battery: `System.getSystemStats().battery` (returns percentage as float)
- Activity data: `ActivityMonitor.getInfo().steps` (can be null, handle gracefully)

## Development Workflow

### Building & Testing
```powershell
# Build for Fenix 5X (primary command)
monkeyc -d fenix5x -o Fenix5XClockwatch.prg -m manifest.xml source/*.mc -z resources/strings/strings.xml -z resources/drawables/drawables.xml

# Run in simulator 
connectiq &
monkeydo Fenix5XClockwatch.prg fenix5x
```

### Project Configuration
- `manifest.xml`: Defines app metadata, device compatibility (`fenix5x`), permissions (`Positioning`)
- `monkey.jungle`: Build configuration with source/resource paths per device
- Entry point must match `manifest.xml` entry attribute (`Fenix5XClockwatchApp`)

## Code Conventions

### Import Organization
Always import required Toybox modules at file top:
```monkeyc
import Toybox.Graphics;      // For drawing operations
import Toybox.System;        // For device/time data
import Toybox.WatchUi;       // For UI classes
import Toybox.ActivityMonitor; // For fitness data
```

### Error Handling Patterns
- Null checks for activity data: `info.steps != null ? info.steps : 0`
- Power management via `onPowerBudgetExceeded()` in delegate
- Use `System.println()` for debugging output

### Color Coding Standards
This project uses specific color patterns:
- Battery: Green (>50%), Yellow (20-50%), Red (<20%)
- Time/Date: White on transparent background
- Steps: Blue text
- Always set color before drawing: `dc.setColor(foreground, Graphics.COLOR_TRANSPARENT)`

## Device-Specific Considerations
- **Fenix 5X only**: Product ID `fenix5x` in manifest
- Screen positioning uses `dc.getWidth()/2` and `dc.getHeight()/2` for center-based layouts
- Font sizes: `FONT_LARGE` for time, `FONT_SMALL` for date, `FONT_TINY` for status indicators
- Text positioning: Use absolute coordinates (e.g., `20, 20` for top-left, `dc.getWidth() - 20, 20` for top-right)

## When Making Changes
- UI modifications go in `Fenix5XClockwatchView.onUpdate()`
- New features may require additional permissions in `manifest.xml`
- Resource changes need corresponding XML updates in `resources/` folders
- Always test in simulator before device deployment
- Use `monkeyc` command with proper device target and resource flags