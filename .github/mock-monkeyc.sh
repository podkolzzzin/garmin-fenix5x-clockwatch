#!/bin/bash

# Mock MonkeyC compiler for CI demonstration
# This simulates the Garmin Connect IQ compiler behavior

# Parse arguments
DEVICE=""
OUTPUT=""
MANIFEST=""
SOURCES=()
RESOURCES=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -d)
      DEVICE="$2"
      shift 2
      ;;
    -o)
      OUTPUT="$2"
      shift 2
      ;;
    -m)
      MANIFEST="$2"
      shift 2
      ;;
    -z)
      RESOURCES+=("$2")
      shift 2
      ;;
    *.mc)
      SOURCES+=("$1")
      shift
      ;;
    *)
      shift
      ;;
  esac
done

echo "=== Connect IQ Build Simulation ==="
echo "Device: $DEVICE"
echo "Output: $OUTPUT"
echo "Manifest: $MANIFEST"
echo "Sources: ${SOURCES[*]}"
echo "Resources: ${RESOURCES[*]}"

# Validate required files exist
if [ ! -f "$MANIFEST" ]; then
  echo "Error: Manifest file not found: $MANIFEST"
  exit 1
fi

for src in "${SOURCES[@]}"; do
  if [ ! -f "$src" ]; then
    echo "Error: Source file not found: $src"
    exit 1
  fi
done

for res in "${RESOURCES[@]}"; do
  if [ ! -f "$res" ]; then
    echo "Error: Resource file not found: $res"
    exit 1
  fi
done

# Create output file
cat > "$OUTPUT" << 'EOF'
Garmin Connect IQ Application Package
Built with GitHub Actions
Device: TARGET_DEVICE
Build Date: BUILD_DATE
Note: This is a demonstration build
EOF

# Replace placeholders
sed -i "s/TARGET_DEVICE/$DEVICE/g" "$OUTPUT"
sed -i "s/BUILD_DATE/$(date)/g" "$OUTPUT"

echo "Build completed successfully: $OUTPUT"
echo "Note: This is a demonstration build. For actual deployment, use the official Garmin Connect IQ SDK."