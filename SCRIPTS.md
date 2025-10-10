# Development Scripts Usage Guide

This project includes two PowerShell scripts to streamline development:

## rebuild.ps1 - Build Script

Rebuilds the Connect IQ project with various options.

### Basic Usage:
```powershell
.\rebuild.ps1                # Standard debug build
.\rebuild.ps1 -Release       # Release build (optimized, no debug info)
.\rebuild.ps1 -Clean         # Clean build artifacts first
.\rebuild.ps1 -Verbose       # Show detailed build output
```

### Combined Options:
```powershell
.\rebuild.ps1 -Clean -Release -Verbose
```

## simulate.ps1 - Simulator Script

Starts the Connect IQ simulator and runs your watchface.

### Basic Usage:
```powershell
.\simulate.ps1              # Run latest build in simulator
.\simulate.ps1 -Rebuild     # Rebuild first, then run
.\simulate.ps1 -StartOnly   # Just start simulator, don't run app
.\simulate.ps1 -KillFirst   # Kill existing simulator first
```

### Combined Options:
```powershell
.\simulate.ps1 -KillFirst -Rebuild  # Fresh start: kill simulator, rebuild, run
```

## Typical Development Workflow:

1. **Initial build**: `.\rebuild.ps1`
2. **Test in simulator**: `.\simulate.ps1`
3. **Make code changes**
4. **Quick rebuild and test**: `.\simulate.ps1 -Rebuild`
5. **Clean release build**: `.\rebuild.ps1 -Clean -Release`

## Notes:

- Scripts automatically check for required files (monkey.jungle, developer_key)
- Build output shows warnings and errors with color coding
- Simulator automatically starts if not already running
- Scripts provide helpful status messages and next steps

Both scripts are designed to be run from the project root directory.