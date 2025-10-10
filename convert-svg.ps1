# SVG to PNG Converter using Windows built-in tools
# This script attempts multiple methods to convert SVG to PNG

param(
    [string]$SvgPath = "C:\Users\User\Downloads\shoe-prints-solid-full.svg",
    [string]$OutputPath = "C:\Users\User\source\garmin-fenix5x-clockwatch\resources\steps-icon.png",
    [int]$Size = 24
)

Write-Host "Converting SVG to PNG..." -ForegroundColor Cyan
Write-Host "Input: $SvgPath"
Write-Host "Output: $OutputPath"
Write-Host "Size: ${Size}x${Size}px"
Write-Host ""

# Check if input file exists
if (-not (Test-Path $SvgPath)) {
    Write-Host "ERROR: SVG file not found at $SvgPath" -ForegroundColor Red
    exit 1
}

# Method 1: Try ImageMagick
if (Get-Command magick -ErrorAction SilentlyContinue) {
    Write-Host "Using ImageMagick..." -ForegroundColor Green
    & magick convert -background transparent -resize "${Size}x${Size}" $SvgPath $OutputPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Conversion successful!" -ForegroundColor Green
        exit 0
    }
}

# Method 2: Try Inkscape
if (Get-Command inkscape -ErrorAction SilentlyContinue) {
    Write-Host "Using Inkscape..." -ForegroundColor Green
    & inkscape --export-type=png --export-width=$Size --export-height=$Size $SvgPath -o $OutputPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Conversion successful!" -ForegroundColor Green
        exit 0
    }
}

# Method 3: Manual instructions
Write-Host "No conversion tools found." -ForegroundColor Yellow
Write-Host ""
Write-Host "Please use one of these methods:" -ForegroundColor Yellow
Write-Host "1. Online: Go to https://cloudconvert.com/svg-to-png" -ForegroundColor White
Write-Host "   - Upload: $SvgPath" -ForegroundColor Gray
Write-Host "   - Set size: ${Size}x${Size}px" -ForegroundColor Gray
Write-Host "   - Download to: $OutputPath" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Install ImageMagick (recommended):" -ForegroundColor White
Write-Host "   winget install ImageMagick.ImageMagick" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Install Inkscape:" -ForegroundColor White
Write-Host "   winget install Inkscape.Inkscape" -ForegroundColor Gray

exit 1
