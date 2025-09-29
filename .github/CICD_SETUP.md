# GitHub Actions CI/CD Setup for Garmin Connect IQ

This document explains how to set up continuous integration and deployment for the Garmin Connect IQ watchface project.

## Current Build Process

The GitHub Actions workflow (`build.yml`) automates building the Garmin Connect IQ watchface and publishing artifacts. 

### What the Workflow Does

1. **Triggers**: Runs on push/PR to main/master branches, and can be manually triggered
2. **Environment Setup**: Installs Java 11 (required for Connect IQ SDK)
3. **SDK Installation**: Downloads and sets up the Connect IQ SDK
4. **Build**: Compiles the watchface using `monkeyc` compiler
5. **Artifact Publishing**: Uploads the built `.prg` file as a GitHub artifact

### Build Artifacts

- **Per-commit artifacts**: `fenix5x-clockwatch-{sha}` (30-day retention)
- **Latest builds**: `fenix5x-clockwatch-latest` (90-day retention, main/master only)
- **Releases**: Automatic release creation for Git tags

## Production SDK Setup

**Important**: The current workflow uses a demonstration build environment. For production use, you need to:

### Option 1: Host Your Own SDK

1. Download the official Connect IQ SDK from [Garmin Developer Portal](https://developer.garmin.com/connect-iq/)
2. Upload it to a private storage location (AWS S3, GitHub Releases, etc.)
3. Update the workflow to download from your hosted location:

```yaml
- name: Download Connect IQ SDK
  run: |
    wget -O sdk.zip "YOUR_HOSTED_SDK_URL"
    unzip sdk.zip -d ~/connectiq-sdk
    chmod +x ~/connectiq-sdk/bin/*
```

### Option 2: Use Docker

Create a Docker image with pre-installed SDK:

```dockerfile
FROM ubuntu:20.04
# Install SDK and dependencies
COPY connectiq-sdk/ /opt/connectiq-sdk/
ENV PATH="/opt/connectiq-sdk/bin:$PATH"
```

### Option 3: Self-Hosted Runners

Use GitHub self-hosted runners with pre-installed Connect IQ SDK:

1. Set up a self-hosted runner
2. Install Connect IQ SDK on the runner
3. Update workflow to use: `runs-on: self-hosted`

## Repository Secrets (if needed)

If you need to access private SDK downloads or signing keys:

1. Go to repository Settings → Secrets and variables → Actions
2. Add required secrets:
   - `CIQ_SDK_URL`: Private SDK download URL
   - `DEVELOPER_KEY`: For code signing (if needed)

## Workflow Customization

### Build Different Devices

To build for multiple devices, modify the build step:

```yaml
- name: Build for Multiple Devices
  run: |
    for device in fenix5x fenix6x vivoactive4; do
      monkeyc -d $device -o "Fenix5XClockwatch-$device.prg" -m manifest.xml source/*.mc -z resources/strings/strings.xml -z resources/drawables/drawables.xml
    done
```

### Add Testing

Add simulation testing:

```yaml
- name: Test in Simulator
  run: |
    # Start simulator in background
    connectiq &
    sleep 10
    
    # Run tests
    monkeydo Fenix5XClockwatch.prg fenix5x
```

### Code Quality Checks

Add linting and validation:

```yaml
- name: Validate Project Structure
  run: |
    # Check required files exist
    test -f manifest.xml
    test -f source/Fenix5XClockwatchApp.mc
    test -f resources/strings/strings.xml
    
    # Validate manifest
    xmllint --noout manifest.xml
```

## Deployment Options

### Manual Download

Users can download artifacts from:
- GitHub Actions runs
- Release pages (for tagged versions)

### Automatic Store Submission

For Connect IQ Store submission (requires additional setup):

```yaml
- name: Submit to Connect IQ Store
  if: startsWith(github.ref, 'refs/tags/')
  run: |
    # Upload to Connect IQ Store API
    # Requires store credentials and approval workflow
```

## Troubleshooting

### Common Issues

1. **SDK Download Fails**: Use your own hosted SDK or Docker approach
2. **Build Errors**: Check MonkeyC source compatibility
3. **Missing Permissions**: Ensure proper GitHub token permissions

### Local Testing

Test the workflow locally using [act](https://github.com/nektos/act):

```bash
# Install act
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run the workflow
act push
```

## Security Considerations

- Never commit developer keys or certificates
- Use GitHub Secrets for sensitive data
- Regularly update SDK versions
- Validate all inputs in build scripts

For more information, see the [Connect IQ Developer Documentation](https://developer.garmin.com/connect-iq/).