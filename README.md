# Fenix 5X Clockwatch

A custom clockwatch face designed specifically for the Garmin Fenix 5X smartwatch.

## Features

- Clean, minimalist time display
- Date display with day of week
- Battery percentage indicator with color coding
- Step counter display
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

## Features Implementation

### Time Display
- 12/24 hour format support based on device settings
- Centered display with large font
- Real-time updates

### Battery Indicator
- Color-coded battery percentage
- Green: >50%, Yellow: 20-50%, Red: <20%
- Displayed in top-left corner

### Step Counter
- Shows current day's step count
- Displayed in top-right corner
- Uses ActivityMonitor API

### Date Display
- Shows day of week, month, and day
- Positioned below the time
- Uses medium-sized font

## Customization

The clockwatch can be customized by modifying:

- **Colors**: Edit the color constants in `Fenix5XClockwatchView.mc`
- **Layout**: Modify positioning in the `onUpdate()` method
- **Features**: Add/remove elements by editing the drawing functions
- **Resources**: Add custom fonts or images in the resources directory

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