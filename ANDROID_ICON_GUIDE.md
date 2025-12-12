# Android App Icon Integration Guide

This guide explains how to generate and integrate Android app icons using your `app_logo.png` image.

## Overview

The Android app icon system uses multiple icon sizes for different contexts:
- **Launcher Icons**: Home screen icons (various densities)
- **Adaptive Icons**: Android 8.0+ dynamic icons with foreground/background layers

## What Was Generated

Using `flutter_launcher_icons`, the following files were automatically created:

### 1. Standard Launcher Icons
Located in `android/app/src/main/res/mipmap-*/ic_launcher.png`:
- `mipmap-mdpi`: 48×48px (0.75x)
- `mipmap-hdpi`: 72×72px (1.0x)
- `mipmap-xhdpi`: 96×96px (1.5x)
- `mipmap-xxhdpi`: 144×144px (2.0x)
- `mipmap-xxxhdpi`: 192×192px (3.0x)
- `mipmap-xxxxhdpi`: 256×256px (4.0x)

### 2. Adaptive Icons
Located in `android/app/src/main/res/mipmap-*/ic_launcher_foreground.png`:
- Same sizes as launcher icons
- White background with your logo as foreground

### 3. Configuration Files
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_foreground.xml`
- `android/app/src/main/res/values/colors.xml` (white background color)

## Manual Icon Generation (Optional)

If you want to regenerate icons manually or customize them:

### Using ImageMagick (Command Line)

```bash
# Install ImageMagick first
# Create all required sizes from app_logo.png
magick app_logo.png -resize 48x48 mipmap-mdpi/ic_launcher.png
magick app_logo.png -resize 72x72 mipmap-hdpi/ic_launcher.png
magick app_logo.png -resize 96x96 mipmap-xhdpi/ic_launcher.png
magick app_logo.png -resize 144x144 mipmap-xxhdpi/ic_launcher.png
magick app_logo.png -resize 192x192 mipmap-xxxhdpi/ic_launcher.png
magick app_logo.png -resize 256x256 mipmap-xxxxhdpi/ic_launcher.png
```

### Using Online Tools

1. **Android Asset Studio**: https://romannurik.github.io/AndroidAssetStudio/
   - Upload your `app_logo.png`
   - Select "Launcher Icons"
   - Customize padding, background, etc.
   - Download ZIP and extract to `android/app/src/main/res/`

2. **MakeAppIcon**: https://makeappicon.com/
   - Upload your logo
   - Download Android package
   - Extract to appropriate folders

## Adaptive Icon Guidelines

For Android 8.0+ adaptive icons, follow these guidelines:

### Icon Design Rules
- **Safe Zone**: Keep important content within the center 66×66dp area
- **Layer Separation**: Background and foreground should work independently
- **Transparency**: Foreground can have transparency, background should be opaque

### Recommended Specifications
- **Overall Size**: 108×108dp
- **Foreground**: 108×108dp (with 66dp safe zone)
- **Background**: 108×108dp solid color or simple pattern

### Creating Adaptive Icons Manually

```bash
# Create white background
magick -size 108x108 xc:white adaptive_background.png

# Create foreground (your logo centered)
magick app_logo.png -resize 80x80 -background transparent -gravity center -extent 108x108 adaptive_foreground.png

# Place in correct folders
cp adaptive_background.png android/app/src/main/res/drawable/ic_launcher_background.xml
cp adaptive_foreground.png android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png
```

## Testing Your Icons

### 1. Build and Run
```bash
flutter build apk
flutter install
```

### 2. Check Different Contexts
- Home screen (various launcher apps)
- App drawer
- Recent apps
- Settings → Apps list

### 3. Adaptive Icon Testing
- Long-press on home screen to see icon shapes
- Test on different Android versions (8.0+ for adaptive icons)
- Check on devices with different icon shapes (circle, square, rounded square, etc.)

## Troubleshooting

### Icons Not Updating
1. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```

2. Uninstall and reinstall the app:
   ```bash
   flutter uninstall
   flutter install
   ```

3. Clear app cache in device settings

### Icons Look Blurry
- Ensure your source `app_logo.png` is high resolution (at least 512×512px)
- Check that the image isn't stretched or distorted
- Verify the aspect ratio is maintained

### Adaptive Icon Issues
- Ensure foreground and background layers are properly separated
- Check that the foreground layer has transparency where needed
- Verify the safe zone content is within 66×66dp area

## Customization Options

### Change Icon Background Color
Edit `android/app/src/main/res/values/colors.xml`:
```xml
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>
```

### Round Icons (Legacy)
For devices that don't support adaptive icons, you can create round variants:
```bash
magick app_logo.png -resize 144x144 -background transparent -gravity center -extent 144x144 mipmap-xxhdpi/ic_launcher_round.png
```

### Update Manifest
Ensure `android/app/src/main/AndroidManifest.xml` references the correct icons:
```xml
<application
    android:icon="@mipmap/ic_launcher"
    android:roundIcon="@mipmap/ic_launcher_round"
    ...>
```

## Best Practices

1. **Source Image Quality**: Use a high-resolution PNG (512×512px or larger)
2. **Transparency**: Use PNG with transparency for better flexibility
3. **Simplicity**: Keep the design simple and recognizable at small sizes
4. **Contrast**: Ensure good contrast between icon and background
5. **Testing**: Test on various devices and Android versions

## Automation Script (Optional)

Create a script to regenerate icons automatically:

```bash
#!/bin/bash
# regenerate_icons.sh

INPUT="assets/icons/app_logo.png"
OUTPUT_DIR="android/app/src/main/res"

# Standard launcher icons
magick "$INPUT" -resize 48x48 "$OUTPUT_DIR/mipmap-mdpi/ic_launcher.png"
magick "$INPUT" -resize 72x72 "$OUTPUT_DIR/mipmap-hdpi/ic_launcher.png"
magick "$INPUT" -resize 96x96 "$OUTPUT_DIR/mipmap-xhdpi/ic_launcher.png"
magick "$INPUT" -resize 144x144 "$OUTPUT_DIR/mipmap-xxhdpi/ic_launcher.png"
magick "$INPUT" -resize 192x192 "$OUTPUT_DIR/mipmap-xxxhdpi/ic_launcher.png"

# Adaptive foreground
magick "$INPUT" -resize 108x108 -background transparent -gravity center -extent 108x108 "$OUTPUT_DIR/mipmap-xxxhdpi/ic_launcher_foreground.png"

echo "Icons regenerated successfully!"
```

Make it executable:
```bash
chmod +x regenerate_icons.sh
./regenerate_icons.sh
```

---

**Note**: This guide assumes you're using the `flutter_launcher_icons` package configuration in your `pubspec.yaml`. If you need to customize the configuration, edit the `flutter_launcher_icons` section in your pubspec file.
