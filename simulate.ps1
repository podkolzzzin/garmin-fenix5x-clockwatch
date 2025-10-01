# simulate.ps1 - Garmin Connect IQ Simulator Script
param(
    [switch]$StartOnly,
    [switch]$KillFirst,
    [switch]$Rebuild,
    [string]$Device = "fenix5x"
)

Write-Host "=== Garmin Connect IQ Simulator Script ===" -ForegroundColor Cyan
Write-Host "Project: Fenix5X Clockwatch" -ForegroundColor White
Write-Host "Target Device: $Device" -ForegroundColor White
Write-Host ""

# Configuration
$ProjectName = "Fenix5XClockwatch"
$OutputFile = "$ProjectName.prg"

# Kill existing simulator if requested
if ($KillFirst) {
    Write-Host "Stopping existing simulator processes..." -ForegroundColor Yellow
    Get-Process -Name "connectiq*" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    Write-Host ""
}

# Rebuild if requested
if ($Rebuild) {
    Write-Host "Rebuilding project first..." -ForegroundColor Yellow
    & .\rebuild.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Rebuild failed. Aborting simulation." -ForegroundColor Red
        exit 1
    }
    Write-Host ""
}

# Check if build artifact exists
if (-not (Test-Path $OutputFile)) {
    Write-Host "Build artifact not found: $OutputFile" -ForegroundColor Red
    Write-Host "Run rebuild first: .\rebuild.ps1" -ForegroundColor Yellow
    exit 1
}

# Show build info
$fileInfo = Get-Item $OutputFile
Write-Host "Using build: $($fileInfo.Name)" -ForegroundColor Green
Write-Host "Built: $($fileInfo.LastWriteTime)" -ForegroundColor Gray
Write-Host "Size: $([math]::Round($fileInfo.Length / 1KB, 2)) KB" -ForegroundColor Gray
Write-Host ""

# Check if simulator is already running
$simulatorRunning = Get-Process -Name "connectiq*" -ErrorAction SilentlyContinue
if ($simulatorRunning) {
    Write-Host "Simulator already running (PID: $($simulatorRunning.Id -join ', '))" -ForegroundColor Green
} else {
    Write-Host "Starting Connect IQ Simulator..." -ForegroundColor Yellow
    try {
        Start-Process "connectiq" -WindowStyle Normal
        Write-Host "Simulator started" -ForegroundColor Green
    } catch {
        Write-Host "Failed to start simulator: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Wait for simulator to be ready
if (-not $simulatorRunning) {
    Write-Host "Waiting for simulator to initialize..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
}

# Run the app unless StartOnly is specified
if (-not $StartOnly) {
    Write-Host ""
    Write-Host "Running watchface in simulator..." -ForegroundColor Yellow
    Write-Host "Command: monkeydo $OutputFile $Device" -ForegroundColor Gray
    
    try {
        $runOutput = & monkeydo $OutputFile $Device 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Watchface launched successfully" -ForegroundColor Green
        } else {
            Write-Host "Launch completed with warnings:" -ForegroundColor Yellow
            $runOutput | ForEach-Object {
                Write-Host "  $_" -ForegroundColor Gray
            }
        }
        
    } catch {
        Write-Host "Failed to run watchface: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Simulator Commands ===" -ForegroundColor Cyan
Write-Host "Restart simulator: .\simulate.ps1 -KillFirst" -ForegroundColor White
Write-Host "Rebuild and run: .\simulate.ps1 -Rebuild" -ForegroundColor White
Write-Host "Start only: .\simulate.ps1 -StartOnly" -ForegroundColor White
Write-Host ""
Write-Host "The simulator window should now be open with your watchface running." -ForegroundColor Green