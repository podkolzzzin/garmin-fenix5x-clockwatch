# rebuild.ps1 - Garmin Connect IQ Project Rebuild Script
param(
    [switch]$Clean,
    [switch]$Release,
    [switch]$Verbose
)

Write-Host "=== Garmin Connect IQ Rebuild Script ===" -ForegroundColor Cyan
Write-Host "Project: Fenix5X Clockwatch" -ForegroundColor White
Write-Host ""

# Configuration
$ProjectName = "Fenix5XClockwatch"
$OutputFile = "$ProjectName.prg"
$Device = "fenix5x"
$JungleFile = "monkey.jungle"
$DeveloperKey = "developer_key"

# Check dependencies
if (-not (Test-Path $JungleFile)) {
    Write-Host "ERROR: monkey.jungle not found" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $DeveloperKey)) {
    Write-Host "ERROR: Developer key not found" -ForegroundColor Red
    exit 1
}

# Clean if requested
if ($Clean) {
    Write-Host "Cleaning build artifacts..." -ForegroundColor Yellow
    Remove-Item "*.prg" -Force -ErrorAction SilentlyContinue
    Remove-Item "*.debug.xml" -Force -ErrorAction SilentlyContinue
    Remove-Item "bin/" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "gen/" -Recurse -Force -ErrorAction SilentlyContinue
}

# Build
Write-Host "Building project..." -ForegroundColor Yellow
$buildArgs = @("-d", $Device, "-o", $OutputFile, "-f", $JungleFile, "-y", $DeveloperKey, "--warn")

if ($Release) {
    $buildArgs += "-r"
    Write-Host "Build type: Release" -ForegroundColor Green
} else {
    Write-Host "Build type: Debug" -ForegroundColor Green
}

if ($Verbose) {
    $buildArgs += "-g"
}

Write-Host "Command: monkeyc $($buildArgs -join ' ')" -ForegroundColor Gray
Write-Host ""

try {
    $buildOutput = & monkeyc @buildArgs 2>&1
    $buildSuccess = $LASTEXITCODE -eq 0
    
    $buildOutput | ForEach-Object {
        $line = $_.ToString()
        if ($line -match "ERROR:") {
            Write-Host $line -ForegroundColor Red
        } elseif ($line -match "WARNING:") {
            Write-Host $line -ForegroundColor Yellow
        } else {
            Write-Host $line -ForegroundColor Gray
        }
    }
    
    Write-Host ""
    
    if ($buildSuccess) {
        Write-Host "BUILD SUCCESSFUL" -ForegroundColor Green
        
        if (Test-Path $OutputFile) {
            $fileInfo = Get-Item $OutputFile
            Write-Host "Output: $($fileInfo.Name) ($([math]::Round($fileInfo.Length / 1KB, 2)) KB)" -ForegroundColor Green
            Write-Host "Built: $($fileInfo.LastWriteTime)" -ForegroundColor Gray
        }
        
        Write-Host ""
        Write-Host "Ready to run: .\simulate.ps1" -ForegroundColor Cyan
        
    } else {
        Write-Host "BUILD FAILED" -ForegroundColor Red
        exit 1
    }
    
} catch {
    Write-Host "BUILD ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== Build Complete ===" -ForegroundColor Cyan